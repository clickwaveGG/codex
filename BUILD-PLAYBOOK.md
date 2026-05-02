# AVICENA — Build Playbook

**O que é este documento:** seu manual de execução. Diz O QUÊ vai ser construído, QUEM faz O QUÊ (você vs Claude), QUANTO custa, QUANDO, e POR ONDE começar.

**Versão:** 1.0 · 2026-05-02
**Janela total:** 9-13 semanas até beta privado · +2-4 semanas até público
**Modelo de trabalho:** sprints de 1 semana, demo na sexta, push contínuo, tudo no mesmo repo

---

## 1. A visão final em 1 minuto

Em ~3 meses você terá rodando:

- **Landing pública** com waitlist + paywall (já está no ar como v1 estática)
- **App web** (`app.avicena.com.br` ou `/app`): login Google · upload de PDF · chat com Hipócrates com citação de página · histórico · 4 tiers
- **Backend completo:** Supabase (auth + DB + storage + pgvector) · Anthropic Haiku/Sonnet · OpenAI embeddings · Asaas Pix · Helicone observability
- **Instagram** + lista de espera + 30 betas pagantes

**Valor entregue:** estudante de saúde sobe Robbins, pergunta `/explicar fisiopato IC`, recebe parecer com `[pp. 437]` clicável em ≤ 2s, paga R$ 14,90/mês via Pix.

---

## 2. Pré-requisitos: contas que VOCÊ precisa abrir

Eu não posso criar contas em seu nome (precisa CPF/CNPJ + verificação). Você cria, copia chaves/tokens, me passa, eu integro.

| # | Serviço | Pra quê | Quando criar | Custo M1-M3 | Como criar | Quem paga |
|---|---|---|---|---|---|---|
| 1 | **Supabase** | Auth Google + Postgres + pgvector + Storage | **Sprint 1.1 (1ª semana)** | Free → R$ 130/mês (Pro) | supabase.com → "New project" → escolher region Frankfurt | Você (cartão) |
| 2 | **OpenAI** | Embeddings text-embedding-3-small | Sprint 1.3 (3ª sem) | Pay-as-go ~R$ 50-100/mês | platform.openai.com → API key | Você (cartão) |
| 3 | **Anthropic** | Claude Haiku 4.5 + Sonnet 4.5 | Sprint 1.4 (5ª sem) | Pay-as-go ~R$ 80-200/mês | console.anthropic.com → API key | Você (cartão) |
| 4 | **Helicone** | Cache + observability LLM | Sprint 1.4 | Free → ~R$ 100 quando escalar | helicone.ai → API key | Você |
| 5 | **PostHog** | Analytics produto + funil | Sprint 1.2 (2ª sem) | Free (1M eventos/mês) | posthog.com → projeto | Você |
| 6 | **Sentry** | Erros + alertas | Sprint 4 (12ª sem) | Free (5k erros/mês) | sentry.io → projeto Next.js | Você |
| 7 | **Resend** | Email transacional + waitlist | Sprint 4 | Free (3k emails/mês) | resend.com → API key | Você |
| 8 | **Asaas** | Pix recorrente | Sprint 3 (10ª sem) | 0 + 1% por Pix | asaas.com → CNPJ verificação (1-3 dias) | Você (CNPJ) |
| 9 | **Domínio** | URL pública profissional | Quando quiser | R$ 50-200/ano | registro.br ou Namecheap | Você |
| 10 | **Vercel** | Hosting (já existe) | Já feito | $20/mês plano Pro | vercel.com (já configurado) | Você |

**Total mensal estimado M1-M3:** R$ 400-800
**One-shot setup:** R$ 50-200 (domínio) + tempo de verificação CNPJ Asaas

> Você não precisa criar todos AGORA. Só o do sprint atual. Eu te aviso "hora de criar X" quando chegar a vez.

---

## 3. Decisões arquiteturais já travadas (não revisitar)

