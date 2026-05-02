# UNIT ECONOMICS — Codex SaaS

**Versão:** 1.0 · 2026-05-02
**Owner:** Ledger (squad-finance)
**Câmbio assumido:** USD 1 = BRL 5,00 (variação cambial é risco a notar, não a modelar)
**Fonte de pricing:** Anthropic platform.claude.com/docs/en/about-claude/pricing (consulta 2026-05-02) + OpenAI developers.openai.com/api/docs/pricing
**Princípio Ledger:** "Margem sobre receita — crescer receita sem margem é destruir valor."

---

## 1. Pricing real das APIs (2026-05-02)

| Modelo | Input padrão | Input cached (read) | Output | Notas |
|---|---|---|---|---|
| Anthropic Haiku 4.5 | **$1.00 / 1M** | **$0.10 / 1M** (90% off) | **$5.00 / 1M** | Cache write = 1.25x input ($1.25/1M) |
| Anthropic Sonnet 4.5 / 4.6 | **$3.00 / 1M** | **$0.30 / 1M** (90% off) | **$15.00 / 1M** | mesma família, mesma tabela |
| OpenAI text-embedding-3-small | **$0.02 / 1M** | n/a | n/a | só input; batch API = $0.01/1M |

> **ALERTA IMEDIATO:** Vector usou pricing antigo do Haiku ($0.80 in / $4 out). O preço REAL é $1.00 in / $5.00 out — 25% mais caro do que premissa. Refletir nos cálculos abaixo.

---

## 2. Premissa de uso médio por consulta

### Composição de tokens (consulta típica via RAG)
| Componente | Tokens | Cacheável? | Notas |
|---|---|---|---|
| System prompt (Hipócrates + compliance + glossário) | 2.000 | SIM | estável por sessão, cache hit ~95% |
| RAG chunks recuperados (4 × 800 tok) | 3.200 | PARCIAL | mesmos chunks numa sessão sobre mesmo tópico |
| Slash-command template (`/quizar`, `/caso`...) | 250 | SIM | template fixo |
| User query | 50-150 | NÃO | dinâmica |
| Histórico (últimas 2 trocas, opcional) | ~500 | NÃO | dinâmico |
| **TOTAL INPUT médio** | **~5.250** | | |
| **OUTPUT Haiku** | **~600** | | resumo, explicação, quiz curto |
| **OUTPUT Sonnet** | **~800** | | mais elaborado (caso, diferencial) |

### Cache hit ratio realista
- **System prompt + slash template (2.250 tok):** cache hit 95% após 1ª requisição da sessão
- **RAG chunks (3.200 tok):** cache hit estimado **40%** (a sessão repete tópicos, mas recupera novos chunks também)
- **User query + histórico (~600 tok):** **0% cache** (sempre novo)

**Cálculo ponderado de tokens cached vs não-cached por consulta típica:**
- Cached: 2.250 × 0,95 + 3.200 × 0,40 = 2.137 + 1.280 = **~3.420 tok cached**
- Não-cached: 5.250 - 3.420 = **~1.830 tok não-cached**

> Premissa Vector assumia 80% cache hit total. Realista é **~65%** quando se considera que RAG chunks variam.

---

## 3. Cálculo Haiku 4.5 por consulta (premissa central)

### Por consulta típica (5.250 in / 600 out, cache 65%)
| Componente | Tokens | Preço/1M (USD) | Custo USD |
|---|---|---|---|
| Input cached | 3.420 | $0.10 | $0,000342 |
| Input não-cached | 1.830 | $1.00 | $0,001830 |
| Cache write (1ª vez no dia, amortizado) | ~750 | $1.25 | $0,000094 |
| Output | 600 | $5.00 | $0,003000 |
| **TOTAL** | | | **$0,005266** |

**Em BRL (×5,0): R$ 0,0263 por consulta Haiku**

### Veredicto premissa Vector
- Premissa: **R$ 0,012/consulta Haiku**
- Real: **R$ 0,0263/consulta Haiku**
- **STATUS: SUBESTIMADA em ~120%** (real é mais que o dobro)

### Cenários alternativos
| Cenário | Cache hit | Custo USD | Custo BRL |
|---|---|---|---|
| Otimista (cache 80% como Vector assumiu) | 80% | $0,00450 | R$ 0,0225 |
| Realista (cache 65%) | 65% | $0,00527 | R$ 0,0263 |
| Pessimista (chunks novos sempre, cache 30%) | 30% | $0,00686 | R$ 0,0343 |
| Sem cache | 0% | $0,00825 | R$ 0,0413 |

