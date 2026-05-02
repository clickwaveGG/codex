# Codex — Funil de Captura IG → Beta

**Documento:** fluxo completo de conversão Instagram → waitlist → email → beta
**Versão:** 2026-05-02
**Autor:** Catalyst (squad-growth)

---

## 1. Visão geral do funil (1 imagem em texto)

```
┌────────────────────────────────────────────────────────────────────┐
│  AQUISIÇÃO — IG (orgânico)                                         │
│                                                                    │
│   Reel/Carrossel/Story/Live → ALCANCE 1.000-50.000/peça            │
│                ↓                                                   │
│   Perfil clica em "ver perfil" ou "link na bio"                    │
└────────────────┬───────────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────────┐
│  CAPTURA — Bio + Landing waitlist                                  │
│                                                                    │
│   Bio com CTA "↓ entra na lista de espera"                         │
│   Click no link → landing /lista-espera                            │
│                ↓                                                   │
│   Form simples: email + curso (Med/Enf/Fisio/Farma/etc)            │
│   "Submit" → confirma + envio email #1 IMEDIATO                    │
└────────────────┬───────────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────────┐
│  NUTRIÇÃO — Sequência email-marketing (5 emails)                   │
│                                                                    │
│   Email #1 (T+0 imediato): boas-vindas + posição na fila           │
│   Email #2 (T+3 dias): bastidores + "tô construindo isso"          │
│   Email #3 (T+10 dias): demo do produto + slash-commands           │
│   Email #4 (T+20 dias): countdown beta + critério dos 30 primeiros │
│   Email #5 (T+30 dias): "TU ENTROU" ou "próxima leva em 30 dias"   │
└────────────────┬───────────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────────┐
│  ATIVAÇÃO — Convite beta privado                                   │
│                                                                    │
│   Top 30 da fila recebem link de cadastro com token único          │
│   Sign-up → upload primeiro códice → primeira anamnese (D0)        │
│                ↓                                                   │
│   Beta gratuito (30 dias) → conversão pra Residente/Clínico/       │
│   Preceptor pós-beta                                               │
└────────────────────────────────────────────────────────────────────┘
```

---

## 2. Página de captura (waitlist) — spec

> NOTA: design + copy detalhada cabe a `design-orqx` + `copy-orqx`. Aqui dou o spec funcional.

### URL
`codex-clickwave.vercel.app/lista-espera` ou similar (usar mesma URL no link da bio)

### Componentes mínimos

1. **Hero** com headline curta:
   - "Lista de espera do beta privado"
   - Sub: "Beta abre dia [DATA]. 30 vagas pros primeiros da fila."

2. **Formulário curto** (FRICÇÃO MÍNIMA):
   - Campo 1: email (obrigatório)
   - Campo 2: curso (dropdown: Medicina / Enfermagem / Fisioterapia / Farmácia / Odontologia / Nutrição / Biomedicina / Outro)
   - Campo 3 (OPCIONAL): semestre/ano (dropdown)
   - Botão CTA: "Quero entrar na lista" (Inter 600 + bg primary)

3. **Confirmação inline** (sem redirect):
   - "Pronto! Tu entrou na lista. Tua posição: #X"
   - "Confere teu email — chegou um confirmação. Adiciona contato@codex.app pros próximos emails não caírem em spam."
   - Compartilhar: "Compartilha pra amigo entrar e tu sobe na fila" (link com `?ref=email_hash`)

4. **Trust signals** (abaixo do form):
   - "X estudantes na fila" (contador real ou semi-real — atualizar manual)
   - 3-5 depoimentos curtos quando tiver (pode usar "comentário do reel D5")
   - "Sem spam. Free pra sempre. Pix recorrente no plano pago."

5. **Disclaimer rodapé:**
   > "Codex é ferramenta de estudo. Não substitui avaliação clínica presencial. Termos e Privacidade."

### Tracking obrigatório
- Pixel/evento `waitlist_view` quando carrega a página
- Evento `waitlist_submitted` quando envia o form
- Parâmetros UTM capturados: `utm_source`, `utm_medium`, `utm_campaign` (de cada post IG e cada link de afiliado)
- Cookie de atribuição: 30 dias

---

## 3. Sequência de email-marketing (5 emails)

> NOTA: copy detalhada cabe a `copy-orqx`. Aqui dou estrutura + intenção.

### Email #1 — IMEDIATO (T+0min)

**Assunto:** "Tá na lista. Tua posição: #X"

**De:** "Leonardo do Codex" `<leonardo@codex.app>` (ou similar — humanizar remetente)

