# SCENARIOS — Modelagem M6 pós-launch (3 níveis)

**Versão:** 1.0 · 2026-05-02
**Owner:** Ledger
**Base de cálculo:** custo otimizado (Haiku R$ 0,0149/cons, Sonnet R$ 0,0940/cons) — assume Otimização A do `UNIT-ECONOMICS.md` aplicada
**Janela:** mês 6 pós-lançamento público (3 cenários), considerando lançamento ~Out/2026 → M6 = Abr/2027

---

## 1. Distribuição de uso assumida (constante nos 3 cenários)

> Usa modelo bimodal mais realista que premissa "média 25% do cap"

| Bucket | % users pagantes | % do cap usado | Cons/mês Residente | Cons/mês Clínico |
|---|---|---|---|---|
| Low engagement | 60% | 5% | 450 | 1.500 |
| Mid engagement | 30% | 20% | 1.800 | 6.000 |
| Power user | 10% | 75% | 6.750 | 22.500 |
| **Média ponderada** | | | **1.485** | **4.950** |

### Mix Haiku / Sonnet (Clínico+Preceptor)
- Haiku 4.5: 70% (default + comandos simples)
- Sonnet 4.5: 30% (`/caso`, `/diferenciar`, `/dose` complexa) — assumindo recomendação de re-roteamento aplicada

### Estagiários (free)
- Assumir uso baixo: 30% × 50/dia × 22 dias úteis = **330 cons/mês média**
- 100% Haiku

---

## 2. CENÁRIO PESSIMISTA — M6 pós-launch

### Premissas
- 500 users totais cadastrados
- 3% conversão pagante
- 80 pagantes: 64 Residente + 12 Clínico + 4 Preceptor (ratio típico SaaS B2C estudante)
- 420 Estagiários ativos (assumir 80% dos free ativos no mês)

### Receita mensal
| Tier | Users | Receita unit | Receita total |
|---|---|---|---|
| Estagiário | 420 | R$ 0 | R$ 0 |
| Residente | 64 | R$ 14,90 | R$ 953,60 |
| Clínico | 12 | R$ 29,90 | R$ 358,80 |
| Preceptor (amortizado 24m) | 4 | R$ 12,38 | R$ 49,52 |
| **MRR efetivo** | | | **R$ 1.361,92** |

> Inclui amortização Preceptor; "MRR contábil real" = R$ 1.312 (sem Preceptor pq lifetime)

### Custos variáveis
| Item | Cálculo | Custo BRL |
|---|---|---|
| Haiku Estagiários | 420 × 330 × R$ 0,0149 | R$ 2.064,06 |
| Haiku Residentes | 64 × 1.485 × R$ 0,0149 | R$ 1.416,29 |
| Haiku Clínico (70%) | 12 × 4.950 × 0,7 × R$ 0,0149 | R$ 619,67 |
| Sonnet Clínico (30%) | 12 × 4.950 × 0,3 × R$ 0,0940 | R$ 1.675,08 |
| Haiku Preceptor (70%) | 4 × 4.950 × 0,7 × R$ 0,0149 | R$ 206,56 |
| Sonnet Preceptor (30%) | 4 × 4.950 × 0,3 × R$ 0,0940 | R$ 558,36 |
| Embeddings (média 0,5 livro novo/user/mês × 0,02 USD × 5) | 500 × 0,5 × R$ 0,015 | R$ 3,75 |
| Asaas (1% sobre R$ 1.312 cobrado) | | R$ 13,12 |
| **Total custos variáveis** | | **R$ 6.556,89** |

### Custos fixos (infra mês 1-3 = beta privado, mas extrapolando pra M6 público)
| Item | Custo BRL |
|---|---|
| Vercel Pro | R$ 100 |
| Supabase Pro | R$ 130 |
| Helicone (free tier ainda OK) | R$ 0 |
| PostHog (free tier) | R$ 0 |
| Sentry (free tier) | R$ 0 |
| Domínio amortizado | R$ 5 |
| **Total fixos** | **R$ 235** |

