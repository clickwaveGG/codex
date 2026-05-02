# STRESS-TEST — Cenário Power User extremo

**Versão:** 1.0 · 2026-05-02
**Owner:** Ledger
**Objetivo:** Simular Clínico que usa 100% do cap diário (1.000 cons/dia) por 30 dias e descobrir se a margem aguenta.

---

## 1. Premissas do stress test

### Comportamento power-user
- 30.000 consultas/mês (1.000/dia × 30 dias) — bate o cap todo dia
- Mix Haiku/Sonnet **50/50** (Vector original assumia esse mix pra Clínico/Preceptor)
- Tokens conforme premissa típica (5.250 in / 600-800 out)
- Cache hit ratio cai pra **40%** porque user explora muitos tópicos diferentes (RAG chunks variam mais)
- Output médio Sonnet: **800 tokens** (resposta mais elaborada)

### Cálculo custo/consulta no stress (cache 40%, sem otimização A)
**Haiku:**
- Cached: 5.250 × 0,40 = 2.100 → $0,000210
- Não-cached: 3.150 × $1.00/1M = $0,003150
- Output 600 × $5.00/1M = $0,003000
- Cache write amortizado: $0,000094
- **Total: $0,006454 = R$ 0,0323/cons**

**Sonnet:**
- Cached: 2.100 × $0.30/1M = $0,000630
- Não-cached: 3.150 × $3.00/1M = $0,009450
- Output 800 × $15.00/1M = $0,012000
- Cache write amortizado: $0,000281
- **Total: $0,022361 = R$ 0,1118/cons**

---

## 2. Custo total do power user Clínico (config ATUAL Vector)

| Item | Cálculo | Custo |
|---|---|---|
| 15.000 Haiku | 15.000 × R$ 0,0323 | R$ 484,50 |
| 15.000 Sonnet | 15.000 × R$ 0,1118 | R$ 1.677,00 |
| Embeddings (1 livro novo médio/mês × 600pp = 300k tok) | R$ 0,03 | R$ 0,03 |
| Storage (240 MB × 0,021 USD/GB) | | R$ 0,025 |
| Asaas (1% × R$ 29,90) | | R$ 0,30 |
| **Total custos** | | **R$ 2.161,85** |

### P&L deste user
| Linha | R$ |
|---|---|
| Receita | 29,90 |
| Custos | (2.161,85) |
| **Margem** | **(2.131,95)** |

> 🚨🚨🚨 **CATÁSTROFE:** 1 power user Clínico drena R$ 2.131,95/MÊS. Equivale a queimar 71x sua receita.
> Pra cobrir 1 power user, precisa de 142 Residentes pagando R$ 14,90 perfeitamente sem custo. Impossível.

### Cenário Preceptor (lifetime R$ 297) com mesmo uso
| Linha | R$ (mês) | R$ (12 meses) |
|---|---|---|
| Receita amortizada (sobre 24m target) | 12,38 | 148,50 |
| Custos | (2.161,85) | (25.942,20) |
| Margem | (2.149,47) | **-R$ 25.793,70** |

> **Preceptor lifetime power user = bomba financeira de R$ 26k em 12 meses.** Cada Preceptor abusivo destrói o equivalente de 173 Preceptors honestos.

---

## 3. Stress test com mitigações aplicadas

### Mitigação A: Apertar cap Clínico de 1000 → 500/dia
- 15.000 cons/mês total (Haiku 7.500 + Sonnet 7.500)
- Custo: 7.500 × 0,0323 + 7.500 × 0,1118 = R$ 242,25 + R$ 838,50 = **R$ 1.080,75**
- Margem: -R$ 1.050,85 (ainda quebra)

### Mitigação B: Sonnet só em comandos específicos (15% do mix)
- Mix novo: Haiku 85% / Sonnet 15%
- 30.000 cons/mês (cap 1000 mantido)
- Custo Haiku: 25.500 × R$ 0,0323 = R$ 823,65
- Custo Sonnet: 4.500 × R$ 0,1118 = R$ 503,10
- **Total: R$ 1.326,75**
- Margem: -R$ 1.296,85 (quebra)

