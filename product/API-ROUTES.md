# API ROUTES — Healer MVP (Next.js 15 App Router)

**Versão:** 1.0 · 2026-05-02
**Base path:** `/api`
**Auth padrão:** Supabase JWT no cookie (middleware Next.js valida em toda rota privada exceto webhooks)
**Erro padrão:** JSON `{ error: { code, message, hint? } }`
**Rate limit base:** Upstash Redis ou Vercel KV — bucket por `user_id`
**Streaming:** SSE (`text/event-stream`) para chat

---

## 0. Convenções globais

### Headers obrigatórios em rotas privadas
- `Cookie: sb-access-token=...` (validado por middleware)
- Falha de auth → `401 { error: { code: 'unauthorized', message: 'Faça login pra continuar' } }`

### Códigos de erro padronizados
| code | HTTP | Quando |
|---|---|---|
| `unauthorized` | 401 | Sem JWT ou JWT inválido |
| `forbidden` | 403 | Tier não permite (ex: Sonnet pra Estagiário) |
| `not_found` | 404 | Recurso não existe ou não pertence ao user |
| `validation_error` | 400 | Payload inválido |
| `rate_limited` | 429 | Cap diário ou rate limit batido |
| `cap_codex` | 402 | Bateu cap de códices do tier |
| `cap_consultations` | 402 | Bateu cap de consultas/dia |
| `query_blocked` | 403 | Compliance bloqueou query (ver COMPLIANCE.md) |
| `internal_error` | 500 | Erro inesperado |
| `service_unavailable` | 503 | LLM/embedding API fora |

### Eventos PostHog disparados
Sempre incluir `userId`, `tier`, e props específicas. Listados em cada rota.

---

## 1. AUTH

Auth gerenciado pelo Supabase Auth + Next Auth helpers `@supabase/auth-helpers-nextjs`. Não há rotas custom de auth no MVP — só Google OAuth via Supabase callback padrão `/auth/callback`.

---

## 2. CODICES

### 2.1 `POST /api/codices` — Iniciar upload

**Auth:** sim
**Rate limit:** 10 uploads / hora / user
**Content-Type:** `multipart/form-data`

**Payload (FormData):**
- `file`: File (PDF, ≤ 80MB)
- `title?`: string (default = nome do arquivo)

**Validações:**
1. MIME `application/pdf` → senão `validation_error`
2. Size ≤ 80 * 1024 * 1024 → senão `validation_error`
3. User não bateu `tier_caps.max_codices` (count `codices` where `deleted_at IS NULL`) → senão `cap_codex`

**Comportamento:**
1. Upload pra Supabase Storage bucket `codices/{user_id}/{codex_id}.pdf`
2. Insert em `codices` com `status='processing'`, `cover_seed = sha256(title)`
3. Dispara job assíncrono de parsing (via `/api/internal/parse-codex` chamada com queue ou diretamente via `waitUntil()` da Vercel)
4. Responde imediatamente com `codex_id`

**Response 201:**
```json
{
  "codex": {
    "id": "uuid",
    "title": "Robbins Patologia",
    "status": "processing",
    "file_size_bytes": 45000000,
    "created_at": "2026-05-02T..."
  }
}
```

**Eventos PostHog:** `codex_uploaded { size_mb, codex_id }`

---

### 2.2 `GET /api/codices` — Listar códices do user

**Auth:** sim
**Rate limit:** 60/min

**Query params:**
- `category?`: codex_category
- `search?`: string (filtro server-side `ILIKE` em title)
- `limit?`: int (default 50, max 100)
- `offset?`: int

**Response 200:**
```json
{
  "codices": [
    {
      "id": "uuid",
      "title": "Robbins Patologia",
      "category": "patologia",
      "status": "ready",
      "page_count": 1487,
      "consultations_count": 23,
      "last_consulted_at": "2026-05-01T...",
      "cover_seed": "abc123...",
      "created_at": "..."
    }
  ],
  "total": 12
}
```

---

### 2.3 `GET /api/codices/:id` — Detalhe do códice

**Auth:** sim · ownership obrigatório

**Response 200:**
```json
{
  "codex": { ...mesmo schema acima... }
}
```

**Errors:** `not_found` se id não existe ou não é do user.

---

### 2.4 `GET /api/codices/:id/status` — Polling de status de processing

**Auth:** sim · ownership
**Rate limit:** 30/min (polling intensivo — 1x/2s permitido por 60s)

**Response 200:**
```json
{
  "status": "processing",
  "progress_pct": 67,
  "estimated_seconds_remaining": 25,
  "page_count": 1487,
  "message": "Indexando capítulo 42 de 60"
}
```