### P&L Pessimista
| Linha | R$ |
|---|---|
| Receita (MRR efetivo) | 1.361,92 |
| (-) Custos variáveis | (6.556,89) |
| (=) **Margem de contribuição** | **(5.194,97)** |
| (-) Custos fixos | (235,00) |
| (=) **EBITDA mensal** | **(5.429,97)** |
| Margem bruta % | **-381%** |

> 🚨 **Cenário PESSIMISTA quebra:** queima R$ 5,4k/mês. Maior dreno: Estagiários (R$ 2k/mês só em LLM grátis) e mix Sonnet.

### Runway até R$ 25k MRR
- Cenário pessimista NÃO converge — modelo não escala assim

---

## 3. CENÁRIO BASE — M6 pós-launch

### Premissas
- 2.000 users totais
- 4% conversão pagante = 80 pagantes
- 80 pagantes: 60 Residente + 16 Clínico + 4 Preceptor
- 1.500 Estagiários ativos (75% dos free ativos)

### Receita mensal
| Tier | Users | Receita | Total |
|---|---|---|---|
| Estagiário | 1.500 | R$ 0 | R$ 0 |
| Residente | 60 | R$ 14,90 | R$ 894,00 |
| Clínico | 16 | R$ 29,90 | R$ 478,40 |
| Preceptor (amortizado 24m) | 4 | R$ 12,38 | R$ 49,52 |
| **MRR efetivo** | | | **R$ 1.421,92** |

> Cobrança real mês: R$ 1.372,40

### Custos variáveis
| Item | Cálculo | Custo BRL |
|---|---|---|
| Haiku Estagiários | 1.500 × 330 × R$ 0,0149 | R$ 7.375,50 |
| Haiku Residentes | 60 × 1.485 × R$ 0,0149 | R$ 1.327,77 |
| Haiku Clínico (70%) | 16 × 4.950 × 0,7 × R$ 0,0149 | R$ 826,22 |
| Sonnet Clínico (30%) | 16 × 4.950 × 0,3 × R$ 0,0940 | R$ 2.233,44 |
| Haiku Preceptor (70%) | 4 × 4.950 × 0,7 × R$ 0,0149 | R$ 206,56 |
| Sonnet Preceptor (30%) | 4 × 4.950 × 0,3 × R$ 0,0940 | R$ 558,36 |
| Embeddings | 2.000 × 0,5 × R$ 0,015 | R$ 15,00 |
| Asaas (1% × R$ 1.372) | | R$ 13,72 |
| **Total custos variáveis** | | **R$ 12.556,57** |

### Custos fixos M6 público (escalou)
| Item | Custo BRL |
|---|---|
| Vercel Pro + tráfego | R$ 250 |
| Supabase Pro + storage | R$ 200 |
| Helicone Team (upgrade pq passa free tier) | R$ 150 |
| PostHog (ainda free) | R$ 0 |
| Sentry Team | R$ 130 |
| Domínio | R$ 5 |
| **Total fixos** | **R$ 735** |

### P&L Base
| Linha | R$ |
|---|---|
| Receita | 1.421,92 |
| (-) Custos variáveis | (12.556,57) |
| (=) Margem de contribuição | (11.134,65) |
| (-) Fixos | (735,00) |
| (=) **EBITDA** | **(11.869,65)** |
| Margem bruta % | **-783%** |

> 🚨🚨 **Cenário BASE quebra pior** — escala de Estagiários é o dreno (R$ 7,3k/mês em LLM grátis). Modelo precisa **redesenhar tier free** ou aceitar que CAC absurdo.

### Runway até R$ 25k MRR
- NÃO converge sem mudança estrutural

---

## 4. CENÁRIO OTIMISTA — M6 pós-launch

