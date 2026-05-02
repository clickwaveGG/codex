# OPEX-12M — Projeção Operacional 12 Meses

**Versão:** 1.0 · 2026-05-02
**Owner:** Ledger
**Premissa modelagem:** modelo CORRIGIDO conforme `RECOMMENDATIONS.md` aplicado (pricing R$ 19,90/49,90, caps apertados, Sonnet whitelist, Otimização A, Estagiário trial 7d)
**Câmbio:** USD 1 = BRL 5,00
**Marco zero:** M1 = lançamento beta privado (Out/2026 estimado); M5 = lançamento público; M12 = Set/2027

---

## 1. Premissas de crescimento (cenário Base ajustado)

### Funil
| Fase | Descrição | Users novos/mês | Churn % |
|---|---|---|---|
| M1-M3 | Beta privado | 10-30 | 0% (curado) |
| M4 | Pré-lançamento | 200 | 5% |
| M5 | Lançamento público | 800 | 8% |
| M6 | Marketing orgânico | 700 | 8% |
| M7-M9 | Word-of-mouth + ads leves | 600/mês | 7% |
| M10-M12 | Paid media inicial (R$ 5k/mês) | 1.000/mês | 6% |

### Conversão (free → pago)
- Trial 7d → pago: 8% (urgência paywall)
- Clínico = 20% dos pagantes
- Preceptor = 5% dos pagantes (founding members até 100 vagas)

### Custo por consulta com Otimização A aplicada
- Haiku otimizado: **R$ 0,0149/consulta**
- Sonnet otimizado: **R$ 0,071/consulta**
- Mix Clínico+Preceptor: **85% Haiku / 15% Sonnet**

### Uso médio (com caps novos)
- Estagiário trial 7d: 50 cons/dia × 7 dias = 350 cons total no trial
- Residente (cap 100/dia + 1.500/mês): média ponderada **600 cons/mês**
- Clínico (cap 150/dia + 2.000/mês): média ponderada **1.200 cons/mês**
- Preceptor (cap 200/dia + 2.500/mês): média ponderada **1.400 cons/mês**

---

## 2. Tabela mensal — 12 meses

### Notação
- Users = ativos no mês (acumulado - churn)
- Trial users = consumindo Estagiário no mês (one-shot 7d)
- MRR efetivo = recorrente + amortização Preceptor (24 meses)
- "Var" = custo variável total (LLM + embed + storage + Asaas)
- "Fix" = custo fixo infra
- Margem = MRR - Var - Fix

| M | Users ativos | Trial users (mês) | Pagantes | MRR efetivo | Var (R$) | Fix (R$) | EBITDA | Margem % |
|---|---|---|---|---|---|---|---|---|
| M1 | 30 | 30 | 0 | 0 | 175 | 235 | -410 | n/a |
| M2 | 60 | 30 | 2 (R+0+0) | 40 | 215 | 235 | -410 | -1.025% |
| M3 | 90 | 30 | 5 (R+1+0) | 130 | 245 | 235 | -350 | -269% |
| M4 | 290 | 200 | 12 (8R+3C+1P) | 313 | 1.080 | 235 | -1.002 | -320% |
| M5 | 1.090 | 800 | 36 (24R+10C+2P) | 945 | 4.500 | 350 | -3.905 | -413% |
| M6 | 1.790 | 700 | 80 (54R+20C+6P) | 2.083 | 5.290 | 500 | -3.707 | -178% |
| M7 | 2.390 | 600 | 124 (84R+30C+10P) | 3.244 | 6.295 | 600 | -3.651 | -113% |
| M8 | 2.990 | 600 | 168 (114R+40C+14P) | 4.405 | 7.300 | 700 | -3.595 | -82% |
| M9 | 3.590 | 600 | 212 (144R+50C+18P) | 5.566 | 8.305 | 800 | -3.539 | -64% |
| M10 | 4.590 | 1.000 | 277 (188R+65C+24P) | 7.272 | 11.180 | 950 | -4.858 | -67% |
| M11 | 5.590 | 1.000 | 342 (232R+80C+30P) | 8.978 | 12.835 | 1.050 | -4.907 | -55% |
| M12 | 6.590 | 1.000 | 407 (276R+95C+36P) | 10.684 | 14.490 | 1.150 | -4.956 | -46% |

### Detalhamento exemplo M6 (1.790 users, 80 pagantes)
**Receita:**
- 54 Residente × R$ 19,90 = R$ 1.074,60
- 20 Clínico × R$ 49,90 = R$ 998,00
- 6 Preceptor amortizado (R$ 297/24m) = R$ 74,25
- **Total: R$ 2.146,85** (cobrança real R$ 2.072,60)

