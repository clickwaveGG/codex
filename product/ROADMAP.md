# ROADMAP — Healer MVP

**Versão:** 1.0 · 2026-05-02
**Time assumido:** 1 dev fullstack (founder solo) + apoio eventual de design/copy
**Cadência:** sprints de 1 semana, demo na sexta com fundador
**Janela total:** ~12 semanas até beta privado, +2-4 semanas até público

---

## Visão geral das fases

| Fase | Duração | Entregável | Critério "feito" |
|---|---|---|---|
| **FASE 1** | 4-6 semanas | Auth + Upload + Parsing + Chat básico (sem citação, sem streaming, sem slash) | Founder consegue subir Robbins e fazer 5 perguntas com resposta de Haiku |
| **FASE 2** | 2-3 semanas | Citação de página + slash-commands + streaming SSE | Resposta vem token-a-token com `[pp. N]` clicável e cancelamento funciona |
| **FASE 3** | 2 semanas | Billing Asaas + paywall + tiers | Beta tester paga R$ 14,90 via Pix e vê tier atualizado |
| **FASE 4** | 1-2 semanas | Polish + observability + lançamento beta privado | 30 estudantes de medicina ativos no produto, telemetria fluindo |

**TOTAL:** 9-13 semanas (~2,5-3 meses)

---

## FASE 1 — Fundações (semanas 1-6)

### Objetivo
Provar que o pipeline RAG core (upload → parse → embed → search → LLM) funciona end-to-end com qualidade de resposta aceitável em livros de medicina BR.

### Sprint 1.1 — Setup infra (semana 1)
- [ ] Repo `clickwaveGG/healer` (ou nome final) — bootstrap Next.js 15 + Tailwind + shadcn/ui
- [ ] Vercel project criado (auto-deploy main)
- [ ] Supabase project criado (Frankfurt region) + ENV vars
- [ ] Aplicar `SCHEMA.sql` completo
- [ ] Storage bucket `codices` com policies
- [ ] Anthropic + OpenAI + Helicone keys + Sentry + PostHog instalados
- [ ] Layout base (header com nav, footer compliance, dark mode default)
- [ ] **Demo:** página index com login Google funcionando, profile criado em DB

**Riscos:**
- Supabase region Frankfurt vs latência BR — testar; se ruim, mudar pra Singapore ou usar edge functions

### Sprint 1.2 — Onboarding + Consultório vazio (semana 2)
- [ ] Tela `/login` (Google OAuth)
- [ ] Middleware Next.js auth
- [ ] Tour de 3 telas (`/onboarding/*`)
- [ ] `/api/users/me` (GET, PATCH compliance_accepted_at)
- [ ] `/consultorio` empty state com dropzone
- [ ] PostHog eventos `signup_completed`, `onboarding_completed`
- [ ] **Demo:** novo user faz signup, vê tour, aceita disclaimer, chega em consultório vazio

### Sprint 1.3 — Upload + Parsing pipeline (semanas 3-4)
- [ ] `POST /api/codices` (multipart upload pro Storage)
- [ ] Worker `/api/internal/parse-codex`:
  - `pdf-parse` extração
  - chunking 800 tokens overlap 100 (`gpt-tokenizer`)
  - embedding batch OpenAI text-embedding-3-small
  - bulk insert chunks
- [ ] `GET /api/codices/:id/status` polling
- [ ] UI card de códice com overlay "Decifrando…"
- [ ] Modal confirmar título + categoria
- [ ] Categorização auto via Haiku (categoria sugerida)
- [ ] Erro estados (PDF escaneado, > 80MB, parsing falhou)
- [ ] **Demo:** founder sobe Robbins capítulo (300pp) → vê processing → confirma → códice ready em < 90s

**Riscos:**
- Embedding de 1500pp pode estourar rate limit OpenAI — usar batch de 100 com sleep 200ms
- Custo do embedding: validar se livro 300pp custa ≤ R$ 0,08