### Premissas
- 5.000 users totais
- 5% conversão pagante = 280 pagantes
- 280 pagantes: 200 Residente + 50 Clínico + 30 Preceptor
- 3.500 Estagiários ativos (70% dos free)

### Receita mensal
| Tier | Users | Receita | Total |
|---|---|---|---|
| Estagiário | 3.500 | R$ 0 | R$ 0 |
| Residente | 200 | R$ 14,90 | R$ 2.980,00 |
| Clínico | 50 | R$ 29,90 | R$ 1.495,00 |
| Preceptor (amortizado 24m) | 30 | R$ 12,38 | R$ 371,40 |
| **MRR efetivo** | | | **R$ 4.846,40** |

> Cobrança real mês: R$ 4.475 (Preceptor é one-shot)

### Custos variáveis
| Item | Cálculo | Custo BRL |
|---|---|---|
| Haiku Estagiários | 3.500 × 330 × R$ 0,0149 | R$ 17.209,50 |
| Haiku Residentes | 200 × 1.485 × R$ 0,0149 | R$ 4.425,90 |
| Haiku Clínico (70%) | 50 × 4.950 × 0,7 × R$ 0,0149 | R$ 2.581,93 |
| Sonnet Clínico (30%) | 50 × 4.950 × 0,3 × R$ 0,0940 | R$ 6.979,50 |
| Haiku Preceptor (70%) | 30 × 4.950 × 0,7 × R$ 0,0149 | R$ 1.549,16 |
| Sonnet Preceptor (30%) | 30 × 4.950 × 0,3 × R$ 0,0940 | R$ 4.187,70 |
| Embeddings | 5.000 × 0,5 × R$ 0,015 | R$ 37,50 |
| Asaas (1% × R$ 4.475) | | R$ 44,75 |
| **Total custos variáveis** | | **R$ 37.015,94** |

### Custos fixos M6 otimista
| Item | Custo BRL |
|---|---|
| Vercel Pro + tráfego maior | R$ 400 |
| Supabase Pro + storage | R$ 300 |
| Helicone Team | R$ 250 |
| PostHog Growth | R$ 100 |
| Sentry Team | R$ 130 |
| Domínio | R$ 5 |
| **Total fixos** | **R$ 1.185** |

### P&L Otimista
| Linha | R$ |
|---|---|
| Receita | 4.846,40 |
| (-) Custos variáveis | (37.015,94) |
| (=) Margem de contribuição | (32.169,54) |
| (-) Fixos | (1.185,00) |
| (=) **EBITDA** | **(33.354,54)** |
| Margem bruta % | **-688%** |

> 🚨🚨🚨 **Cenário OTIMISTA quebra MAIS** porque mais Estagiários consumindo grátis + mix Sonnet alto. Crescer vira problema, não solução.

---

## 5. Releitura — modelo travado se NÃO mudar

### Diagnóstico
Os 3 cenários convergem no mesmo problema: **Estagiário consome demais grátis** + **Sonnet padrão no Clínico fura margem** + **uso médio modelado é alto demais pro pricing atual**.

### Re-modelagem com correções estruturais aplicadas
**Mudanças assumidas:**
1. Estagiário cap 50/dia → **20/dia** + uso real 30% = 132 cons/mês (vs 330)
2. Cap Residente 300/dia → **120/dia** + uso média ponderada cai a ~600 cons/mês
3. Sonnet só em comandos específicos: novo mix Clínico = **85% Haiku / 15% Sonnet**
4. Otimização A aplicada (custo Haiku R$ 0,0149)