| Tema | Decisão | Por quê |
|---|---|---|
| **Repo** | Continua `clickwaveGG/codex` (já existe, Vercel atrelado) | Renomear quebra URLs |
| **Landing v1 estática** | Mantida em `/` como tá agora | Captura waitlist enquanto build vai rolando |
| **App Next.js** | Bootstrap em `/app` no mesmo repo (ou subdomain `app.avicena...`) | Mesmo deploy, sem migrar landing pra dentro do Next.js (risco zero) |
| **Stack** | Next.js 15 App Router + Tailwind + shadcn + Supabase + Anthropic + OpenAI + Asaas | Travado no PRD-MVP |
| **Auth** | Só Google no MVP | Reduz suporte, estudante já tem conta institucional |
| **Pagamento** | Pix recorrente Asaas | Estudante 22 anos não tem cartão |
| **LLM default** | Haiku 4.5 (Sonnet só Clínico+Preceptor) | Trava margem |

---

## 4. Os 13 sprints (semana a semana)

Cada sprint = 1 semana. Demo na sexta. Você testa, aprova ou pede ajuste, próximo sprint começa segunda.

### FASE 1 — Fundações (semanas 1-6)

| Sprint | Objetivo | EU faço | VOCÊ faz | Custo novo | Demo final |
|---|---|---|---|---|---|
| **1.1** | Setup infra | Bootstrap Next.js 15 + Tailwind + shadcn em `/app` · configurar Vercel pra servir tanto landing v1 quanto app · estrutura de pastas | Criar conta Supabase + me passar URL+keys · criar conta PostHog + me passar key | Supabase free | Página `/app` carrega com layout base (header, footer compliance, dark mode) |
| **1.2** | Auth + Onboarding | Login Google via Supabase Auth · middleware Next.js · 3 telas de tour · checkbox aceite CFM | Configurar Google OAuth no Supabase (eu te passo o passo-a-passo) | 0 | Você loga com sua conta Google, vê tour, aceita disclaimer, chega em consultório vazio |
| **1.3** | Upload + Parsing | Aplicar SCHEMA.sql · `POST /api/codices` (multipart) · worker parsing (pdf-parse + chunking + embeddings) · UI card "Decifrando…" | Criar conta OpenAI + me passar API key · subir PDF de teste (Robbins capítulo) | OpenAI ~R$ 5 (1 livro) | Você sobe um PDF, vê processing 60-90s, códice fica disponível |
| **1.4** | Chat básico (sem streaming) | RAG: embed query → search → prompt → Haiku · render mensagens · disclaimer rodapé · cap diário | Criar conta Anthropic + Helicone + me passar keys | Anthropic ~R$ 30 (testes) | Você pergunta "resuma cap 1", recebe resposta em 5-10s |
| **1.5** | Listagem + delete + histórico | Grid códices com capa procedural · busca · soft delete · sidebar histórico de anamneses | Testar com 3-5 PDFs reais teus de saúde | 0 | Demo Fase 1 completa: você usa o produto end-to-end por 30min |

**Marco Fase 1:** Você fez ≥ 50 consultas em ≥ 3 códices · custo médio Haiku ≤ R$ 0,015 · TTRR (sem streaming) ≤ 8s.

### FASE 2 — Streaming + Citações + Slash Commands (semanas 7-9)

| Sprint | Objetivo | EU faço | VOCÊ faz | Custo novo | Demo final |
|---|---|---|---|---|---|
| **2.1** | Streaming SSE + cancel | Refatorar API pra `text/event-stream` · ReadableStream client · botão Cancelar · "Auscultando…" | Testar | 0 | Resposta aparece token-a-token, cancelamento funciona |
| **2.2** | Citação de página | LLM forçado a inserir `[[CITE:N]]` · parser frontend · viewer PDF on-demand | Testar com livros reais | 0 | Clica `[pp. 437]` → preview do PDF naquela página |
| **2.3** | 6 slash-commands | `lib/slash-commands.ts` · palette no composer · prompt templates · feedback 👍👎 | Testar cada comando com material real | 0 | Você usa `/resumir /explicar /quizar /caso /diferenciar /dose` |

**Marco Fase 2:** TTFT ≤ 1.8s · 100% das respostas com citação · cada slash-command vibe-check 8/10.

### FASE 3 — Billing + Paywall (semanas 10-11)

