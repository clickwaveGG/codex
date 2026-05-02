# CODEX — System Map

**O que é este documento:** o mapa-mestre do SaaS Codex. Você lê em 10 minutos e entende como o produto funciona ponta a ponta — do clique no TikTok até o pagamento em Pix recorrente, passando por cada peça técnica, cada custo, cada risco.

**Versão:** 1.0 · 2026-05-02
**Estado:** todas as fundações de marca + produto travadas; build do app ainda não iniciado

---

## 1. O Codex em 1 parágrafo

Codex é um SaaS brasileiro onde estudante de saúde sobe um PDF (Robbins, Porto, Tratado de Pediatria SBP, apostila do CA, atividade do professor) e conversa com **Hipócrates** — um assistente IA com peso clínico — pra resumir capítulos, explicar fisiopatologia, gerar quizzes estilo Revalida/ENARE, simular casos clínicos e diferenciar doenças. Cada resposta vem com a página exata do PDF citada e clicável. Free pra começar (50 consultas/dia), R$ 14,90/mês pra desbloquear sério, R$ 297 lifetime pra quem quer travar pra sempre. Pagamento Pix recorrente (sem cartão).

**Tese:** "O conhecimento que cura." Transforma 1500 páginas de Robbins de leitura passiva em decisão de estudo ativa.

**Categoria:** mesmo bairro de NotebookLM / ChatPDF / Humata. Diferenciação = nicho saúde BR + glossário clínico + pricing acessível pra estudante + tom PT-BR coloquial com peso técnico.

---

## 2. Diagrama de funcionamento (texto)

```
                    ┌─────────────────────────────────────────────┐
                    │  AQUISIÇÃO                                  │
                    │  TikTok / IG orgânico → micro-influencers   │
                    │  Google Ads + SEO ("alternativa NotebookLM")│
                    │  Comunidades WhatsApp/Telegram de saúde     │
                    └──────────────────┬──────────────────────────┘
                                       │
                                       ▼
              ┌────────────────────────────────────────────┐
              │  LANDING (codex.app ou similar)            │
              │  Hero + chat-card → "Começar grátis"       │
              └─────────────────┬──────────────────────────┘
                                │
                                ▼ Login Google
              ┌────────────────────────────────────────────┐
              │  ONBOARDING (3 telas)                      │
              │  Boas-vindas → Como funciona → Disclaimer  │
              │  CFM (checkbox obrigatório)                │
              └─────────────────┬──────────────────────────┘
                                │
                                ▼
              ┌────────────────────────────────────────────┐
              │  CONSULTÓRIO (dashboard)                   │
              │  Grid de códices + busca + "+ novo códice" │
              └─────────┬───────────────────────┬──────────┘
                        │                       │
                        ▼ upload PDF            ▼ abre códice
              ┌──────────────────────┐  ┌────────────────────────┐
              │  PIPELINE RAG        │  │  CHAT COM HIPÓCRATES   │
              │  ① Storage upload    │  │  Textarea + 6 slash:   │
              │  ② pdf-parse         │  │  /resumir /explicar    │
              │  ③ Chunking 800 tok  │  │  /quizar  /caso        │
              │  ④ Embeddings OpenAI │  │  /diferenciar /dose    │
              │  ⑤ Insert pgvector   │  │  Streaming SSE         │
              │  "Decifrando..." 90s │  │  Citação [pp.437] ←    │
              └──────────┬───────────┘  └──────────┬─────────────┘
                         │                         │
                         └────────┬────────────────┘
                                  ▼
              ┌─────────────────────────────────────────────┐
              │  RESPOSTA COM CITAÇÃO                       │
              │  Markdown render + [[CITE:N]] → button      │
              │  Click [pp.437] → preview PDF naquela pág.  │
              │  Disclaimer rodapé OBRIGATÓRIO              │
              └─────────────────┬───────────────────────────┘
                                │
                                ▼ user encadeia mais consultas
              ┌─────────────────────────────────────────────┐
              │  CAP DIÁRIO BATIDO (Estagiário 50/dia)      │
              │  → PAYWALL                                  │
              │  /planos → Pix Asaas → upgrade tier         │
              │  Estagiário R$0 → Residente R$14,90 →       │
              │  Clínico R$29,90 → Preceptor R$297 lifetime │
              └─────────────────────────────────────────────┘
```