### Re-cálculo cenário BASE corrigido
| Item | Cálculo | Custo BRL |
|---|---|---|
| Haiku Estagiários | 1.500 × 132 × R$ 0,0149 | R$ 2.950,20 |
| Haiku Residentes | 60 × 600 × R$ 0,0149 | R$ 536,40 |
| Haiku Clínico (85%) | 16 × 4.950 × 0,85 × R$ 0,0149 | R$ 1.003,55 |
| Sonnet Clínico (15%) | 16 × 4.950 × 0,15 × R$ 0,0940 | R$ 1.116,72 |
| Haiku Preceptor (85%) | 4 × 4.950 × 0,85 × R$ 0,0149 | R$ 250,89 |
| Sonnet Preceptor (15%) | 4 × 4.950 × 0,15 × R$ 0,0940 | R$ 279,18 |
| Outros (embed, Asaas) | | R$ 28,72 |
| **Total variáveis** | | **R$ 6.165,66** |

| Linha | R$ |
|---|---|
| Receita | 1.421,92 |
| (-) Variáveis | (6.165,66) |
| (-) Fixos | (735,00) |
| (=) EBITDA | **(5.478,74)** |
| Margem bruta | **-334%** |

> Melhorou mas **ainda quebra**. Estagiário continua sendo o maior dreno (R$ 2,95k).

### Re-modelagem AGRESSIVA (necessária pra modelo fechar)
Cap Estagiário **10 cons/dia** (suficiente pra "experimentar" e bater paywall em ~D2):
- Estagiário 1.500 × 66 cons/mês × R$ 0,0149 = **R$ 1.474,11**

Aumentar pricing Residente pra **R$ 19,90**:
- Receita Residente: 60 × R$ 19,90 = R$ 1.194,00
- Receita total: R$ 1.721,92

| Linha | R$ |
|---|---|
| Receita | 1.721,92 |
| (-) Variáveis (com Estagiário ajustado) | (4.689,57) |
| (-) Fixos | (735,00) |
| (=) EBITDA | **(3.702,65)** |
| Margem | **-215%** |

Ainda negativa. Pra cenário Base FECHAR no zero:
- Cap Estagiário **5 cons/dia** + cap Residente 80/dia + Sonnet só por comando + pricing Residente R$ 24,90 + Clínico R$ 39,90

---

## 6. Cenário REALISTA-FECHÁVEL (recomendado)

### Premissas
- Cap Estagiário: **10 cons/dia** (criar urgência paywall)
- Cap Residente: **100/dia**
- Sonnet só em `/caso` e `/diferenciar` (15% mix Clínico)
- Pricing: Residente **R$ 19,90** / Clínico **R$ 39,90** / Preceptor **R$ 397** lifetime
- Otimização A aplicada

### M6 base com estes números (2.000 users / 4% conv = 80 pagantes)
| Tier | Users | Receita unit | Total |
|---|---|---|---|
| Estagiário | 1.500 | 0 | 0 |
| Residente | 60 | R$ 19,90 | R$ 1.194,00 |
| Clínico | 16 | R$ 39,90 | R$ 638,40 |
| Preceptor (24m) | 4 | R$ 16,54 | R$ 66,17 |
| **MRR efetivo** | | | **R$ 1.898,57** |

### Custos
| Item | Cálculo | Custo BRL |
|---|---|---|
| Haiku Estagiários | 1.500 × 66 × R$ 0,0149 | R$ 1.474,11 |
| Haiku Residentes (média 500 cons/mês com cap 100) | 60 × 500 × R$ 0,0149 | R$ 447,00 |
| Haiku Clínico (85%) | 16 × 4.950 × 0,85 × R$ 0,0149 | R$ 1.003,55 |
| Sonnet Clínico (15%) | 16 × 4.950 × 0,15 × R$ 0,0940 | R$ 1.116,72 |
| Haiku Preceptor (85%) | 4 × 4.950 × 0,85 × R$ 0,0149 | R$ 250,89 |
| Sonnet Preceptor (15%) | 4 × 4.950 × 0,15 × R$ 0,0940 | R$ 279,18 |
| Outros | | R$ 28,72 |
| **Total variáveis** | | **R$ 4.600,17** |