**Estrutura:**
- Saudação calorosa em PT-BR coloquial
- Confirma a posição na fila
- Resumo de 2-3 linhas: o quê é o Codex
- Promessa de cadência: "vou te mandar 4 emails ao longo de 30 dias contando como tá indo a construção. Sem spam, prometo."
- 1 link pra "compartilha pro amigo entrar" (sobe na fila)
- 1 link pro IG @codex.saude
- Footer: disclaimer + opt-out

**Função:** confirmação + setar expectativa.

### Email #2 — T+3 dias

**Assunto:** "Por quê tô construindo o Codex sozinho às 4h da manhã"

**Estrutura:**
- Bastidores: foto da mesa + storytelling de 200-400 palavras
- Quem é o Leonardo (web designer + sócio de agência) e por quê resolveu construir
- Por quê pra estudante de saúde (mesmo não sendo da área)
- 1 link pro melhor reel/carrossel da semana 1
- CTA: "responde esse email me contando qual é a tua maior dor de estudo — leio TODOS os emails"

**Função:** humanizar criador + criar relação 1:1 + coletar feedback qualitativo.

### Email #3 — T+10 dias

**Assunto:** "Como vai funcionar o Codex (em 5 prints)"

**Estrutura:**
- Demo via 5 prints/screenshots (mesmo conteúdo do Carrossel D9)
- Explicação de cada slash-command
- Tabela curta de tiers (Estagiário/Residente/Clínico/Preceptor)
- Pergunta: "qual command tu quer testar PRIMEIRO?" (link de poll: 4 opções)
- CTA: "Compartilha o convite com colega pra ele entrar na lista também"

**Função:** demo + ativar curiosidade + segmentar audiência (qual command interessa).

### Email #4 — T+20 dias

**Assunto:** "Faltam 10 dias. Beta abre [DATA]. Tu tá na posição #X."

**Estrutura:**
- Countdown explícito
- Atualização da posição na fila (re-render dinâmico ou só "Top 30: Top X / Top 30")
- Critério dos 30 primeiros: "Top 30 da fila inscrita até [DATA] entram. Resto vai pra próxima leva em 30 dias."
- Link pra subir na fila via referral
- 1 trecho de feedback de outro inscrito ("estou no #47 e mal posso esperar" — UGC)

**Função:** urgência + FOMO + incentivar referral.

### Email #5 — T+30 dias (DIA D)

**Variação A — TU ENTROU (top 30)**
- **Assunto:** "TU ENTROU. Beta tá no ar. Bora?"
- Link único com token de cadastro
- Tutorial rápido (1-2 min de leitura)
- Sugestão de "primeiro códice" pra subir
- Promessa: "responde esse email com tua experiência das primeiras 24h"

**Variação B — Não entrou (resto)**
- **Assunto:** "Próxima leva abre em 30 dias — tu tá na #47"
- Explica o que tá acontecendo (30 já beta)
- Promete próxima leva em D60
- Bonus: oferece 50% off no Residente do primeiro mês quando o beta abrir público (D90)
- Pede pra continuar engajado no IG

**Função:** ativação (top 30) ou retenção (resto).

---

## 4. Ferramenta de email — DECISÃO

**Escolhido: Resend + React Email** (em vez de ConvertKit/Loops/MailerLite)

Por quê:
- Já está na stack do Codex (Vercel + Next.js casa perfeito com Resend)
- Free tier 3.000 emails/mês = mais que suficiente nos primeiros 30 dias (waitlist com 1-3k cadastrados × 5 emails = 5-15k → entra no Pro $20/mês quando precisar)
- React Email permite templatizar com mesmo design system do produto
- Segmentação simples via tags no Supabase (não precisa CRM separado)

Stack proposta:
- **Lista:** tabela `waitlist` no Supabase do Codex (mesma DB do produto)
- **Disparador:** API Route do Next.js + Cron Vercel pra emails agendados (T+3, T+10, T+20, T+30)
- **Templates:** React Email componentizado em `/email/templates/`
- **Tracking:** webhook Resend → eventos PostHog

**Fallback:** se Resend não couber, **Loops.so** ($24/mês entry) — mais barato que ConvertKit, foco em founder solo, integração nativa com waitlists.

---

## 5. KPIs por etapa do funil (com benchmarks)

### Etapa 1 — IG → click no link da bio (CTR bio)