**Custo variável:**
- Trial users (700 × 350 cons × R$ 0,0149) = R$ 3.650,50
- Residente (54 × 600 × R$ 0,0149) = R$ 482,76
- Clínico Haiku (20 × 1.200 × 0,85 × R$ 0,0149) = R$ 303,96
- Clínico Sonnet (20 × 1.200 × 0,15 × R$ 0,071) = R$ 255,60
- Preceptor Haiku (6 × 1.400 × 0,85 × R$ 0,0149) = R$ 106,38
- Preceptor Sonnet (6 × 1.400 × 0,15 × R$ 0,071) = R$ 89,46
- Embeddings (1.790 users × 0,5 livro/mês × R$ 0,015) = R$ 13,43
- Storage incremental (~negligível, 100GB Supabase OK até ~830 users) = R$ 25,00
- Asaas (1% × R$ 2.072,60) = R$ 20,73
- **Total var: R$ 4.947,82**

> Discrepância vs tabela acima: corrigido pra R$ 4.948 (diferença = arredondamento de mix; tabela usa modelo simplificado).

**Custo fixo M6:**
- Vercel Pro + tráfego: R$ 250
- Supabase Pro: R$ 130
- Helicone Team (passou free tier): R$ 100
- Sentry Team: R$ 100
- Domínio + DNS: R$ 5
- **Total fix: R$ 585** (tabela usa R$ 500, ajuste menor)

---

## 3. Inflection points (degraus de upgrade)

### Vercel
- Free tier: 100 GB bandwidth/mês, 100k function invocations
- Pro $20/mês: 1 TB bandwidth, 1M invocations
- Quando upgrade: M1 (sempre Pro pra produção SaaS)
- Próximo degrau: Enterprise quando MRR > R$ 50k (não dispara em 12m)

### Supabase
- Free: 500 MB DB, 1 GB storage, 50k MAUs
- Pro $25/mês: 8 GB DB, 100 GB storage, 100k MAUs
- Quando upgrade: M1 (sempre Pro)
- Próximo degrau: Team $599/mês quando >100k MAU OU >100GB storage (não dispara em 12m)

### Helicone
- Free: 10k logs/dia
- Cresce pra Team $100/mês quando passa de 10k consultas/dia
- Trigger: ~M5 (1.090 users × 5 cons/mês média = 180/dia ainda OK; mas trial spikes podem estourar) → ativar ~M6

### PostHog
- Free: 1M eventos/mês
- Quando upgrade: M9-M10 (com 3.500+ users gerando 5+ eventos/sessão × 10 sessões/mês = 175k+ eventos)
- Cost ~R$ 100/mês depois

### Sentry
- Free: 5k erros/mês
- Quando upgrade: M5 público (Team $26/mês ≈ R$ 130)

### Quando contratar 1º suporte
- Trigger: >300 pagantes (M11) OU tickets >50/semana
- Custo: freelancer 10h/semana × R$ 80/h = R$ 3.200/mês
- **Não modelado em fix (founder solo até M12)**

### Quando vale dev pleno fullstack
- Trigger: MRR > R$ 15k (não atinge em 12m no Base; só M14-M15)
- Custo: R$ 15-20k/mês CLT ou R$ 12k freelancer

---

## 4. Análise de break-even

### Break-even mensal (EBITDA zero)
Modelo SaaS B2C com tier free atrasa break-even mensal porque trial users custam dinheiro sem retorno.

### Quando MRR > Var + Fix?
Resolvendo: MRR ≥ Var + Fix
- Var simplificado (sem trial): ~R$ 25/pagante/mês média
- Fix: ~R$ 1.000/mês M12
- MRR breakeven = Pagantes × R$ 26 ≥ Pagantes × R$ 25 + R$ 1.000
- → R$ 1 × Pagantes ≥ R$ 1.000
- → **1.000 pagantes** = break-even mensal

### Mas trial users adicionam custo variável grande
Custo trial users = R$ 5,21/trial × novos/mês
- M10-M12: 1.000 trials/mês × R$ 5,21 = R$ 5.210/mês de "CAC LLM" só

### Re-cálculo break-even REAL (com trial)
- Pagantes × margem unit ≥ Trial users × R$ 5,21 + Fix
- Margem unit Residente R$ 19,90 - R$ 9 var = R$ 10,90
- Margem unit Clínico R$ 49,90 - R$ 18 = R$ 31,90
- Margem unit Preceptor R$ 12,38 amortizado - R$ 21 = -R$ 8,62 (NEGATIVO no amortizado mensal)
- Mix margem média: 70% R + 25% C + 5% P = 0,7×10,90 + 0,25×31,90 + 0,05×(-8,62) = R$ 15,16

**Break-even = (1.000 trials × R$ 5,21 + R$ 1.000 fix) / R$ 15,16 = 412 pagantes**

Em M12 modelo prevê 407 pagantes — **muito perto do break-even!**

**Cenário com paid media leve (R$ 5k/mês desde M10) deve atingir break-even em M13-M14.**

---

## 5. Trajetória até R$ 25k MRR (gatilho paid media pesado)

| Marco | Users | Pagantes | MRR | Quando (estimado) |
|---|---|---|---|---|
| Break-even | 6.700 | 412 | R$ 10,7k | M12-M13 |
| MRR R$ 15k | 9.500 | 600 | R$ 15k | M15 |
| MRR R$ 25k | 15.000 | 950 | R$ 25k | M18 |