### Mitigação C: Otimização A (prompt enxuto + output curto)
- Custo Haiku otimizado (cache 40% pq power user): R$ 0,0186/cons (recálculo)
- Custo Sonnet otimizado: R$ 0,071/cons
- Mix 85/15, 30.000 cons:
- Haiku: 25.500 × R$ 0,0186 = R$ 474,30
- Sonnet: 4.500 × R$ 0,071 = R$ 319,50
- **Total: R$ 793,80**
- Margem Clínico: -R$ 763,90 (ainda quebra)

### Mitigação D: TUDO COMBINADO + cap 500 + cap mensal hard
- Cap 500/dia × 30 = 15.000 cons/mês máximo
- Otimização A (custos R$ 0,0186 / R$ 0,071)
- Mix 85/15
- Custo: 12.750 × 0,0186 + 2.250 × 0,071 = R$ 237,15 + R$ 159,75 = **R$ 396,90**
- Margem Clínico: 29,90 - 396,90 = **-R$ 367,00 (quebra)**

### Mitigação E: cap MENSAL hard (independente do diário)
- Cap mensal Clínico = **3.000 consultas/mês** (média 100/dia)
- Custo: 2.550 × 0,0186 + 450 × 0,071 = R$ 47,43 + R$ 31,95 = **R$ 79,38**
- Margem Clínico: 29,90 - 79,38 = **-R$ 49,48 (ainda quebra)**

### Mitigação F: cap mensal mais apertado + Sonnet só com aprovação user
- Cap mensal **2.000 cons/mês** (média ~67/dia, ainda generoso)
- Sonnet **5%** do mix (só `/diferenciar` com paywall confirmação)
- Custo: 1.900 × 0,0186 + 100 × 0,071 = R$ 35,34 + R$ 7,10 = **R$ 42,44**
- Margem Clínico: 29,90 - 42,44 = **-R$ 12,54 (ainda quebra)**

### Mitigação G: Pricing Clínico subir
- Manter Mitigação F (cap 2k mensal, Sonnet 5%)
- Custo R$ 42,44
- Pricing Clínico: R$ 39,90 → margem R$ -2,54 (zero, ok)
- Pricing Clínico: R$ 49,90 → margem **R$ 7,46 = 15% (ainda baixo)**
- Pricing Clínico: R$ 59,90 → margem **R$ 17,46 = 29%**
- Pricing Clínico: R$ 79,90 → margem **R$ 37,46 = 47%**

### Mitigação H (FINAL — cravar margem 70% Clínico power)
- Pricing R$ 99,90/mês (alinha com mercado SaaS pro BR)
- Cap mensal 2.000
- Otimizado
- Custo R$ 42,44 → margem R$ 57,46 = **57,5%** (ainda abaixo de 70%, mas confortável)

> Pra atingir 70% margem em Clínico power, custo máx = R$ 30 → cap **~1.500 cons/mês ou ~50/dia**.

---

## 4. Stress test Preceptor lifetime — risco crítico

### O problema dos lifetimes
Preceptor R$ 297 one-shot **assume que o user vai usar X meses e parar**. Se ele usa 5 anos = **60 meses** consumindo médio:
- 60 × R$ 80 (custo médio Clínico ativo) = **R$ 4.800 de custo lifetime**
- Receita: R$ 297
- **Perda lifetime: R$ 4.503/user**

### Payback do Preceptor (cenário ideal usuário low-engagement)
- User Preceptor low: 1.000 cons/mês × R$ 0,0186 = R$ 18,60/mês custo
- Payback receita R$ 297 ÷ R$ 18,60 (custo evitado) = **16 meses** (ok)
- Mas se vira power: payback 0, prejuízo crescente

