# RECOMMENDATIONS — Pricing, caps, anti-abuse, ajustes de modelo

**Versão:** 1.0 · 2026-05-02
**Owner:** Ledger
**Decisão final:** Leonardo (clickwaveGG)
**Princípio guia:** "Margem sobre receita — crescer receita sem margem é destruir valor."

---

## 1. Sumário das recomendações (Traffic Light Ledger)

| Decisão | Status atual | Recomendação | Severidade |
|---|---|---|---|
| Pricing Residente R$ 14,90 | Bandeira de captura | **AJUSTAR pra R$ 19,90 OU manter 14,90 com cap radicalmente apertado** | 🔴 |
| Pricing Clínico R$ 29,90 | Insustentável no uso pesado | **AJUSTAR pra R$ 39,90-49,90** | 🔴 |
| Pricing Preceptor R$ 297 lifetime | Bomba financeira sem trava | **MANTER pricing + adicionar cap mensal hard + validade 36m + MFA** | 🔴 |
| Cap Estagiário 50/dia | Drena LLM grátis | **APERTAR para 10/dia OU virar trial 7 dias** | 🔴 |
| Cap Residente 300/dia | Power user fura | **APERTAR para 100/dia + cap mensal 1.500** | 🔴 |
| Cap Clínico 1000/dia | Catastrófico no power | **APERTAR para 150/dia + cap mensal 2.000** | 🔴 |
| Cap Preceptor 1500/dia | Catastrófico no power | **APERTAR para 200/dia + cap mensal 2.500** | 🔴 |
| Output cap por consulta | Inexistente | **CRIAR: max 1.500 tokens server-side** | 🔴 |
| Input cap por consulta | Inexistente | **CRIAR: max 8.000 tokens server-side** | 🔴 |
| Annual discount -33% | Generoso pra estudante | **REDUZIR para -25%** | 🟡 |
| Sonnet default Clínico | Drena margem | **ROUTING: Sonnet só em `/caso`, `/diferenciar`** | 🔴 |
| Anti-abuse | Inexistente | **Rate limit IP, captcha, MFA Preceptor, ban detector** | 🟡 |
| Otimização A (prompt enxuto) | Não aplicada | **APLICAR antes do build começar (product-orqx)** | 🟢 |

---

## 2. PRICING — análise por tier

### 2.1 Tier Estagiário (free)

#### Problema
Cap 50/dia × 22 dias úteis × R$ 0,015 = R$ 16,50/mês de LLM por estagiário ativo. Em base de 1.500 free users, são **R$ 24.750/mês** de queima sem retorno se conversão fica em 4%.

#### Recomendação Ledger: 2 caminhos
**Caminho A (preferido) — Trial 7 dias agressivo**
- 7 dias com 50 cons/dia + 2 códices
- D8: paywall obrigatório (downgrade pra "view-only" ou pague)
- Custo CAC explícito: R$ 5,21/free user (one-shot, não recorrente)
- Conversão esperada: 8-12% (urgência clara)

**Caminho B — Estagiário permanente mas mínimo**
- 10 cons/dia + 1 códice
- Sem expiração
- Custo: ~R$ 3,30/free user/mês (bem menor)
- Conversão esperada: 3-5% (sem urgência forte)

> **Decisão recomendada:** Caminho A pro lançamento (urgência move conversão); migrar pra B se churn pré-paywall ficar alto (>40% nunca pagam).

### 2.2 Tier Residente (atual R$ 14,90/mês)

#### Problema
- Custo média ponderada com cap atual: R$ 39,06 → margem -163%
- Mesmo com Otimização A: R$ 22 → margem -47%
- R$ 14,90 NÃO PAGA o uso médio modelado

#### 3 cenários de ajuste

**Cenário X1 — Manter R$ 14,90 (bandeira de captura)**
- Cap radicalmente apertado: **80/dia + 1.200/mês**
- Otimização A obrigatória
- Custo médio: ~R$ 6,26/mês
- Margem: R$ 8,64 = **58%** (abaixo do target 70%)
- Trade-off: pricing simbólico atrai conversão; user que cresce migra pra Clínico

**Cenário X2 — Subir para R$ 19,90**
- Cap: 100/dia + 1.500/mês
- Custo médio: ~R$ 7,83/mês
- Margem: R$ 12,07 = **61%** (perto do target)
- Trade-off: barreira pequena vs R$ 14,90; pode reduzir conversão em 10-15%