### Sprint 1.4 — Chat básico SEM streaming/citação (semana 5)
- [ ] `/consultorio/{codex_id}` layout (sidebar + chat + composer)
- [ ] `POST /api/consultations` SEM SSE (resposta JSON normal por enquanto)
- [ ] RAG: embed query → RPC `search_chunks` → monta prompt → chama Haiku
- [ ] Salva `consultations` row
- [ ] Render mensagens user + Hipócrates (markdown)
- [ ] Disclaimer rodapé obrigatório em cada resposta
- [ ] Cap diário (server-side check)
- [ ] **Demo:** founder pergunta "Resuma cap 1" → recebe resposta em 5-10s sem citação

### Sprint 1.5 — Listagem + delete + histórico básico (semana 6)
- [ ] `GET /api/codices` (consultório)
- [ ] Grid de códices com capa procedural (gradient hash)
- [ ] Busca client-side
- [ ] `DELETE /api/codices/:id` soft delete
- [ ] Sidebar histórico no chat (`GET /api/consultations?codex_id=`)
- [ ] **Demo FASE 1 completa:** founder usa o produto end-to-end por 30min, faz 20 consultas

### Critério de "Pronto pra Fase 2"
- [ ] Founder fez ≥ 50 consultas em pelo menos 3 códices diferentes
- [ ] Custo médio por consulta logado em Helicone — ≤ R$ 0,015
- [ ] Custo médio embedding por códice — ≤ R$ 0,10
- [ ] TTRR (time to response) ≤ 8s p50 (sem streaming)
- [ ] Quality vibe-check: ≥ 7/10 das respostas são "úteis" segundo founder

---

## FASE 2 — Streaming, citações, slash-commands (semanas 7-9)

### Objetivo
Transformar UX de "esperar 8s pelo blob" em "ver pensamento aparecendo" + cada parágrafo linkado à página + comandos rápidos que cobrem 80% dos use-cases de prova.

### Sprint 2.1 — Streaming SSE + cancelamento (semana 7)
- [ ] Refatorar `POST /api/consultations` para `text/event-stream`
- [ ] Cliente: `fetch` com `ReadableStream`, render token-a-token
- [ ] Botão "Cancelar consulta" durante stream
- [ ] Server: detecta `req.signal.aborted` e cancela Anthropic stream
- [ ] Salva resposta parcial em caso de cancel
- [ ] Microcopy temática "Auscultando…" / "Hipócrates está consultando os anais…"
- [ ] **Demo:** founder envia consulta longa, vê tokens aparecendo, cancela no meio, response parcial salvo

### Sprint 2.2 — Citação de página (semana 8)
- [ ] Modificar system prompt pra forçar `[[CITE:N]]` inline
- [ ] Frontend regex parser → `<button>[pp. N]</button>`
- [ ] `GET /api/codices/:id/page/:n` retorna signed URL
- [ ] Coluna direita on-demand com PDF.js viewer (ou iframe simples) na página citada
- [ ] Salva `consultations.citations` (JSONB)
- [ ] **Demo:** founder pergunta, clica em [pp. 437], vê preview do PDF na página

**Riscos:**
- LLM pode esquecer de citar mesmo instruído — pós-processamento opcional: se resposta sem `[[CITE:` mas chunks recuperados existem, force-append "(referência: pp. X-Y)"
- PDF.js bundle pesado — considerar `react-pdf` ou apenas iframe + `?#page=N` (suporte nativo do browser)

### Sprint 2.3 — Slash-commands + palette (semana 9)
- [ ] `lib/slash-commands.ts` config (templates, topK, requiresArg)
- [ ] Composer detecta `/` → palette dropdown
- [ ] Cada comando dispara prompt template específico
- [ ] Validação de argumento client + erro inline
- [ ] Quick-start chips no empty state do chat
- [ ] PostHog `slash_command_used`
- [ ] Tracking de qualidade por comando (feedback thumbs up/down)
- [ ] **Demo:** founder usa cada um dos 6 comandos com material real