Quando `status = 'failed'`:
```json
{
  "status": "failed",
  "message": "PDF parece escaneado sem texto. Tenta um PDF com texto pesquisável."
}
```

---

### 2.5 `PATCH /api/codices/:id` — Editar título/categoria

**Auth:** sim · ownership

**Payload:**
```json
{ "title"?: "...", "category"?: "patologia" }
```

**Response 200:** `{ codex: {...} }`

---

### 2.6 `DELETE /api/codices/:id` — Excluir códice

**Auth:** sim · ownership

**Comportamento:**
- Soft delete (`deleted_at = now()`)
- Cron job hard delete em 30d (deleta storage file + chunks via CASCADE)

**Response 204:** sem body

**Eventos PostHog:** `codex_deleted { codex_id }`

---

### 2.7 `GET /api/codices/:id/page/:page_num` — Preview do PDF na página

**Auth:** sim · ownership

**Comportamento:** retorna signed URL do storage (5min TTL) + metadados da página

**Response 200:**
```json
{
  "signed_url": "https://...supabase.co/...?token=...",
  "page": 437,
  "expires_at": "2026-05-02T..."
}
```

---

### 2.8 `POST /api/internal/parse-codex` — Worker de parsing (interno)

**Auth:** Bearer com `INTERNAL_WORKER_SECRET` (não expor publicamente)

**Payload:**
```json
{ "codex_id": "uuid" }
```

**Comportamento:**
1. Download PDF do storage
2. Extrair texto + page_count com `pdf-parse`
3. Chunking 800 tokens / overlap 100 (lib `tiktoken` ou `gpt-tokenizer`)
4. Embedding em batch de 100 (`openai.embeddings.create`)
5. Bulk insert em `chunks`
6. Categorização: pega 2000 tokens iniciais, chama Haiku 4.5 com prompt de categorização → grava sugestão
7. Update `codices.status='ready'`, `page_count`

**Response 200:** `{ status: 'ready', chunks_created: N, page_count: M }`

**Em caso de erro:** atualiza `codices.status='failed'`, `status_message`

---

## 3. CONSULTATIONS (chat)

### 3.1 `POST /api/consultations` — Enviar anamnese (streaming SSE)

**Auth:** sim · ownership do codex
**Rate limit:** tier-based (50/300/1000/1500 por dia)
**Content-Type response:** `text/event-stream`

**Payload:**
```json
{
  "codex_id": "uuid",
  "query": "Explica fisiopato da IC esquerda",
  "slash_command": "explicar"  // opcional, enum: resumir|explicar|quizar|caso|diferenciar|dose
}
```

**Validações pré-execução:**
1. Auth OK
2. Codex existe + pertence ao user + status='ready' → senão `not_found`
3. User não bateu `consultations_today >= tier_caps.max_consultations_day` → senão `cap_consultations`
4. Se `slash_command='dose'` ou query suspeita: passa pelo intent classifier (ver COMPLIANCE)
5. Se classifier bloqueia: salva `consultations` com `blocked=true`, retorna SSE com 1 evento `blocked`:
   ```
   event: blocked
   data: {"reason":"clinical_decision","message":"🩺 Pera aí..."}
   ```

**Comportamento (happy path):**
1. Embed query (`openai.embeddings.create`)
2. RPC `search_chunks(codex_id, embedding, top_k=tier_specific, threshold=0.65)`
3. Monta system prompt com chunks + cache_control
4. Roteia modelo:
   - `tier in [estagiario, residente]` OR `slash_command in [resumir, explicar, quizar]` → Haiku 4.5
   - `tier in [clinico, mestre]` AND `slash_command in [caso, diferenciar, dose]` → Sonnet 4.5
   - Override: usuário Clínico/Mestre pode forçar Haiku via param `model_preference='fast'`
5. Stream Anthropic com prompt cache
6. Forward tokens via SSE:
   ```
   event: token
   data: {"text":"A insuficiência cardíaca esquerda..."}
   ```
7. Ao final, salva `consultations` row completa + dispara evento PostHog
8. Evento final:
   ```
   event: done
   data: {"consultation_id":"uuid","tokens_input":1200,"tokens_output":520,"tokens_cached":1100,"cost_brl_cents":2}
   ```

**Cancel:**
- Frontend abort → server detecta `req.signal.aborted` → cancela stream Anthropic via `controller.abort()`
- Salva `consultations` com `response` parcial

**Eventos PostHog:** `consultation_sent { codex_id, slash_command, model, tokens_input, tokens_output, cost_brl_cents }`, `consultation_blocked { reason }`

---

### 3.2 `GET /api/consultations` — Listar histórico

**Auth:** sim