### Recomendação — limites mesmo no Preceptor
1. **Cap mensal hard: 2.500 cons/mês** (igual ao Clínico+50%, não 1.500/dia × 30 = 45.000)
2. **Validade de uso: 36 meses** (após isso, downgrade pra Residente automático ou renew com desconto)
3. **MFA obrigatório** pra evitar conta vendida/compartilhada
4. **Termos:** "uso justo", abusos detectados → suspensão

---

## 5. Tabela final — capa de risco por tier

| Tier | Cap atual (Vector) | Custo max sem mitigação | Recomendação Ledger | Custo com mitigação |
|---|---|---|---|---|
| Estagiário | 50/dia (1.500/mês) | R$ 48/mês LOSS | **10/dia + 30 dias trial** | R$ 4,47/mês |
| Residente | 300/dia (9.000/mês) | R$ 290/mês | **100/dia + 1.500/mês cap mensal** | R$ 27,90/mês |
| Clínico | 1.000/dia (30.000/mês) | R$ 2.162/mês | **150/dia + 2.000/mês cap mensal** | R$ 42/mês |
| Preceptor | 1.500/dia (45.000/mês) | R$ 3.243/mês | **200/dia + 2.500/mês cap mensal + 36m validade** | R$ 56/mês |

---

## 6. Stress test ALTERNATIVO — query custosa única

### O cenário "/resumir o livro inteiro"
User pede: `/resumir Robbins inteiro` (1500pp)
- LLM precisa contexto enorme: assumir 30k tok input
- Output: assume 8.000 tokens (resumo executivo)
- 1 chamada Sonnet: 30.000 × $3/1M + 8.000 × $15/1M = $0,090 + $0,120 = $0,21 = **R$ 1,05 por consulta**

> 1 query dessas custa o equivalente a **70 consultas normais**. Se 10 users fazem 1× por dia → R$ 315/mês de custo num único comando.

### Mitigação obrigatória
1. **Output cap server-side por consulta:** max 1.500 tokens output (independente do user pedir mais)
2. **Input cap server-side:** max 8.000 tokens contexto enviado ao LLM (RAG sempre limitado a 5 chunks)
3. **`/resumir [escopo]` validation:** só aceita escopo "capítulo" ou "seção", nunca "livro inteiro"
4. **`/dose-completa`, `/livro-todo` removidos** se existirem

### Custo capeado por consulta extrema (Sonnet com cap)
- Input 8.000 × $3/1M = $0,024
- Output 1.500 × $15/1M = $0,0225
- **Max custo único: $0,0465 = R$ 0,23**
- Aceitável (10x consulta normal, mas finite)

---

## 7. Conclusão STRESS-TEST

### Veredicto
- **Cap diário 1.000 no Clínico DESTRÓI MARGEM mesmo com todas mitigações.** Reduzir pra **150/dia** ou impor cap **mensal de 2.000 consultas**.
- **Sonnet 50/50 mix é INVIÁVEL.** Limitar a 5-15% do total (só comandos específicos com confirmação user).
- **Preceptor lifetime sem cap mensal é BOMBA FINANCEIRA.** Aplicar cap 2.500/mês + validade 36m + MFA.
- **Output cap por consulta é OBRIGATÓRIO** (1.500 tok max). Sem isso, 1 query pode custar R$ 1+.
- **Input cap server-side é OBRIGATÓRIO** (8.000 tok max, ou seja, RAG limitado a 5 chunks de 800).

### Decisões críticas que precisam ser TRAVADAS no PRD
1. Cap mensal hard além de cap diário (atualizar `SCHEMA.sql` users.tier_caps)
2. Output max_tokens server-side por slash-command (atualizar `SLASH-COMMANDS.md`)
3. Re-roteamento Sonnet (atualizar middleware Anthropic com whitelist de comandos)
4. Validade Preceptor 36 meses (atualizar `PRD-MVP.md` seção pricing)
5. MFA obrigatório no Preceptor (atualizar fluxo onboarding pago)