**Cenário X3 — Subir para R$ 24,90 (target margem 70%)**
- Cap: 120/dia + 1.800/mês
- Custo médio: ~R$ 9,40/mês
- Margem: R$ 15,50 = **62%** (ainda não bate 70% no uso médio realista)
- Margem 70% requer: receita R$ 31,33+ ou custo R$ 7,47-

> **Recomendação Ledger:** **Cenário X2 (R$ 19,90)** — equilibra bandeira acessível + caminho pra margem. Pra cravar 70%, precisa também Cenário X3 OU otimização B (re-treino do uso real).

### 2.3 Tier Clínico (atual R$ 29,90/mês)

#### Problema
Stress test prova: power user = R$ 2.161,85/mês de custo. Mesmo com mitigações fortes, custa R$ 42 = quebra margem.

#### Recomendação Ledger
**Pricing R$ 49,90/mês**
- Cap: 150/dia + 2.000/mês hard
- Sonnet 5-15% (só comandos específicos com aviso "modo profundo")
- Custo médio (com otimização A): ~R$ 30
- Margem: R$ 19,90 = **40%** (ainda baixo)

**OU** Pricing R$ 79,90/mês com posicionamento "pro/profissional" (R1+)
- Cap: 250/dia + 3.000/mês
- Sonnet 15%
- Custo médio: R$ 45
- Margem: R$ 34,90 = **44%**

> **Recomendação Ledger:** **R$ 49,90 com cap 150/dia + 2.000/mês**. Persona Clínico = residente HC (Pedro do PRD), tem disposição a pagar R$ 50 facilmente vs cursinho R$ 200/mês. Sinaliza tier "sério" sem espantar.

### 2.4 Tier Preceptor (atual R$ 297 lifetime)

#### Problema
Lifetime sem cap mensal = bomba lenta. Power user vira R$ 25k de prejuízo em 12 meses.

#### Recomendação Ledger
1. **Manter pricing R$ 297** (símbolo de "founding member" tem peso emocional)
2. **Adicionar cap mensal hard: 2.500 cons/mês** (igual Clínico+25%, não 1500/dia × 30 = 45.000)
3. **Adicionar validade 36 meses** com cláusula clara nos termos: "uso ilimitado por 36 meses; após, downgrade automático para Residente OU renovação com 50% off (R$ 148,50)"
4. **MFA obrigatório** no signup pra evitar conta vendida/compartilhada
5. **Limite de uploads diários:** 5 códices/dia (evitar bot que sobe tudo)
6. **Detector de abuso:** se uso > 80% do cap mensal por 3 meses seguidos → flag pra revisão manual

#### Payback estimado (user low engagement)
- 1.000 cons/mês × R$ 0,0186 = R$ 18,60 custo/mês
- "Custo evitado" se fosse Residente R$ 19,90 = R$ 19,90 receita/mês
- Payback do R$ 297: 297 ÷ 19,90 = **15 meses**

#### Risco residual
Mesmo com mitigações, alguém usando 100% dos 2.500/mês por 36 meses = R$ 1.500 de custo (Haiku otimizado) vs R$ 297 receita = -R$ 1.200 prejuízo individual.
- **Mitigação:** Cap Preceptor disponível só nos primeiros 100 users como "founding members" — depois fecha. Limita downside total.

### 2.5 Annual discount (atual -33%)

#### Problema
- Residente R$ 14,90/mês → R$ 178,80/ano normal
- Anual R$ 119/ano = -33% = R$ 9,92/mês equivalente
- **Annual reduz receita em R$ 60/user comparado a 12× mensal**
- Para estudante (público naturalmente cíclico semestre), -33% é generoso demais

#### Recomendação Ledger
- **Reduzir annual para -25%**
- Residente anual: R$ 134/ano (vs R$ 119 atual; +R$ 15)
- Clínico anual (se subir pra R$ 49,90): R$ 449/ano (-25%)
- Mantém valor psicológico do "salva 3 meses" sem queimar margem

---

## 3. CAPS — proposta nova vs atual

### Tabela comparativa
| Tier | Cap diário atual | Cap diário NOVO | Cap mensal NOVO | Output max/cons | Input max/cons |
|---|---|---|---|---|---|
| Estagiário | 50 | **10** (ou trial 7d×50) | **300** (~10/dia) | 1.000 tok | 6.000 tok |
| Residente | 300 | **100** | **1.500** | 1.500 tok | 8.000 tok |
| Clínico | 1.000 | **150** | **2.000** | 2.000 tok | 10.000 tok |
| Preceptor | 1.500 | **200** | **2.500** | 2.000 tok | 10.000 tok |