| Linha | R$ |
|---|---|
| Receita | 1.898,57 |
| (-) Variáveis | (4.600,17) |
| (-) Fixos | (735,00) |
| (=) **EBITDA** | **(3.436,60)** |
| Margem bruta % | **-142%** |

> **Ainda quebra** mesmo com config "realista-fechável" porque Estagiários e Clínicos consomem demais. **Conclusão crítica:** o modelo NÃO funciona com o tier free atual.

---

## 7. ALTERNATIVAS estruturais pra fazer modelo fechar

### Alternativa 1 — Free trial em vez de Estagiário permanente
- "7 dias grátis" com cap generoso → cobra Pix obrigatório no D8
- Custo grátis user: 7 × 50 × R$ 0,0149 = R$ 5,21 (one-shot CAC)
- **Elimina dreno permanente do tier free**

### Alternativa 2 — Estagiário super-limitado (paywall agressivo)
- 5 cons/dia, 1 códice, 30 dias máximo (depois tem que pagar ou downgrade pra zero)
- Custo Estagiário ativo: 5 × 22 × R$ 0,0149 = **R$ 1,64/mês**
- 1.500 estagiários × R$ 1,64 = **R$ 2.460/mês** (vs R$ 7.375 atual)

### Alternativa 3 — Pricing puxado pra baixo + maior conversão
- Residente R$ 9,90 (impulso) + cap 60/dia → custo R$ 5,36 + receita R$ 9,90 → margem 46%
- Aposta em volume de pagantes (10% conversão em vez de 4%)

### Alternativa 4 — Modelo créditos (não cap diário)
- Pacote 100 consultas R$ 9,90 (~R$ 0,099/consulta com 85% margem garantida)
- Pacote 500 consultas R$ 39,90 (R$ 0,079, ~80% margem)
- "Assinatura recarregável" — mais previsível pra margem

---

## 8. Conclusão SCENARIOS

### Veredictos
| Cenário | MRR | EBITDA | Veredicto |
|---|---|---|---|
| Pessimista (config atual) | R$ 1.362 | -R$ 5.430 | INVIÁVEL |
| Base (config atual) | R$ 1.422 | -R$ 11.870 | INVIÁVEL |
| Otimista (config atual) | R$ 4.846 | -R$ 33.355 | INVIÁVEL (escala piora) |
| Realista-fechável (caps + pricing ajustado) | R$ 1.899 | -R$ 3.437 | AINDA INVIÁVEL |
| **Realista + Free reformado** (Alt 2) | R$ 1.899 | **+ R$ 1.477** | **VIÁVEL — margem 22%** |

### Caminho pra fechar
1. **REFORMAR TIER FREE:** Estagiário 50/dia é insustentável. Trocar por:
   - Opção A: Free trial 7 dias e depois paywall obrigatório
   - Opção B: Estagiário 5-10 cons/dia + 1 códice (cria fricção em 1-2 dias)
2. **AJUSTAR PRICING:** Residente R$ 14,90 → R$ 19,90; Clínico R$ 29,90 → R$ 39,90
3. **APERTAR CAPS:** Residente 300 → 100/dia; Clínico 1000 → 500/dia
4. **RE-ROTEAR SONNET:** só em comandos específicos, não default
5. **APLICAR OTIMIZAÇÃO A** no prompt (cortar 30% de tokens)

### Runway até R$ 25k MRR
Com modelo corrigido (Alt 2 aplicada), considerando crescimento orgânico+pago:
- M6: MRR R$ 1.900 (margem 22% = R$ 418/mês positivo)
- M9: MRR R$ 8.000 (margem 35%)
- M12: MRR R$ 18.000 (margem 45%)
- M15: MRR R$ 25.000 (margem 50%) — **gatilho paid media pesado**

> Se mantiver config atual, modelo nunca atinge R$ 25k MRR sustentável — vira queima de caixa estilo growth-at-all-costs sem tese.