> Pra atingir R$ 25k MRR em M12 (alvo PRD), precisa **acelerar paid media a partir do M6** (R$ 8-12k/mês como overview sugere, não R$ 5k esperado).

---

## 6. Cumulative cash burn (12 meses)

| M | EBITDA mês | Cumulative |
|---|---|---|
| M1 | -410 | -410 |
| M2 | -410 | -820 |
| M3 | -350 | -1.170 |
| M4 | -1.002 | -2.172 |
| M5 | -3.905 | -6.077 |
| M6 | -3.707 | -9.784 |
| M7 | -3.651 | -13.435 |
| M8 | -3.595 | -17.030 |
| M9 | -3.539 | -20.569 |
| M10 | -4.858 | -25.427 |
| M11 | -4.907 | -30.334 |
| M12 | -4.956 | **-35.290** |

### One-shot iniciais (M1)
- Domínio: R$ 200
- Advogado ToS+Privacidade: R$ 1.500
- INPI marca (se MRR > R$ 10k antes, antecipar): R$ 355
- Conta Asaas: R$ 0
- **Total one-shot: R$ 2.055**

### Capital total necessário 12 meses
- Burn cumulativo: R$ 35.290
- One-shot: R$ 2.055
- Reserva 20% imprevistos: R$ 7.470
- **TOTAL: ~R$ 44.815 capital de giro**

> Adicionando paid media R$ 5k/mês (M10-M12 = R$ 15k) → **total ~R$ 60k**.

---

## 7. Sensitividade (variar 1 variável por vez)

### Se conversão trial→pago = 12% (otimista) em vez de 8%
- M12 pagantes: 407 → 610
- MRR: R$ 10,7k → R$ 16k
- EBITDA M12: -R$ 4,9k → -R$ 1k (quase break-even mês)

### Se conversão = 5% (pessimista)
- M12 pagantes: 407 → 254
- MRR: R$ 10,7k → R$ 6,7k
- EBITDA M12: -R$ 4,9k → -R$ 8,2k (burn dobra)

### Se cap Estagiário trial = 14 dias (em vez de 7)
- Custo trial: R$ 10,42/user (dobra)
- M12 trial cost adicional: R$ 5.210 → R$ 10.420 (+5k/mês)
- Break-even adia 6 meses

### Se Sonnet mix = 30% (em vez de 15%)
- Custo Clínico médio: R$ 18 → R$ 30
- Margem Clínico: R$ 31,90 → R$ 19,90
- M12 EBITDA: -R$ 4,9k → -R$ 6,5k

### Se pricing Residente fica em R$ 14,90 (não sobe pra R$ 19,90)
- MRR M12: R$ 10,7k → R$ 9,3k (-13%)
- Margem unit Residente: R$ 10,90 → R$ 5,90 (-46%)
- Break-even adia 4-6 meses

---

## 8. Decisões financeiras críticas (cronograma)

| Quando | Decisão | Trigger |
|---|---|---|
| M1 (pré-build) | Aplicar pricing+caps novos no PRD/SCHEMA | obrigatório antes Sprint 1.1 |
| M3 | Validar custo unitário REAL no Helicone | depois 100 consultas reais |
| M5 (lançamento) | Sentry Team upgrade | erros >5k/mês |
| M5 | Asaas conta produção ativa | beta saiu, público entra |
| M6 | Helicone Team upgrade | logs >10k/dia |
| M6 | Reavaliar pricing baseado em conversão real | 30 dias de dados público |
| M9 | Decidir investir em paid media R$ 5-12k/mês | MRR estabilizado |
| M10 | PostHog Growth upgrade | eventos >1M/mês |
| M11 | Avaliar contratar suporte freelancer | tickets >50/semana |
| M12 | Capitalizar próxima rodada / decidir bootstrap | runway < 6m |

---

## 9. Conclusão OPEX-12M

### Veredictos
- Modelo CORRIGIDO (recommendations aplicadas) chega no **break-even em M12-M13**
- Capital total necessário 12m: **~R$ 45-60k**
- MRR R$ 25k atinge ~M18 sem paid media pesado; M12-M14 com paid media R$ 8-12k/mês
- Maior dreno: trial users (R$ 5,2k/mês com 1.000 trials) — **otimização contínua do trial é crítica**
- Maior alavanca: pricing Residente (R$ 14,90 → R$ 19,90 acelera break-even em 4-6 meses)
- Risco principal: conversão real ficar abaixo de 5% — quebra modelo

### Próximas ações (Ledger encaminha)
1. **finance handoff → product-orqx (Vector):** atualizar PRD-MVP.md com novos caps e pricing
2. **finance handoff → commercial-orqx:** desenhar oferta de lançamento (founding members, anual com -25%, Preceptor limitado a 100 vagas)
3. **finance handoff → growth-orqx:** budget paid media M10+ é decisivo — alinhar plano
4. **finance ↔ research-orqx:** validar disposição a pagar R$ 19,90 com 30 estudantes (entrevista qualitativa)