> **Conclusão:** mesmo no melhor cenário (cache 80%), Haiku custa R$ 0,022 — quase 2x o que Vector previu.

---

## 4. Cálculo Sonnet 4.5 por consulta

### Por consulta típica (5.250 in / 800 out, cache 65%)
| Componente | Tokens | Preço/1M (USD) | Custo USD |
|---|---|---|---|
| Input cached | 3.420 | $0.30 | $0,001026 |
| Input não-cached | 1.830 | $3.00 | $0,005490 |
| Cache write (amortizado) | ~750 | $3.75 | $0,000281 |
| Output | 800 | $15.00 | $0,012000 |
| **TOTAL** | | | **$0,018797** |

**Em BRL (×5,0): R$ 0,0940 por consulta Sonnet**

### Veredicto premissa Vector
- Premissa: **R$ 0,06/consulta Sonnet**
- Real: **R$ 0,094/consulta Sonnet**
- **STATUS: SUBESTIMADA em ~57%**

---

## 5. Cálculo embedding por códice

### Códice típico 300pp (~150k tokens)
- 150.000 tok × $0.02/1M = $0,003 = **R$ 0,015**
- **Premissa Vector: R$ 0,08 — VÁLIDA com folga (5x abaixo)**

### Códice grande Robbins 1500pp (~750k tokens)
- 750.000 × $0.02/1M = $0,015 = **R$ 0,075**
- Cabe na premissa de R$ 0,08 mesmo no extremo

### Códice gigante (limite MVP 80MB ≈ 2.500pp ≈ 1,25M tokens)
- 1.250.000 × $0.02/1M = $0,025 = **R$ 0,125**
- Estoura premissa em ~56%, mas só pra livros do limite

### Veredicto
- **STATUS: VÁLIDA pra códice médio (300pp).** Robbins (1500pp) ainda cabe.
- Códice no cap (80MB) estoura ligeiramente — adicionar microcopy "códices acima de 1500pp podem custar mais"

---

## 6. Custo de armazenamento por user

### Storage Supabase
- PDF médio 300pp ≈ 8 MB; 15 códices (cap Residente) ≈ 120 MB por user
- Power user (Clínico, ilimitado): assumir 30 códices média ≈ 240 MB
- **Supabase Pro:** 100 GB storage incluído + $0.021/GB extra
- **100 GB / 0,12 GB por user Residente = ~830 users sem custo extra**

### pgvector (embeddings indexados)
- 1 chunk = ~6 KB (texto + 1536 floats × 4 bytes = ~6.144 bytes)
- 1.500pp ÷ 800 tok/chunk × 500 tok/pp = ~940 chunks por livro
- 15 códices × 940 chunks × 6 KB = ~85 MB de pgvector por Residente
- Cabe folgado nos 8 GB DB do Supabase Pro até ~95 users

### Custo médio storage por user (amortizado quando >830 users)
- Residente: ~120 MB → ~$0.0025/mês = **R$ 0,013/user/mês** (negligível)
- Clínico: ~240 MB → R$ 0,025/user/mês

---

## 7. Tabela final — custo total por tier (uso TÍPICO, não max)

### Uso típico assumido por tier
| Tier | % do cap usado | Consultas/mês | Códices ativos | Mix Haiku/Sonnet |
|---|---|---|---|---|
| Estagiário | 30% × 50/dia × 22 dias úteis | 330 | 1,5 | 100% Haiku |
| Residente | 25% × 300/dia × 30 dias | 2.250 | 8 | 100% Haiku |
| Clínico | 20% × 1000/dia × 30 dias | 6.000 | 18 | 60% Haiku / 40% Sonnet |
| Preceptor | 15% × 1500/dia × 30 dias | 6.750 | 22 | 60% Haiku / 40% Sonnet |

> Fonte da % de uso: SaaS B2C heavy-user típico usa 15-30% do cap em média (90/9/1 rule); power users 70-90%. Modelagem detalhada está em `SCENARIOS.md`.

### Custo mensal por user (uso típico)

#### Estagiário (free, 100% Haiku)
- Consultas: 330 × R$ 0,0263 = R$ 8,68
- Embeddings: 1,5 códices novos × R$ 0,015 (ou R$ 0,025 power) ≈ R$ 0,04
- Storage: ~R$ 0,003
- **Total: R$ 8,72/user/mês**
- Receita: R$ 0
- **MARGEM: -R$ 8,72/user (LOSS LEADER esperado)**