| Sprint | Objetivo | EU faço | VOCÊ faz | Custo novo | Demo final |
|---|---|---|---|---|---|
| **3.1** | Asaas + paywall UI | Integração Asaas · QR Code Pix · webhook idempotente · `/planos` 4 cards · checkout | Criar conta Asaas com CNPJ (1-3 dias verificação) · me passar API keys sandbox depois prod | 0 + 1% Pix | Você paga R$ 14,90 sandbox → tier upgrade automático |
| **3.2** | Caps + cancel + lifetime | Middleware aplica caps em 4 camadas · Sonnet routing tier-based · cancel mantém até period_end · cron downgrade · Preceptor lifetime | Testar ciclo completo upgrade → cancel | 0 | Simular ciclo: upgrade Pix → usar 30d → cancelar → downgrade no fim |

**Marco Fase 3:** 3 betas pagaram Pix sandbox · webhook idempotente · cancel testado.

### FASE 4 — Polish + Beta Privado (semanas 12-13)

| Sprint | Objetivo | EU faço | VOCÊ faz | Custo novo | Demo final |
|---|---|---|---|---|---|
| **4.1** | Polish + compliance | Estados loading/empty/error revisados · mobile testado · acessibilidade · rate limits · bloqueios CFM testados · ToS+Privacidade publicados | Convidar advogado pra revisar ToS (~R$ 800-2.500) | Advogado opcional | Bug list P1 zerada |
| **4.2** | Observability + lançamento beta | Sentry alertas · PostHog dashboards · health check · convites pra 30 betas | Selecionar 30 betas (CAs, grupos WhatsApp medicina) · onboardar 1 a 1 nos primeiros 3 dias | 0 | 30 estudantes onboarded · ≥ 5 consultas/user/semana média |

**Marco Fase 4:** Beta privado rodando. Decisão: virar público em 2-4 semanas se métricas baterem.

---

## 5. Como vamos trabalhar

```
┌─────────────────────────────────────────────────────────────┐
│  CICLO DE 1 SPRINT (1 semana)                               │
├─────────────────────────────────────────────────────────────┤
│  SEGUNDA   Você cria contas / decide pendências do sprint   │
│  TER-QUI   Eu codo · push contínuo · Vercel auto-deploya    │
│  QUI-SEX   Você testa em deployment de preview              │
│  SEX       Demo + decisão GO/PIVOT pro próximo sprint       │
└─────────────────────────────────────────────────────────────┘
```

**Eu (Claude) faço:**
- Toda escrita de código
- Migrations SQL
- Configuração de libs
- Edits no repo + commits + push
- Diagnóstico de bugs

**Você (Leonardo) faz:**
- Cria contas externas (Supabase, Anthropic, etc.)
- Me passa API keys (texto plano no chat — eu salvo em `.env` que NÃO vai pro repo)
- Testa cada sprint (você é o QA)
- Aprova UX/copy
- Decisões de produto quando aparecerem
- Paga as contas

**O que NÃO eu vou fazer (você precisa pegar humano):**
- Validação jurídica de ToS/Privacidade (Sprint 4) — advogado especializado em direito digital + saúde, R$ 800-2.500
- Onboarding manual dos 30 primeiros betas (Sprint 4.2) — você fala com cada um
- Decisões de pricing finais (Ledger já recomendou; você pode ajustar)
- Compras (cartão de crédito, CNPJ)

---

## 6. Por onde começamos AGORA (Sprint 1.1)

### Ações suas (esta semana)