**Query params:**
- `codex_id?`: filtro por códice
- `slash_command?`: filtro
- `search?`: ILIKE em query
- `limit?`: int (default 20, max 100)
- `offset?`: int

**Response 200:**
```json
{
  "consultations": [
    {
      "id": "uuid",
      "codex_id": "uuid",
      "query": "Explica fisiopato...",
      "response_preview": "A insuficiência cardíaca esquerda ocorre quando...",
      "slash_command": "explicar",
      "created_at": "..."
    }
  ],
  "total": 142
}
```

---

### 3.3 `GET /api/consultations/:id` — Detalhe da consulta (full)

**Auth:** sim · ownership

**Response 200:**
```json
{
  "consultation": {
    "id": "...",
    "query": "...",
    "response": "... markdown completo ...",
    "citations": [{"page": 437, "chunk_id": "..."}],
    "model_used": "claude-haiku-4-5",
    "user_feedback": null,
    "created_at": "..."
  }
}
```

---

### 3.4 `PATCH /api/consultations/:id/feedback` — Thumbs up/down

**Auth:** sim · ownership

**Payload:**
```json
{ "feedback": 1 }  // 1, -1, ou null
```

**Response 200:** `{ ok: true }`

**Eventos PostHog:** `consultation_feedback { feedback, slash_command, model }`

---

### 3.5 `DELETE /api/consultations/:id` — Excluir consulta

**Auth:** sim · ownership

**Response 204**

---

## 4. BILLING

### 4.1 `POST /api/billing/subscribe` — Iniciar assinatura

**Auth:** sim
**Rate limit:** 5 attempts/hour

**Payload:**
```json
{
  "tier": "residente",
  "period": "monthly"  // monthly | yearly | lifetime (lifetime só pra mestre)
}
```

**Validações:**
- `(tier, period)` combinação válida (ex: estagiario não tem período pago)
- User não tem subscription ativa do mesmo tier

**Comportamento:**
1. Cria/atualiza customer no Asaas (`asaas.customer.create` ou get existing)
2. Cria assinatura no Asaas (`asaas.subscriptions.create`) com `billingType='PIX'`, `cycle='MONTHLY|YEARLY'`, `nextDueDate=today+1`
3. Para `lifetime`: cria pagamento avulso no Asaas (`asaas.payments.create`) sem subscription
4. Pega QR Code Pix da primeira fatura/pagamento
5. Insere `subscriptions` row com `status='pending'`
6. Retorna QR Code

**Response 201:**
```json
{
  "subscription_id": "uuid",
  "payment_id": "asaas_pay_id",
  "pix": {
    "qr_code_base64": "...",
    "qr_code_text": "00020126...",
    "expires_at": "2026-05-02T13:05:00Z"
  },
  "amount_brl_cents": 1490
}
```

**Eventos PostHog:** `checkout_started { tier, period, amount_brl_cents }`

---

### 4.2 `GET /api/billing/payment/:asaas_payment_id` — Polling status pagamento

**Auth:** sim · ownership

**Comportamento:** consulta Asaas (`asaas.payments.get`)

**Response 200:**
```json
{
  "status": "PENDING" | "RECEIVED" | "CONFIRMED" | "EXPIRED",
  "subscription_id": "uuid",
  "tier_after_confirm": "residente"
}
```

---

### 4.3 `GET /api/billing/subscription` — Subscription ativa do user

**Auth:** sim

**Response 200:**
```json
{
  "subscription": {
    "tier": "residente",
    "status": "active",
    "period": "monthly",
    "current_period_end": "2026-06-02T...",
    "cancel_at_period_end": false,
    "amount_brl_cents": 1490
  }
}
```

Se sem subscription: `{ "subscription": null, "tier": "estagiario" }`

---

### 4.4 `DELETE /api/billing/subscription` — Cancelar

**Auth:** sim · ownership

**Comportamento:**
1. Chama `asaas.subscriptions.cancel`
2. Atualiza `subscriptions.cancel_at_period_end=true`, `canceled_at=now()`
3. NÃO downgrade imediato — mantém tier até `current_period_end`
4. Cron diário verifica `current_period_end < now()` e faz downgrade pra estagiario

**Response 200:**
```json
{
  "ok": true,
  "access_until": "2026-06-02T..."
}
```

**Eventos PostHog:** `subscription_canceled { tier, days_active }`

---

### 4.5 `POST /api/billing/webhook` — Webhook Asaas

**Auth:** Header `asaas-access-token` validado contra `ASAAS_WEBHOOK_TOKEN`
**Rate limit:** sem (Asaas já cuida)