#### Residente (R$ 14,90/mês, 100% Haiku)
- Consultas: 2.250 × R$ 0,0263 = R$ 59,18
- Embeddings: 8 × R$ 0,015 = R$ 0,12 (uploads novos não acontecem todo mês; assumir 2 novos = R$ 0,03)
- Storage: ~R$ 0,013
- Asaas Pix (1%): R$ 0,15
- **Total custo variável: R$ 59,38/mês**
- Receita: R$ 14,90
- **MARGEM BRUTA: -R$ 44,48/user (NEGATIVA -298%)**

> 🚨 **ALERTA VERMELHO:** com uso típico assumido (25% do cap = 75 cons/dia média), Residente PERDE DINHEIRO em cada user.

#### Clínico (R$ 29,90/mês, 60% Haiku / 40% Sonnet)
- Consultas Haiku: 3.600 × R$ 0,0263 = R$ 94,68
- Consultas Sonnet: 2.400 × R$ 0,0940 = R$ 225,60
- Embeddings: 18 × R$ 0,015 média ≈ R$ 0,27 (3 novos = R$ 0,05)
- Storage: ~R$ 0,025
- Asaas Pix (1%): R$ 0,30
- **Total custo variável: R$ 320,68/mês**
- Receita: R$ 29,90
- **MARGEM BRUTA: -R$ 290,78/user (NEGATIVA -972%)**

> 🚨🚨 **ALERTA VERMELHÍSSIMO:** Clínico no uso típico modelado quebra 10x.

#### Preceptor (R$ 297 lifetime, 60/40 mix)
- Custo mensal igual Clínico: ~R$ 320,68/mês
- Receita amortizada (24 meses target): R$ 297 / 24 = R$ 12,38/mês
- **MARGEM BRUTA: -R$ 308,30/user/mês** — quebra catastroficamente

---

## 8. Recalibragem necessária — onde a matemática trava

### O problema real
A premissa Vector de 25-30% do cap é **agressiva demais** pra modelagem de margem-trava. SaaS de Q&A nichado tem distribuição mais bimodal:
- 60% dos pagantes usam **5-10% do cap** (low-engagement, valor percebido pelo "ter acesso")
- 30% usam **15-30%** (target persona Marina)
- 10% power users usam **60-90%**

### Recalculando com distribuição realista (média ponderada)
**Residente (média ponderada):**
- Low (60%): 5% × 300 × 30 = 450 cons/mês
- Mid (30%): 20% × 300 × 30 = 1.800 cons/mês
- High (10%): 75% × 300 × 30 = 6.750 cons/mês
- **Média ponderada: 0,6×450 + 0,3×1.800 + 0,1×6.750 = 270 + 540 + 675 = 1.485 cons/mês**

| Item | Custo |
|---|---|
| Consultas: 1.485 × R$ 0,0263 | R$ 39,06 |
| Embeddings + storage + Asaas | R$ 0,30 |
| **Total** | **R$ 39,36** |
| Receita | R$ 14,90 |
| **MARGEM** | **-R$ 24,46 (NEGATIVA)** |

> Mesmo com premissa de uso conservadora-realista, R$ 14,90 NÃO PAGA o custo médio do Residente.

### Pra atingir margem 70% no Residente:
- Custo precisaria ser ≤ R$ 4,47/mês (30% de R$ 14,90)
- Significa máximo de **R$ 4,47 / R$ 0,0263 = 170 consultas/mês média**
- Significa cap **efetivamente usado** de ~6 cons/dia

### Caminhos pra fechar a conta
1. **Apertar cap Residente:** de 300/dia para **80-100/dia** (ainda 2x do free de 50)
2. **Aumentar pricing Residente:** R$ 14,90 → **R$ 24,90 ou R$ 29,90** (alinhar com mercado BR de SaaS estudante)
3. **Otimizar prompt:** cortar system prompt 2.000 → 1.200 tok; reduzir RAG de 4 chunks pra 3 chunks de 600 tok
4. **Cache write amortizado melhor:** garantir que sessão dura ≥ 5 consultas (cache fica "quente")
5. **Output mais curto:** Haiku output 600 → 400 tok via prompt template ("máximo 350 palavras")
6. **Evitar Sonnet no Clínico default:** Sonnet só quando user clica explicitamente "/profundo" ou comando complexo (`/caso`, `/diferenciar`)

---

## 9. Otimizações com impacto modelado

### Otimização A: prompt enxuto + output curto + cache forte
| Variável | Atual | Otimizado |
|---|---|---|
| System prompt | 2.000 | 1.200 |
| RAG (chunks×tokens) | 4×800=3.200 | 3×600=1.800 |
| Output médio Haiku | 600 | 400 |
| Cache hit | 65% | 80% (sessões mais longas) |