| Métrica | Meta mês 1 | Aceitável | Bom |
|---|---|---|---|
| CTR bio (cliques no link / visitas ao perfil) | 5% | 3% | 8%+ |
| Visitas ao perfil/mês | 3.000-8.000 | 1.500 | 15.000+ |
| Cliques no link da bio/mês | 200-500 | 100 | 800+ |

**Benchmark:** contas de educação BR pequenas têm CTR 3-7% — Codex bem posicionado deve ficar em 5-8% (CTA forte na bio + landing prometendo valor).

### Etapa 2 — Click → submit do form (conversão landing)

| Métrica | Meta | Aceitável | Bom |
|---|---|---|---|
| Conversão landing (submit / view) | 25% | 15% | 35%+ |
| Tempo médio na página | 30-60s | 20s | 90s+ |
| Bounce rate | <50% | <70% | <30% |

**Benchmark:** landing waitlist simples bem desenhada converte 20-40% (a barreira é só email + curso). Se converter <15%, o problema é copy/design da landing.

### Etapa 3 — Submit → email aberto (open rate)

| Métrica | Meta | Aceitável | Bom |
|---|---|---|---|
| Open rate Email #1 (boas-vindas) | 60% | 45% | 75%+ |
| Open rate Email #2 (bastidores) | 40% | 30% | 55%+ |
| Open rate Email #3 (demo) | 35% | 25% | 50%+ |
| Open rate Email #4 (countdown) | 50% | 35% | 65%+ |
| Open rate Email #5 (DIA D) | 70% | 55% | 85%+ |

**Benchmark:** waitlist tem open rate 40-60% típico (interesse alto, lista quente). Se Email #1 ficar <45%, problema é assunto/remetente. Se Email #5 <55%, audiência esfriou no caminho.

### Etapa 4 — Email aberto → click (CTR email)

| Métrica | Meta | Aceitável | Bom |
|---|---|---|---|
| CTR Email #1 | 15% | 8% | 25%+ |
| CTR Email #5 (link de cadastro) | 80% | 60% | 90%+ |

### Etapa 5 — Top 30 → ativação no beta (D0)

| Métrica | Meta | Aceitável | Bom |
|---|---|---|---|
| Cadastro no beta (clique link → cadastrado) | 90% | 75% | 95%+ |
| Ativação D0 (cadastro + 1 códice + 3 anamneses no D0) | 60% | 40% | 75%+ |
| Retenção D7 (ainda fez consulta no dia 7) | 50% | 35% | 65%+ |

### Etapa 6 — Beta → conversão pra pago (pós beta gratuito 30d)

| Métrica | Meta | Aceitável | Bom |
|---|---|---|---|
| Conversão beta → assinante pago | 30% | 20% | 45%+ |

**Premissa Leonardo:** "conversão waitlist → beta active assumida 30%" — alinha com `bom` se considerar a jornada inteira (1.000 inscritos → 300 ativos como beta + freemium recorrente). No funil estrito, "beta privado tem 30 vagas e top 30 entram = 100%" então a conversão real medida é nos 30 (60% ativação D0 = 18 ativos é meta saudável).

---

## 6. Funil consolidado (números reais esperados — cenário base)

Cenário base: mês 1 com Leonardo solo executando esse plano à risca.

```
ALCANCE IG (impressões totais, todos posts) ──── 80.000 - 200.000
        │ taxa engajamento ~3%
        ▼
PERFIL VIEWS ────────────────────────────────────  4.000 -  8.000
        │ CTR bio ~5%
        ▼
CLIQUES NO LINK DA BIO ──────────────────────────    200 -    500
        │ + 100-200 vindos de afiliados (parcerias)
        ▼
CLIQUES TOTAIS NO WAITLIST ──────────────────────    300 -    700
        │ conversão landing ~25%
        ▼
INSCRITOS NA WAITLIST ───────────────────────────     75 -    175
        │
        │ + boost final (push semana 4) → +50-100%
        ▼
INSCRITOS FINAIS NO MÊS 1 ───────────────────────    150 -    350

⚠️ Mais conservador que a meta de Leonardo (1.000-3.000)
```

### Como bater 1.000+ inscritos no mês 1

Pra atingir a meta de Leonardo (1.000-3.000), precisamos de UMA OU MAIS dessas alavancas:

1. **1 viral orgânico** — 1 reel passando 200k+ views adiciona 300-800 inscritos sozinho
2. **1 parceria forte com criador 50k+** — adiciona 200-500 inscritos
3. **R$ 500-2k em paid media (Meta Ads)** boosting o melhor reel — adiciona 500-1.500 inscritos
4. **Repost de comunidade grande** (grupo WhatsApp/Telegram de medicina com 5k+ membros) — adiciona 100-400 inscritos