**Payload (Asaas events):**
- `PAYMENT_CONFIRMED` → upgrade tier
- `PAYMENT_OVERDUE` → status='past_due'
- `SUBSCRIPTION_DELETED` → status='canceled'
- etc

**Comportamento:**
1. Insere `billing_events` row com `processed=false`
2. Processa idempotentemente (verifica `asaas_payload->>'id'` único)
3. Atualiza `subscriptions` + `user_profiles.tier` conforme evento
4. Marca `billing_events.processed=true`

**Response 200:** `{ ok: true }`

**IMPORTANTE:** retornar 200 mesmo se erro interno (Asaas retry exponential — evitar loops). Logar em Sentry.

---

## 5. USER

### 5.1 `GET /api/users/me` — Perfil do user

**Auth:** sim

**Response 200:**
```json
{
  "user": {
    "id": "uuid",
    "email": "marina@example.com",
    "display_name": "Marina",
    "avatar_url": "...",
    "tier": "residente",
    "consultations_today": 47,
    "consultations_today_limit": 300,
    "codices_count": 8,
    "codices_limit": 15,
    "compliance_accepted_at": "2026-04-15T..."
  }
}
```

---

### 5.2 `PATCH /api/users/me` — Atualizar perfil

**Auth:** sim

**Payload:**
```json
{
  "display_name"?: "...",
  "compliance_accepted_at"?: true,  // marca aceite
  "terms_accepted_at"?: true,
  "privacy_accepted_at"?: true
}
```

**Response 200:** `{ user: {...} }`

---

### 5.3 `DELETE /api/users/me` — Excluir conta (LGPD)

**Auth:** sim
**Rate limit:** 1/dia (proteção contra clique acidental + força confirmação)

**Comportamento:**
1. Soft delete `user_profiles.deleted_at = now()`
2. Soft delete todos `codices` do user
3. Cancela subscription ativa (Asaas)
4. Cron 30d hard delete tudo (CASCADE)
5. Logout imediato

**Response 200:** `{ ok: true, hard_delete_at: "2026-06-01T..." }`

---

## 6. INTERNAL / CRON

### 6.1 `POST /api/cron/reset-daily-consultations`
**Auth:** Bearer `CRON_SECRET` (Vercel Cron)
**Schedule:** `0 3 * * *` (00:00 BRT = 03:00 UTC)
**Comportamento:** chama RPC `reset_daily_consultations()`

### 6.2 `POST /api/cron/hard-delete-old`
**Auth:** Bearer `CRON_SECRET`
**Schedule:** `0 4 * * *`
**Comportamento:** chama RPC `hard_delete_old_soft_deleted()` + remove storage files órfãos

### 6.3 `POST /api/cron/expire-subscriptions`
**Auth:** Bearer `CRON_SECRET`
**Schedule:** `0 5 * * *`
**Comportamento:**
- Subscriptions com `current_period_end < now() AND cancel_at_period_end=true` → `status='expired'`, downgrade user pra estagiario
- Subscriptions `past_due` há > 7d → `status='canceled'`, downgrade

---

## 7. RATE LIMITING — política consolidada

| Rota | Limite |
|---|---|
| `POST /api/codices` | 10/h |
| `POST /api/consultations` | tier (50/300/1000/1500 por dia) + 30/min antiabuse |
| `GET /api/codices/:id/status` | 30/min |
| `POST /api/billing/subscribe` | 5/h |
| `DELETE /api/users/me` | 1/d |
| Demais `GET` | 60/min |

Implementação: Upstash Redis ou Vercel KV com sliding window. Header de resposta `X-RateLimit-Remaining`.

---

## 8. Observability nas rotas

### Sentry
Todo erro 5xx capturado. Tag `route`, `userId` (sem PII de query).

### PostHog
Eventos listados em cada rota. Distinct ID = `userId`.

### Helicone
Toda chamada Anthropic com header `Helicone-Auth: Bearer ${HELICONE_KEY}`, `Helicone-Property-User-Id: ${userId}`, `Helicone-Property-Tier: ${tier}`, `Helicone-Property-Slash-Command: ${cmd}`.

---

## 9. ENV VARS necessárias

```
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# LLM
ANTHROPIC_API_KEY=
OPENAI_API_KEY=
HELICONE_API_KEY=

# Pagamento
ASAAS_API_KEY=
ASAAS_WEBHOOK_TOKEN=

# Auth
NEXTAUTH_SECRET=

# Workers
INTERNAL_WORKER_SECRET=
CRON_SECRET=

# Observability
SENTRY_DSN=
NEXT_PUBLIC_POSTHOG_KEY=
NEXT_PUBLIC_POSTHOG_HOST=

# Rate limit
UPSTASH_REDIS_URL=
UPSTASH_REDIS_TOKEN=
```