**Recálculo Haiku otimizado por consulta:**
- Total input: 1.200 + 1.800 + 250 + 100 = 3.350 tok
- Cached: 3.350 × 0,80 = 2.680 → $0,000268
- Não-cached: 670 × $1.00/1M = $0,000670
- Output: 400 × $5.00/1M = $0,002000
- Cache write amortizado: $0,000050
- **Total: $0,002988 = R$ 0,0149/consulta**

> Otimização traz Haiku para R$ 0,015 — perto da premissa Vector (R$ 0,012), realista.

**Recálculo Residente com Haiku otimizado + uso real (1.485 cons/mês):**
- 1.485 × R$ 0,0149 = **R$ 22,12/mês**
- + R$ 0,30 outros = **R$ 22,42**
- Receita R$ 14,90
- **MARGEM: -R$ 7,52 (ainda negativa)**

### Otimização B: cap apertado + pricing ajustado
- Cap Residente 300 → **120/dia** (média ponderada cai pra ~600 cons/mês)
- Pricing R$ 14,90 → **R$ 19,90**

**Custo:** 600 × R$ 0,0149 = R$ 8,94 + R$ 0,30 = **R$ 9,24**
**Receita:** R$ 19,90
**MARGEM: R$ 10,66 = 53% (ainda abaixo do target 70%)**

### Otimização C (combinada — recomendada)
- Otimização A (prompt+cache+output) → custo/consulta R$ 0,0149
- Cap Residente 300 → **150/dia** (median ponderada ~750 cons/mês)
- Pricing **R$ 19,90/mês** (ou manter 14,90 e re-treinar comportamento)

**Custo:** 750 × R$ 0,0149 + R$ 0,30 = **R$ 11,48**
**Receita R$ 19,90 → MARGEM R$ 8,42 = 42% (ainda baixo)**
**Receita R$ 24,90 → MARGEM R$ 13,42 = 54%**
**Receita R$ 29,90 → MARGEM R$ 18,42 = 62%**

> Pra cravar 70% no Residente com uso realista, **só com pricing R$ 39,90+ ou cap ainda mais apertado.**

### Otimização D (radical — manter R$ 14,90 bandeira)
- Otimização A
- Cap Residente **80/dia** (média ponderada ~400 cons/mês)
- Manter pricing R$ 14,90

**Custo:** 400 × R$ 0,0149 + R$ 0,30 = **R$ 6,26**
**Receita R$ 14,90 → MARGEM R$ 8,64 = 58%**

> Ainda não bate 70%, mas chega no clube. Pra 70% com R$ 14,90 e otimização A, cap = **60/dia** (~300 cons/mês = R$ 4,77).

---

## 10. Conclusão executiva (para Ledger encaminhar)

### Veredicto das 4 premissas Vector
| # | Premissa | Status | Real | Ajuste |
|---|---|---|---|---|
| 1 | Embedding livro 300pp ≤ R$ 0,08 | **VÁLIDA** | R$ 0,015 | Manter; alertar pra 1500pp ainda OK (R$ 0,075) |
| 2 | Custo Haiku ≤ R$ 0,012 | **SUBESTIMADA** | R$ 0,0263 (atual) → R$ 0,015 (otimizado) | Pricing API mudou ($1/$5 vs Vector usou $0,80/$4); precisa otimização A pra chegar perto |
| 3 | Custo Sonnet ≤ R$ 0,06 | **SUBESTIMADA** | R$ 0,094 | Limitar Sonnet a comandos específicos, não "default Clínico" |
| 4 | Margem Residente ≥ 70% | **NÃO ATINGÍVEL** com config atual | -298% (uso típico) | Combinar otimização A + cap 80/dia + pricing R$ 19,90 → ~70% |

### Próxima ação obrigatória
1. **Aplicar Otimização A** no system prompt + slash templates (product-orqx)
2. **Apertar cap Residente** de 300 → 100-150/dia (PRD precisa atualizar)
3. **Decidir pricing**: manter R$ 14,90 com cap apertadíssimo, OU subir pra R$ 19,90/24,90 com cap razoável
4. **Re-roteamento Sonnet**: não default no Clínico; só comandos premium (`/caso`, `/diferenciar`, `/dose-detalhada`)

> Detalhe completo de cenários em `SCENARIOS.md`, stress test em `STRESS-TEST.md`, recomendações finais em `RECOMMENDATIONS.md`, projeção 12 meses em `OPEX-12M.md`.