---

## 3. Arquitetura técnica (a stack inteira em uma tela)

```
┌─────────────────────────────────────────────────────────────────────┐
│  FRONTEND — Vercel (BR/edge)                                        │
│  Next.js 15 App Router · React · Tailwind · shadcn/ui               │
│  Auth: NextAuth + Supabase OAuth Google                             │
│  Streaming: fetch + ReadableStream (SSE)                            │
│  PDF viewer: react-pdf ou iframe nativo ?#page=N                    │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│  API LAYER — Next.js Route Handlers                                 │
│  /api/codices    → upload + status + delete                         │
│  /api/consultations → POST (SSE) + GET histórico                    │
│  /api/billing/*  → subscribe + webhook + payment                    │
│  /api/users/me   → tier + caps + compliance                         │
│  /api/internal/parse-codex (worker, autenticado por secret)         │
│  Middleware: auth obrigatório + rate limit por tier                 │
└─────────────────────────────────────────────────────────────────────┘
                                  │
        ┌─────────────────────────┼──────────────────────────┐
        ▼                         ▼                          ▼
┌─────────────────┐  ┌──────────────────────┐  ┌─────────────────────┐
│  SUPABASE       │  │  ANTHROPIC           │  │  OPENAI             │
│  (Frankfurt)    │  │  Haiku 4.5 default   │  │  text-embedding-3   │
│                 │  │  Sonnet 4.5 só       │  │  -small (1536 dim)  │
│  • auth.users   │  │  Clínico+Preceptor   │  │                     │
│  • codices      │  │  Prompt cache 100%   │  │  Batch de 100       │
│  • chunks       │  │  Streaming SSE       │  │  Rate limit 50/s    │
│    + pgvector   │  │  Cancel via abort    │  │                     │
│  • consultations│  │                      │  │                     │
│  • subscriptions│  │  Via Helicone proxy  │  │                     │
│  Storage:       │  │  (custo + cache)     │  │                     │
│  • codices/     │  │                      │  │                     │
│    bucket       │  │                      │  │                     │
│  RLS por user   │  │                      │  │                     │
└─────────────────┘  └──────────────────────┘  └─────────────────────┘
        │                         │                          │
        └─────────────────────────┼──────────────────────────┘
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│  BILLING — Asaas (Pix recorrente)                                   │
│  POST subscribe → QR Code Pix                                       │
│  Webhook idempotente → tier upgrade                                 │
│  Cron expire-subscriptions (downgrade fim ciclo)                    │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│  OBSERVABILIDADE                                                    │
│  PostHog: eventos produto (signup, codex_uploaded, paywall_hit...)  │
│  Sentry:  erros + alertas (erro >1%, latência p95 >5s)              │
│  Helicone: custo LLM por user/tier/comando + alerta R$ >200/dia     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 4. Jornada do usuário ponta a ponta

| Etapa | Onde | Microcopy | Tempo p50 |
|---|---|---|---|
| 1. Vê reel TikTok ("estudei pra prova com Codex") | TikTok | — | — |
| 2. Clica bio → landing | Landing | Hero "Transforme um PDF em um Códex" | 2-3s LCP |
| 3. Clica "Começar grátis" | Landing | — | — |
| 4. Login Google popup | `/login` | "Validando juramento…" | 3-5s |
| 5. Tour 3 telas | `/onboarding/*` | "Bem-vindo ao consultório, {nome}" | 30-60s |
| 6. Aceita disclaimer CFM | `/onboarding/disclaimer` | "Material de estudo, não substitui avaliação clínica" | 5s |
| 7. Cai em consultório vazio | `/consultorio?firstUpload=true` | "Bora subir o primeiro códice?" | — |
| 8. Drag-drop Robbins.pdf (300pp) | Dropzone | "Recebendo o códice…" | 10-20s upload |
| 9. Espera parsing | Card overlay | "Decifrando o tratado…" | 60-90s |
| 10. Confirma título + categoria | Modal | "{Robbins} · {Patologia}" | 5s |
| 11. Abre códice no chat | `/consultorio/{id}` | "Esse é o **Robbins**, com 1500 páginas decifradas" | <1s |
| 12. Digita `/explicar fisiopato IC esquerda` | Composer + slash-palette | — | 5s |
| 13. Vê resposta streaming token-a-token | Bubble Hipócrates | "Auscultando…" → texto aparece | TTFT 1.8s |
| 14. Clica `[pp. 437]` | Citação inline | Preview PDF na pág 437 | 200ms |
| 15. Encadeia 4-5 anamneses | Chat | — | 30-60s cada |
| 16. Bate cap 50/dia (no D2 ou D3) | Banner topo | "Você bateu seu cap. Bora upgrade?" | — |
| 17. Vai pra `/planos` | Tela planos | "Faça seu juramento" | — |
| 18. Escolhe Residente R$14,90 | Checkout | "Vence em 5 minutos" | — |
| 19. Paga Pix no app banco | Banco do user | — | 10-30s |
| 20. Tier atualizado automaticamente (webhook) | `/planos/sucesso` | "Juramento feito. Bem-vindo, Residente." | <5s pós-Pix |

**Total do ZERO ao primeiro parecer:** ~5 minutos
**Total do ZERO ao primeiro pagamento:** ~2-5 dias (D2-D5 quando bate cap)

---

## 5. O que existe HOJE vs o que falta

### ✅ Pronto e travado
| Categoria | Item | Onde |
|---|---|---|
| Marca | Nome final = Codex | Brandbook |
| Marca | Paleta verde clínico + âmbar | `brand/BRANDBOOK.md` |
| Marca | Tipografia Playfair + Inter + JetBrains Mono | Brandbook |
| Marca | 5 logos SVG (horiz/vert/símbolo/mono/favicon) | `brand/logo/` |
| Marca | Brandbook + preview navegável | `brand/preview.html` |
| Marca | Glossário proprietário 11 termos | Brandbook + memória |
| Marca | Tom de voz + microcopy biblioteca | Brandbook |
| Marca | Disclaimers CFM padrão | Brandbook + COMPLIANCE.md |
| Produto | PRD master (10 seções) | `product/PRD-MVP.md` |
| Produto | 6 fluxos UX detalhados | `product/FLOWS.md` |
| Produto | Spec técnico dos 6 slash-commands | `product/SLASH-COMMANDS.md` |
| Produto | Compliance CFM + LGPD-saúde | `product/COMPLIANCE.md` |
| Produto | Schema Supabase pronto pra aplicar | `product/SCHEMA.sql` |
| Produto | 20+ endpoints API mapeados | `product/API-ROUTES.md` |
| Produto | Critérios de aceite Gherkin | `product/ACCEPTANCE-CRITERIA.md` |
| Produto | Roadmap 4 fases / 9-13 sem | `product/ROADMAP.md` |
| Infra | Repo GitHub `clickwaveGG/codex` | github.com/clickwaveGG/codex |
| Infra | Vercel project + auto-deploy | `prj_la7DbDfRuWWWNVRC19AnY2NCLK2q` |
| Infra | Landing v1 estática deployada | `codex-32w503m89-clickwaveggs-projects.vercel.app` |

### 🟡 Existe mas precisa ajuste
| Item | Problema | Severidade |
|---|---|---|
| Landing `index.html` | 3 imagens fantasma (`curandeiro-1/2/3.png`) — seção "Por que o Codex é diferente?" tá quebrada | Média |
| Landing copy | Não usa glossário oficial em alguns lugares (fala "PDF" em vez de "códice" na 1ª menção) | Baixa |
| Landing favicon/logo | Usa `assets/logo.png` antigo — substituir pelo SVG novo | Baixa |
| Landing `assets/` | Pasta provavelmente vazia ou faltando arquivos | Média |
| Landing slash-commands demo | Botões usam `/resumir /explicar /examinar /resolver` — desalinhado com glossário oficial (`/quizar /caso /diferenciar /dose`) | Média |

### ❌ Falta zero (build do zero)
| Categoria | Item | Estimativa |
|---|---|---|
| Backend | Repo Next.js 15 bootstrap | 2h |
| Backend | Supabase project + ENV + migrations (SCHEMA.sql) | 4h |
| Backend | Anthropic + OpenAI + Helicone keys | 1h |
| Backend | Auth Google + middleware | 1 dia |
| Backend | Onboarding 3 telas + aceite compliance | 1 dia |
| Backend | Upload PDF + worker parsing + chunking + embeddings | 4-6 dias |
| Backend | Consultório (grid + busca + delete) | 2-3 dias |
| Backend | Chat sem streaming (RAG funcional ponta a ponta) | 3-4 dias |
| Backend | Streaming SSE + cancelamento | 2-3 dias |
| Backend | Citação `[[CITE:N]]` parser + PDF viewer page jump | 2-3 dias |
| Backend | 6 slash-commands com prompt templates | 3-4 dias |
| Backend | Asaas integration + paywall + 4 tiers + cron | 1-2 sem |
| Backend | Polish + observability + edge cases + acessibilidade | 1-2 sem |
| Legal | ToS + Privacidade revisados por advogado | depende |
| Legal | Domínio comprado (codex.app / usecodex.com.br / outro) | 1h |
| GTM | Conta Instagram criada + plano 30 dias | depende |
| GTM | Lista de 30 betas convidados (CAs + WhatsApp) | depende |

---

## 6. Caminho crítico até "rodar e vender"

### Trilha A — Construir o produto (dependência: dev)
```
Sem.1: Setup infra (Sprint 1.1)
Sem.2: Onboarding + consultório vazio (1.2)
Sem.3-4: Upload + parsing pipeline (1.3)
Sem.5: Chat básico sem streaming (1.4)
Sem.6: Listagem + delete + histórico (1.5) → MARCO FASE 1
Sem.7: Streaming SSE + cancel (2.1)
Sem.8: Citação de página (2.2)
Sem.9: Slash-commands + palette (2.3) → MARCO FASE 2
Sem.10: Asaas + paywall UI (3.1)
Sem.11: Caps + downgrade + lifetime (3.2) → MARCO FASE 3
Sem.12: Polish + compliance edge cases (4.1)
Sem.13: Observability + LANÇAMENTO BETA PRIVADO (4.2) → 30 betas reais
+2-4 sem: ajustes de feedback → LANÇAMENTO PÚBLICO
```

### Trilha B — Construir audiência (paralela, não bloqueia)
```
Sem.1: Conta @codex.saude no IG criada · primeiros 10 posts agendados
Sem.2-4: Aquecer audiência: bastidores do build, prints da landing,
         dores de estudante de saúde, micro-vídeos didáticos com IA
Sem.5-8: Lista de espera no site → captura de email
         Parcerias com 3-5 micro-influencers de medicina (10-50k seguidores)
Sem.9-12: Open beta privado: 30 vagas anunciadas, fila no IG
Sem.13+: LANÇAMENTO PÚBLICO casado com push de paid media
```

### Trilha C — Travar legal + financeiro (paralela)
```
Sem.1: Comprar domínio · abrir conta Asaas (sandbox) · CNPJ verificar tributação
Sem.2-4: Advogado escrever ToS + Privacidade (R$ 800-2.500)
Sem.5-8: finance-orqx valida custo unitário com dados reais Sprint 1.3
Sem.9-12: Conta Asaas produção · primeiros betas pagantes sandbox
Sem.13: Pricing trava · 1ª nota fiscal emitida no lançamento
```

**Caminho crítico = Trilha A (build).** B e C rodam em paralelo sem bloquear.

---

## 7. Custos mensais pra rodar (estimado)

### Mês 1-3 (beta privado, 30-100 usuários, ~80% Estagiários)
| Item | Custo BRL/mês | Notas |
|---|---|---|
| Vercel Pro | R$ 100 | $20 plano + tráfego |
| Supabase Pro | R$ 130 | $25 plano (8GB DB + storage) |
| Anthropic Haiku 4.5 | R$ 80-200 | 30 users × ~30 cons/dia × R$ 0,012 com cache |
| Anthropic Sonnet 4.5 | R$ 30-100 | só Clínicos, baixo volume inicial |
| OpenAI embeddings | R$ 50-100 | upload de códices novos |
| Asaas | R$ 0 + 1% por Pix | sem mensalidade, taxa por transação |
| Helicone | R$ 0 (free tier) | até 10k logs/dia |
| PostHog | R$ 0 (free tier) | até 1M eventos/mês |
| Sentry | R$ 0 (free tier) | 5k erros/mês |
| Domínio | R$ 5 | .com.br ano amortizado |
| **TOTAL** | **R$ 400-800** | |

### Mês 4-6 (público, 500-2.000 usuários, MRR R$ 8-25k)
| Item | Custo BRL/mês | Notas |
|---|---|---|
| Vercel Pro | R$ 200-400 | tráfego maior |
| Supabase Pro | R$ 130-300 | possível add storage |
| Anthropic Haiku | R$ 800-2.500 | escala linear com uso |
| Anthropic Sonnet | R$ 400-1.200 | mais Clínicos |
| OpenAI embeddings | R$ 300-800 | mais códices novos |
| Asaas | 1% por Pix | ≈ R$ 80-250 com MRR R$ 8-25k |
| Helicone | R$ 100-300 | upgrade de plano |
| PostHog | R$ 0-100 | volume |
| Sentry | R$ 100 | upgrade Team |
| **TOTAL** | **R$ 2.100-6.000** | margem bruta 70%+ se precificar bem |

### Custos one-shot iniciais
- Domínio premium (.app / .com.br): R$ 50-200
- Advogado (ToS + Privacidade): R$ 800-2.500
- Logo "rica" Midjourney $10/mês (opcional): R$ 50/mês × 2 meses = R$ 100
- INPI registro de marca (1 classe): R$ 355
- Conta Asaas verificação CNPJ: gratuita
- **TOTAL one-shot:** R$ 1.300-3.150

---

## 8. Riscos consolidados (técnicos + regulatórios + negócio)

### Técnicos
| Risco | Prob | Impacto | Mitigação |
|---|---|---|---|
| Embedding livro 1500pp estoura premissa R$ 0,08 | Alta | Médio | Validar Sprint 1.3 com Robbins; rate limit 50/s |
| TTFT > 1,8s p50 (latência BR ↔ Frankfurt) | Média | Médio | Testar; alternativa Singapore ou edge functions |
| PDF.js bundle pesado | Média | Baixo | iframe nativo `?#page=N` |
| Asaas webhook duplicado | Baixa | Alto | Idempotência por `payment_id`, testar 2x |
| Anthropic rate limit em pico | Média | Médio | Fila Upstash + fallback Bedrock |
| OpenAI embedding indisponível | Baixa | Alto | Cache + retry queue + alternativa Voyage |

### Regulatórios
| Risco | Prob | Impacto | Mitigação |
|---|---|---|---|
| CFM publicar resolução restritiva IA-saúde | Baixa | Crítico | Posicionamento estritamente educacional; advogado on-call |
| LGPD-saúde se user subir prontuário real | Média | Alto | Tudo sensível: consentimento, criptografia rest, hard delete 30d |
| ToS/Privacidade insuficientes pré-lançamento | Alta | Médio | Esqueleto pronto no MVP; revisão jurídica antes do público |
| Self-harm queries (suicídio, anorexia) | Média | Crítico | Sentry alerta + resposta CVV; parceria CVV se volume crescer |

### Negócio
| Risco | Prob | Impacto | Mitigação |
|---|---|---|---|
| Estudante BR não pagar R$ 14,90 | Média | Alto | Free generoso (50/dia gera vício antes paywall); Mestre lifetime hedge |
| Power user Clínico estoura margem | Alta | Médio | Cap diário hard server-side; alerta Helicone R$ >200/dia |
| Founder solo gargalar | Alta | Alto | Squads sinapse paralelas; freelancer pontual em sprints críticos |
| NotebookLM do Google lançar versão BR | Média | Crítico | Diferenciação por nicho saúde + tom + preço; foco em comunidade |
| Cursinho de residência lançar concorrente | Média | Alto | First-mover + brand clínico + preço acessível |

---

## 9. Decisões já travadas (não revisitar no MVP)

1. **Nome:** Codex (final, mantém repo+landing+Vercel)
2. **Nome IA:** Hipócrates
3. **Paleta:** verde clínico + âmbar (light default)
4. **Tipografia:** Playfair + Inter + JetBrains Mono
5. **Auth:** só Google
6. **Idioma:** PT-BR only
7. **Formato:** PDF only (sem .docx, .epub, OCR)
8. **Pagamento:** Pix recorrente Asaas (sem cartão)
9. **Tiers:** 4 (Estagiário R$0 / Residente R$14,90 / Clínico R$29,90 / Preceptor R$297 lifetime)
10. **Sonnet 4.5 hard-locked no Clínico+Preceptor** (Haiku nos demais)
11. **Stack:** Next.js 15 + Tailwind + shadcn + Supabase + Anthropic + OpenAI + Asaas + Vercel
12. **Escopo público:** saúde ampla (Med + Enf + Biomed + Fisio + Farma + Odonto + Nutri) — confirmado pelo founder 2026-05-02
13. **Cap diário hard:** sem soft warning; bate cap → paywall direto
14. **1 conversa por códice por vez** (sem multi-thread MVP)
15. **Sem editor de capa:** capa procedural por hash do título
16. **Identidade visual própria** (não compartilha sistema com Grimoire)
17. **Tier lifetime renomeado** "Mestre" → **Preceptor** (termo clínico real)

---

## 10. Decisões ainda pendentes (não bloqueiam o build, mas resolver logo)

| # | Decisão | Recomendação | Quando trava |
|---|---|---|---|
| 1 | Domínio final (.app vs .com.br) | Comprar `codex.app` se livre, fallback `usecodex.com.br` | Antes da Sprint 1.1 |
| 2 | Logo "rica" via Midjourney | Aguardar pós-MVP; SVG atual basta | Pós-lançamento |
| 3 | INPI registro marca (R$ 355/classe) | Registrar antes de virar gente grande (MRR > R$ 10k) | Quando MRR > R$ 10k |
| 4 | Lançar simultâneo Grimoire vs depois | Founder pivotou: Codex primeiro | Já decidido |
| 5 | Tier extra "Especialista" R$ 49,90 | Adiar pra V2 (MRR > R$ 15k) | Pós-MVP |
| 6 | Advogado pra ToS/Privacidade | Necessário antes do lançamento público | Sem.10-12 |
| 7 | CNPJ + tributação (Simples?) | Verificar se já existe na ClickWave; criar se não | Antes do 1º pagamento real |

---

## 11. Próximas squads recomendadas (pós este SYSTEM-MAP)

### Imediatas (rodar em paralelo agora)
| Squad | Tarefa | Bloqueia? |
|---|---|---|
| **design-orqx (Nexus)** | Aplicar brand na landing v1: substituir favicon/logo, alinhar copy ao glossário, resolver 3 imagens fantasma, alinhar slash-commands ao oficial, polir hierarquia | Não |
| **finance-orqx (Ledger)** | Validar custo unitário das premissas Vector (R$ 0,08/livro embed, R$ 0,012/Haiku, R$ 0,06/Sonnet) com simulação de cenário 1.000 users | Sprint 1.3 (validação real) |
| **growth-orqx (Catalyst)** | Plano de Instagram 30 dias: posicionamento conta, calendário editorial, tipos de post, parcerias micro-influencers de saúde | Não |
| **content-orqx** | Calendário editorial pré-lançamento (waiting list / lista de espera no IG) | Não |

### Próximas (após brand aplicado na landing)
| Squad | Tarefa | Quando |
|---|---|---|
| **copy-orqx (Quill)** | Refinar TODA copy da landing nova + emails de onboarding + paywall + planos | Após design-orqx |
| **paidmedia-orqx (Apex)** | Plano de Google Ads + Meta Ads pro lançamento (R$ 12-18k/mês) | Sem.10+ |
| **research-orqx (Prism)** | TAM/SAM saúde ampla BR (não só medicina) + benchmark concorrentes | Quando precisar pitch deck |

### Build do app (você + Cursor/Claude Code)
- Iniciar Sprint 1.1 do `ROADMAP.md` em paralelo às squads acima
- Ou contratar dev fullstack se quiser acelerar

---

## 12. Como navegar nesse projeto

**Onde tá cada coisa:**
```
C:\Users\PC\Projects\codex\
├── HEALER-OVERVIEW.md       ← Briefing original (contexto profundo de negócio)
├── CODEX-SYSTEM-MAP.md      ← VOCÊ ESTÁ AQUI (síntese executável)
├── README.md                ← Pra o GitHub público (atualizar pós-MVP)
├── index.html               ← Landing v1 estática (deployada)
├── vercel.json              ← Config de deploy
├── brand/
│   ├── BRANDBOOK.md         ← Identidade completa (paleta, fontes, tom, microcopy)
│   ├── preview.html         ← Preview navegável da marca
│   └── logo/
│       ├── codex-mark.svg               ← Símbolo puro 64×64
│       ├── codex-logo-horizontal.svg    ← Lockup horizontal (navbar)
│       ├── codex-logo-vertical.svg      ← Lockup vertical (splash/social)
│       ├── codex-logo-mono-white.svg    ← Mono branco (fundo escuro)
│       └── codex-favicon.svg            ← Favicon 32×32
└── product/
    ├── PRD-MVP.md           ← Visão, personas, escopo, métricas
    ├── FLOWS.md             ← 6 fluxos UX detalhados
    ├── SLASH-COMMANDS.md    ← Spec técnica dos 6 comandos
    ├── COMPLIANCE.md        ← CFM + LGPD-saúde + queries proibidas
    ├── SCHEMA.sql           ← Banco Supabase pronto pra aplicar
    ├── API-ROUTES.md        ← 20+ endpoints Next.js
    ├── ACCEPTANCE-CRITERIA.md ← Gherkin por feature (DORS)
    └── ROADMAP.md           ← 4 fases, 13 sprints, riscos
```

**Ordem de leitura recomendada se você esquecer tudo:**
1. Este `CODEX-SYSTEM-MAP.md` (visão integrada)
2. `HEALER-OVERVIEW.md` (contexto profundo de negócio)
3. `brand/BRANDBOOK.md` (como o produto fala e parece)
4. `product/PRD-MVP.md` (o que entra e o que fica de fora)
5. `product/FLOWS.md` (como o usuário se move pelo produto)
6. `product/ROADMAP.md` (sequência de build)

---

## 13. Métricas-norte (saber se tá funcionando)

| Estágio | KPI | Meta |
|---|---|---|
| Beta (M1-3) | Consultas/user/semana | ≥ 25 |
| Beta (M1-3) | Ativação D0 (login + 1 códice + 3 cons) | ≥ 50% |
| Lançamento (M4) | Sign-ups na 1ª semana | 200-500 |
| Lançamento (M4-6) | Conversão Free→Pago em 14d | ≥ 4% |
| MRR M3 pós-launch | Receita | R$ 8k |
| MRR M6 pós-launch | Receita | R$ 25k (gatilho paid media pesado) |
| Margem bruta Residente ativo | % | ≥ 70% |
| TTFT chat | latência | ≤ 1,8s p50 |
| Custo médio por consulta Haiku | R$ | ≤ 0,012 |

---

## 14. Em uma frase

> "O Codex é um chat com um livro de medicina, com sotaque brasileiro de estudante de quarto ano e bom-senso de preceptor — Pix recorrente, citação clicável e fundações de marca + produto totalmente travadas. Falta construir o software."