- [ ] **Criar conta Supabase** em [supabase.com](https://supabase.com)
  - Cria org "Avicena" ou "ClickWave"
  - "New project" → nome `avicena-prod` → region `Frankfurt (eu-central-1)` → password forte (anota)
  - Em "Project Settings" → "API" copia `Project URL` + `anon key` + `service_role key` → me passa no chat
- [ ] **Criar conta PostHog** em [posthog.com](https://posthog.com)
  - Free tier
  - Em "Project Settings" copia `Project API Key` → me passa
- [ ] **Decidir nome da subpasta do app**: `app/` (default) ou outro?
- [ ] **Decidir URL do app**:
  - **Opção A** (simples): `avicena.vercel.app/app/*` (mesma URL da landing, path `/app`)
  - **Opção B** (premium): subdomain `app.avicena.com.br` (depende de comprar domínio antes)
  - Recomendo A pra começar; trocar pra B é fácil depois

### Ações minhas (assim que você passar as keys)

- [ ] Bootstrap Next.js 15 em `app/` (App Router + TypeScript + Tailwind + shadcn)
- [ ] Configurar `vercel.json` pra servir landing v1 em `/` e app Next.js em `/app/*`
- [ ] Setup Supabase client + ENV vars no Vercel
- [ ] Layout base do app: header, footer com disclaimer CFM, dark mode token-ready
- [ ] PostHog instrumentado
- [ ] Aplicar `SCHEMA.sql` no Supabase
- [ ] Demo: `avicena.vercel.app/app` carrega com layout base

**Tempo estimado meu:** 4-8h de trabalho concentrado (1-2 dias)

---

## 7. Checklist de "tá perfeito" (Definition of Done por sprint)

Cada sprint só é considerado "feito" se passar TUDO abaixo:

- [ ] Critérios Gherkin de `product/ACCEPTANCE-CRITERIA.md` cobertos
- [ ] Estados loading / empty / error / success implementados (não basta o happy path)
- [ ] Glossário aplicado (códice, anamnese, Hipócrates, consultório, juramento, tiers)
- [ ] Disclaimer CFM presente onde a feature é exposta
- [ ] Auth obrigatório em rotas privadas
- [ ] Rate limit aplicado conforme tier
- [ ] Erros estruturados em JSON
- [ ] Eventos PostHog disparam
- [ ] Logs estruturados Sentry (zero PII em mensagens)
- [ ] Custo LLM logado em Helicone
- [ ] Sem secret em código
- [ ] LCP ≤ 2,5s
- [ ] Mobile testado 360px-1920px
- [ ] Você fez vibe-check ≥ 8/10

---

## 8. Riscos que podem estourar prazo (e como mitigamos)

| Risco | Probabilidade | Mitigação |
|---|---|---|
| Custo LLM real > previsão Ledger | Alta | Sprint 1.4 valida com Helicone real; recalibrar pricing se quebrar |
| TTFT > 1.8s (latência BR ↔ Frankfurt) | Média | Testar; alternativa Singapore ou edge functions |
| Asaas verificação CNPJ demora >5d | Média | Iniciar processo no Sprint 2 (não Sprint 3) pra ter buffer |
| LLM esquece de citar página | Média | Pós-processamento força `[pp. X-Y]` se faltar |
| Webhook Asaas duplicado | Baixa | Idempotência por `payment_id` — testar 2x antes de prod |
| Você (founder solo) gargalar | Alta | Squads sinapse paralelas (brand, copy, growth) já rodam · freelancer pontual em sprints críticos |
| Domínio `.com.br` ocupado | Média | Comprar `avicena.app` ou outra extensão; URL Vercel funciona enquanto isso |

---

## 9. O que está PRONTO hoje (não precisa refazer)

- ✅ Brandbook completo (`brand/BRANDBOOK.md`)
- ✅ Logo pixel art aplicada (navbar + favicon)
- ✅ Landing v1 deployada (verde clínico, mockup chat 3 frames, waitlist)
- ✅ Glossário travado (códice, anamnese, Hipócrates, etc.)
- ✅ Disclaimer CFM bloco completo
- ✅ Plano IG 30 dias (`growth/`)
- ✅ Unit economics validados (`finance/`)
- ✅ Schema banco SQL pronto (`product/SCHEMA.sql`)
- ✅ Spec de 20+ endpoints API (`product/API-ROUTES.md`)
- ✅ 6 slash-commands especificados (`product/SLASH-COMMANDS.md`)
- ✅ Compliance CFM mapeado (`product/COMPLIANCE.md`)
- ✅ Critérios de aceite Gherkin (`product/ACCEPTANCE-CRITERIA.md`)
- ✅ Repo no GitHub + Vercel auto-deploy

---

## 10. Em uma frase

> "Você cria 10 contas em serviços externos ao longo de 3 meses, eu codo em sprints semanais, no fim você tem 30 estudantes pagantes Pix R$ 14,90 e um produto que valida ou destrói a tese 'o conhecimento que cura'."