### Critério de "Pronto pra Fase 3"
- [ ] TTFT (time to first token) ≤ 1.8s p50
- [ ] 100% das respostas com retrieval bom incluem ≥ 1 citação
- [ ] Cada slash-command testado com 5 inputs reais; output passa vibe-check 8/10
- [ ] Cancel funciona em ≤ 200ms

---

## FASE 3 — Billing & paywall (semanas 10-11)

### Objetivo
Aceitar pagamento Pix recorrente via Asaas e gerenciar tier corretamente.

### Sprint 3.1 — Asaas integration + paywall UI (semana 10)
- [ ] Conta Asaas + sandbox keys
- [ ] `POST /api/billing/subscribe` (cria customer + subscription Pix)
- [ ] `GET /api/billing/payment/:id` polling
- [ ] `POST /api/billing/webhook` (idempotente)
- [ ] `/planos` UI com 4 cards (Estagiário / Residente / Clínico / Mestre)
- [ ] Toggle Mensal/Anual com -33%
- [ ] Tela de checkout com QR Code Pix
- [ ] Tela de sucesso com upgrade confirmado
- [ ] **Demo:** founder paga R$ 14,90 sandbox → tier upgrade automaticamente

### Sprint 3.2 — Caps, downgrade, cancel, lifetime (semana 11)
- [ ] Middleware aplica `tier_caps` em todas rotas (codex count, consultations/day)
- [ ] Sonnet 4.5 routing: tier `clinico/mestre` → habilitado
- [ ] `DELETE /api/billing/subscription` (cancel mantém até period_end)
- [ ] Cron `expire-subscriptions` (downgrade ao fim do ciclo)
- [ ] Mestre lifetime: pagamento avulso, `tier='mestre'` permanente
- [ ] Paywall modals em 3 triggers: cap_codex, cap_consultations, sonnet_required
- [ ] Banner "X/Y consultas hoje" no header do consultório
- [ ] Eventos PostHog `paywall_hit`, `checkout_started`, `subscription_started`, `subscription_canceled`
- [ ] **Demo FASE 3:** simular ciclo completo upgrade → cancel → downgrade automático

### Critério de "Pronto pra Fase 4"
- [ ] 3 betas reais pagaram Pix sandbox e tier upgrade automaticamente
- [ ] Webhook idempotente testado (enviar evento 2x, tier não duplica)
- [ ] Cancel testado: tier mantido até period_end, depois downgrade

---

## FASE 4 — Polish + observability + beta privado (semanas 12-13)

### Objetivo
Produto rodando estável com 30 estudantes reais, telemetria fluindo, bugs críticos sumidos.

### Sprint 4.1 — Polish UX + compliance + edge cases (semana 12)
- [ ] Estados loading/empty/error revisados em TODA tela
- [ ] Mobile responsivo testado 360px → 1920px
- [ ] Microcopy temática auditada (glossário em 100% dos lugares)
- [ ] Acessibilidade: contraste AA, foco visível, aria-labels
- [ ] Rate limits Upstash configurados
- [ ] Bloqueios compliance (regex + LLM classifier) testados com 30 queries adversariais
- [ ] Termos + Privacidade publicados (esqueleto deste PRD; revisão jurídica pendente)
- [ ] Page `/privacidade/sub-processadores` lista de terceiros
- [ ] Cron jobs configurados (reset diário, hard delete, expire subs)
- [ ] **Demo:** sessão de QA dirigida pelo founder, lista de bugs P1 zerada

### Sprint 4.2 — Observability + lançamento beta privado (semana 13)
- [ ] Sentry alertas: erro rate > 1%, latência p95 > 5s
- [ ] PostHog dashboards: ativação D0, retenção D7, custo por consulta, conversão paywall
- [ ] Helicone alerta custo: dispara se R$ > 200/dia
- [ ] Health check endpoint `/api/health` (DB, Anthropic, OpenAI ping)
- [ ] README do repo + onboarding docs pra dev futuro
- [ ] Convites pra 30 betas selecionados (CAs, grupos WhatsApp medicina)
- [ ] Discord/grupo de betas pra feedback rápido
- [ ] **Marco:** 30 betas onboarded, > 5 consultas/user/semana média