### Justificativa caps
- **Diário:** evita pico abusivo num dia só
- **Mensal:** evita acumulação de power user (ex: 1000/dia × 30 = 30.000 — inviável)
- **Output cap:** "/resumir livro inteiro" não pode gerar 8k tokens (custo R$ 0,40 numa consulta só)
- **Input cap:** RAG sempre limita pra ~5 chunks de 1.500 tok = 7.500 + system + query ≈ 10k

### Onde travar (ordem de implementação)
1. `SCHEMA.sql` → tabela `users.tier_caps` JSONB com `daily`, `monthly`, `output_max`, `input_max`
2. Middleware `/api/consultations` POST → check ambos caps antes de chamar LLM
3. Anthropic call → forçar `max_tokens` no body conforme tier+command
4. RAG retrieval → max chunks = 5, max tokens chunk = 1.500
5. Cron diário → reset `daily_count`; cron mensal → reset `monthly_count`

---

## 4. ROUTING SONNET — não default no Clínico

### Estado atual
PRD diz "Clínico+Preceptor têm Haiku + Sonnet 4.5". Não especifica QUANDO Sonnet é chamado. Risco: dev implementa "se tier ≥ clinico, sempre Sonnet" → custo dispara.

### Recomendação Ledger — whitelist por slash-command
| Slash | Modelo | Justificativa |
|---|---|---|
| `/resumir` | Haiku | tarefa simples, Haiku entrega bem |
| `/explicar` | Haiku | conceitual, Haiku 4.5 boa |
| `/quizar` | Haiku | template estruturado |
| `/caso` | **Sonnet** | raciocínio complexo, vale o custo |
| `/diferenciar` | **Sonnet** | tabela DDx exige profundidade |
| `/dose` | Haiku | resposta curta + aviso bula |
| Chat livre (sem slash) | Haiku | default conservador |

### Mecanismo
- Middleware `model-router.ts` lê tier + slashCommand → retorna model
- Se user Clínico/Preceptor explicitamente pede `/profundo` (novo modificador opcional), upgrade pra Sonnet
- Custo Sonnet emite evento PostHog `sonnet_used` pra Helicone trackear

### Impacto na margem
- Mix Clínico passa de "presumido 50/50" pra **realista 85/15** (só `/caso` e `/diferenciar` rodam Sonnet, e nem todo user usa esses comandos)
- Reduz custo Clínico em ~50% no agregado

---

## 5. ANTI-ABUSE — defesas obrigatórias antes do lançamento público

### Camada 1 — Bot detection
- **Rate limit por IP:** max 10 signups/dia/IP (Upstash Redis)
- **Captcha:** Turnstile Cloudflare (free) na tela signup
- **Disposable email block:** lista mailcheck.api ou regex
- **Honeypot field:** campo invisível no form, se preenchido = bot

### Camada 2 — Account abuse
- **MFA obrigatório no Preceptor** (TOTP via app — sem SMS pq custo)
- **MFA opcional Clínico** (recompensa: +50 cons/mês como upsell)
- **Conta compartilhada detector:** se 3+ IPs distintos em 7 dias → flag manual
- **Device fingerprint** (FingerprintJS open source) → ban repetido bypass

### Camada 3 — Usage abuse
- **Output cap server-side** (já listado em §3)
- **Soft warning** quando user atinge 80% do cap mensal
- **Hard ban** se user fizer >50 queries em 1 minuto (bot)
- **Helicone alert:** se user > R$ 30/dia em LLM cost → freeze conta automático + email "verifique abuso"

### Camada 4 — Preceptor especial
- Limite **5 códices/dia** uploads (evita bot subindo todo Robbins de uma vez)
- Termos: "uso justo, suspensão se uso anômalo"
- **Limite total de 100 Preceptors** (founding members) — depois desse número, fecha tier

---

## 6. OUTPUT CAP — exemplos de query custosa

### Antes (sem cap)
| Query | Tokens output | Custo Sonnet | BRL |
|---|---|---|---|
| "/resumir Robbins inteiro" | 10.000 | $0,15 | R$ 0,75 |
| "/quizar 100 questões" | 6.000 | $0,09 | R$ 0,45 |
| "Explica TUDO sobre cardio" | 8.000 | $0,12 | R$ 0,60 |

### Depois (com cap output 1.500-2.000)
| Query | Tokens output capped | Custo Sonnet | BRL |
|---|---|---|---|
| "/resumir [escopo limit cap]" | 2.000 | $0,03 | R$ 0,15 |
| "/quizar [5 questões padrão]" | 1.500 | $0,0225 | R$ 0,11 |
| Chat livre | 2.000 | $0,03 | R$ 0,15 |