Cenário realista pra 1.000+ no mês 1 é COMBINAÇÃO de alavancas (1 viral + 2 parcerias OU paid media). Ver `IG-KPIS.md` pra critério de quando ativar paid.

---

## 7. Tracking técnico (TO-DO pra design + dev)

### Eventos PostHog mínimos no mês 1

```
Evento                          Disparado em             Propriedades
─────────────────────────────────────────────────────────────────────────
ig_link_clicked                 link bio IG              utm_source, utm_campaign, post_id
waitlist_view                   landing carrega          referrer, utm_*, device
waitlist_submitted              form enviado             email_hash, curso, semestre, utm_*, position
waitlist_referral_clicked       link compartilhado clicado  ref_source
email_sent                      Resend dispara           email_id, recipient_hash, sequence_n
email_opened                    pixel Resend             email_id, opened_at
email_link_clicked              webhook Resend           email_id, link_url
beta_invitation_sent            email #5A enviado        recipient_hash, position
beta_signup_started             cadastro iniciado        token, email_hash
beta_signup_completed           cadastro completo        user_id
beta_first_codex_uploaded       primeiro upload          user_id, codex_size
beta_first_anamnese             primeira pergunta        user_id, slash_command (se houver)
```

Quem implementa: design-orqx (eventos no front) + signal/ga-analytics-engineer (tracking plan formal).

### Dashboard mínimo (PostHog) pra acompanhar diariamente

1. **Funil principal:** `ig_link_clicked` → `waitlist_view` → `waitlist_submitted` (taxa de conversão por etapa)
2. **Source breakdown:** waitlist signups por `utm_source` (orgânico vs afiliado vs eventual paid)
3. **Email performance:** open rate + CTR por email da sequência
4. **Top posts driving signups:** mapeamento `utm_campaign` (cada post tem ID único) → signups
5. **Beta conversion:** `beta_invitation_sent` → `beta_signup_completed` → `beta_first_anamnese`

---

## 8. Boas práticas LGPD/CFM aplicadas ao funil

1. **Consentimento explícito no form:** checkbox "concordo em receber emails do Codex e termos de privacidade" — sem auto-opt-in
2. **Footer todo email:** link "descadastrar" (Resend faz nativo) + endereço físico (CNPJ ClickWave)
3. **NÃO coletar dado clínico** no form (só email + curso + semestre — sem CPF, sem dado sensível)
4. **Disclaimer CFM** já no rodapé da landing + emails 3, 4 e 5 (que mencionam o produto em uso)
5. **Política de Privacidade** linkada no rodapé do form e dos emails — versão básica pode ser do brandbook §3 expandida

---

## 9. Cenários de falha e mitigação

| Falha | Sintoma | Mitigação |
|---|---|---|
| CTR bio <2% | Pouco click no link | Reescrever bio + testar variantes (A/B em S3) |
| Conversão landing <10% | Pessoas chegam mas não inscrevem | Reduzir fricção do form (tirar campo curso → fazer opcional) + simplificar copy |
| Email #1 open <40% | Assunto ou remetente ruim | Trocar assunto pra perguntas vs afirmações + remetente "Leonardo" vs "Codex" |
| Email #2-3 open caindo | Audiência fria | Quebrar cadência (mandar 1 antes do esperado pra reativar) ou pular email |
| Inscritos crescem mas zero engagement | Lista é "fake" (gente que esqueceu) | Email de re-engajamento "ainda quer entrar?" — limpa lista e reduz custo |
| Beta cadastrado mas não usa | Onboarding ruim do produto | Ativação D0 baixa = handoff pra `product-orqx` + `design-orqx` revisarem onboarding |

---

## 10. Próximos passos imediatos

1. **D1-3:** copy-orqx escreve copy detalhada da landing waitlist + 5 emails
2. **D3-7:** design-orqx aplica brand na landing waitlist + cria templates React Email
3. **D7:** dev integra Resend + cria tabela `waitlist` no Supabase + endpoints submit + cron emails
4. **D8:** landing waitlist NO AR — alinha com calendário editorial (Reel D8 anuncia)
5. **D8-30:** monitorar diariamente os KPIs do §5 — ajustar copy/timing se etapa <aceitável
6. **D30+:** revisar funil completo, otimizar pra próxima leva (D60 abre próxima rodada)

---

**Fim do IG-FUNNEL.md.** Próximo: `IG-KPIS.md`.