---

## Pós-MVP (FASE 5+) — backlog priorizado

Não fazer durante o MVP. Backlog ranqueado pra quando MRR > R$ 5k.

| Prioridade | Item | Estimativa |
|---|---|---|
| P0 | Lançamento público + paid media inicial | 2 sem |
| P0 | Refatorar prompts com base em feedback 100 betas | 1 sem |
| P1 | Multi-códice query (estante inteira) | 2 sem |
| P1 | Highlight + nota dentro do PDF | 2 sem |
| P1 | Modo prova cronometrado (estilo simulado residência) | 3 sem |
| P2 | Export pra Anki/Notion | 1 sem |
| P2 | OCR para PDF escaneado (Tesseract ou Mistral OCR) | 2 sem |
| P2 | Login email/senha + magic link | 1 sem |
| P3 | App mobile (PWA primeiro, nativo se justificar) | 4 sem |
| P3 | B2B2C cursinhos | 4 sem (incl venda) |
| P4 | Imagens médicas (visão computacional pra anatomia/lâminas) | 6+ sem |

---

## Riscos transversais a todas as fases

| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|
| Custo LLM disparar em usuário power | Alta | Alto | Cap diário hard server-side + alerta Helicone + prompt cache obrigatório |
| Anthropic rate limit em pico | Média | Médio | Implementar fila com Upstash; fallback Bedrock Claude |
| OpenAI embedding indisponível | Baixa | Alto | Cache embeddings; queue de retry; alternativa Voyage AI |
| LLM alucinar dose perigosa | Média | Crítico | `/dose` com aviso + intent classifier bloqueia "meu paciente" |
| Estudante não pagar Pix recorrente | Média | Alto | Free generoso (50 cons/dia gera valor antes do paywall); Mestre lifetime como hedge |
| CFM publicar regulação restritiva | Baixa | Crítico | Manter posicionamento estritamente educacional; advogado on-call |
| Asaas instabilidade | Baixa | Médio | Webhook idempotente; logging billing_events; suporte pago Asaas |
| Founder solo gargalar | Alta | Alto | Squad sinapse opera em paralelo (brand, copy, design); freelancer pontual em sprints críticos |

---

## Dependências críticas (decisões pendentes do founder ANTES da Sprint 1.1)

> Vector deve devolver isso pro Leonardo decidir AGORA.

1. **Nome final do produto** (Healer / Asclepius / Galeno / Codex Vitae / Curandus / outro) — afeta domain, repo, design
2. **Paleta**: verde-medicinal próprio OU manter roxo do Grimoire? — afeta design system inteiro
3. **Direção do logo** — caduceu / bastão Asclépio / almofariz / coração anatômico
4. **Estratégia de lançamento**: simultâneo Grimoire (mais risco) ou 6m depois (recomendado pelo overview)
5. **Escopo público**: só medicina ou abre enfermagem/fisio/farmácia desde lançamento (recomendação Vector: SÓ MEDICINA no MVP — testes de quiz e tom são otimizados pra prova de residência médica)
6. **Tier extra "Especialista" R$ 49,90 com simulado residência cronometrado** — recomendação Vector: NÃO no MVP, manter 4 tiers; agregar V2 se MRR > R$ 15k
7. **Nome do assistente IA**: Hipócrates (recomendação Vector — é o mais didático e protegido culturalmente)

---

## Handoff pós-MVP

Ao final da Fase 4, ativar:
- **growth-orqx + paidmedia-orqx** — plano GTM, aquisição paga
- **finance-orqx** — revisão de unit economics com dados reais (CAC, LTV, payback)
- **research-orqx** — entrevistas com 20 betas pra priorizar Fase 5