> **Cap output reduz custo extremo em 75%+** sem afetar UX (resposta de 1.500 tok = ~1.000 palavras = mais que suficiente pra resumo de capítulo).

---

## 7. ROADMAP de implementação das recomendações

### Pré-build (esta semana — antes de Sprint 1.1)
- [ ] **Aprovação founder:** novo pricing (Residente R$ 19,90 / Clínico R$ 49,90 / Preceptor mantido)
- [ ] **Aprovação founder:** novos caps (10/100/150/200 diário + mensais)
- [ ] **Aprovação founder:** annual -25% em vez de -33%
- [ ] **Aprovação founder:** Estagiário trial 7d OU Estagiário 10/dia permanente
- [ ] **Atualizar PRD-MVP.md seção 5** (custo unitário) com novos números
- [ ] **Atualizar SLASH-COMMANDS.md** com routing Sonnet por comando
- [ ] **Atualizar SCHEMA.sql** com `tier_caps` JSONB incluindo monthly + output_max + input_max

### Durante Sprint 1.1-1.2 (setup)
- [ ] Middleware tier_caps com check daily + monthly
- [ ] Output max_tokens forçado no body Anthropic
- [ ] Rate limit Upstash (free tier)

### Durante Sprint 1.3 (validação real)
- [ ] **Validar custo real Haiku** com 100 consultas teste (provar Otimização A funciona)
- [ ] **Validar custo embedding** com 5 livros teste (Robbins capítulo + Porto + apostila)
- [ ] Helicone dashboard: custo por consulta por tier por command

### Durante Sprint 3.1-3.2 (billing)
- [ ] Anti-abuse: Turnstile no signup
- [ ] MFA TOTP no Preceptor
- [ ] Helicone alert R$ > 30/dia/user → freeze automático
- [ ] Validade 36m Preceptor implementada (cron)

### Pós-launch (M2-3)
- [ ] Análise de uso real → re-calibrar caps se necessário
- [ ] A/B test pricing R$ 19,90 vs R$ 24,90 Residente (split 50/50 por 30 dias)

---

## 8. Decisões para Leonardo APROVAR

> Este bloco é o handoff direto pro founder. Cada decisão precisa de "sim/não/mudar".

### Decisão 1 — Pricing
- [ ] Manter R$ 14,90/29,90/297 com caps APERTADÍSSIMOS?
- [ ] Subir pra R$ 19,90/49,90/297 (Ledger recomenda)?
- [ ] Subir pra R$ 24,90/79,90/397 (mais agressivo, melhor margem)?

### Decisão 2 — Tier Estagiário
- [ ] Trial 7 dias com paywall obrigatório?
- [ ] Permanente mas reduzido a 10 cons/dia + 1 códice?
- [ ] Manter 50 cons/dia (Ledger NÃO recomenda — quebra margem)?

### Decisão 3 — Caps duros
- [ ] Implementar cap MENSAL além do diário (10/300/2k/2,5k)?
- [ ] Implementar output cap por consulta (1k-2k tokens)?
- [ ] Implementar input cap server-side (8-10k tokens)?

### Decisão 4 — Sonnet routing
- [ ] Whitelist por slash-command (`/caso`, `/diferenciar` only)?
- [ ] Sempre disponível pra Clínico+ (modelo atual; Ledger NÃO recomenda)?

### Decisão 5 — Annual discount
- [ ] Manter -33%?
- [ ] Reduzir pra -25% (Ledger recomenda)?

### Decisão 6 — Preceptor lifetime
- [ ] Cap mensal hard 2.500 cons/mês?
- [ ] Validade 36m com renovação 50% off?
- [ ] MFA obrigatório?
- [ ] Limite total 100 Preceptors (fecha depois)?

### Decisão 7 — Otimização A do prompt
- [ ] Aplicar antes da Sprint 1.1 (cortar system prompt 30%, output max, RAG 3 chunks)?

---

## 9. Resumo de uma linha pro Leonardo

> **Modelo financeiro do Codex NÃO FECHA com pricing/caps atuais — quebra entre R$ 5k e R$ 33k/mês dependendo do cenário. Pra fechar margem 70%: subir Residente pra R$ 19,90, Clínico pra R$ 49,90, apertar caps pra 100/dia (Residente) + 150/dia (Clínico), reformar Estagiário pra trial 7d ou 10/dia permanente, restringir Sonnet a 2 comandos específicos, aplicar Otimização A no prompt — tudo travado server-side.**
