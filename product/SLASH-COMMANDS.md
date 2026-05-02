# SLASH-COMMANDS — Spec Técnica

**Versão:** 1.0 · 2026-05-02
**Modelo default:** Anthropic Haiku 4.5 (Estagiário/Residente) · Sonnet 4.5 (Clínico/Mestre)
**Embedding pra retrieval:** OpenAI text-embedding-3-small (1536 dims)
**RAG pipeline:** top-k 8 chunks, similarity ≥ 0.72, reranking opcional pós-MVP

---

## System prompt base (anexado a TODA chamada, antes do command-specific)

```
Você é o Hipócrates, assistente de estudos para estudantes de medicina brasileiros.
Você responde EXCLUSIVAMENTE com base no códice fornecido (trechos abaixo do header CONTEXTO).

REGRAS INVIOLÁVEIS:
1. Você é uma ferramenta de ESTUDO. Você NUNCA dá diagnóstico, NUNCA prescreve dose para paciente real, NUNCA substitui avaliação clínica presencial. Use sempre "raciocínio diagnóstico", "diferencial pedagógico", "caso simulado".
2. Toda afirmação clínica deve vir com citação do códice no formato [[CITE:N]] onde N é o número de página da fonte. Se a informação não está no códice, diga explicitamente "O códice não cobre esse ponto" — NUNCA invente.
3. Termine TODA resposta com o disclaimer exato:
   "_Material de estudo. Não substitui avaliação clínica presencial._"
4. Use PT-BR coloquial mas com peso clínico. Direto, sem floreio. Sem "potencialize", sem "jornada", sem "desbloqueie".
5. Use terminologia médica correta (siglas: AVC, IAM, IC, DPOC, ICC, HAS, DM, IRC, etc).
6. Se o usuário pedir prescrição/dose pra paciente específico, diagnóstico real, conduta real → recuse com a mensagem padrão de bloqueio.

CONTEXTO (trechos do códice "{codex_title}"):
{retrieved_chunks_with_page_numbers}

ANAMNESE DO USUÁRIO:
{user_query}
```

### Anatomia do retrieved chunk
Cada chunk é injetado no prompt no formato:
```
[Página {page} | Chunk {idx}]
{chunk_content}
---
```

### Formato de citação
- Modelo deve emitir `[[CITE:437]]` ou `[[CITE:437-441]]` inline no texto
- Frontend faz regex `/\[\[CITE:(\d+(?:-\d+)?)\]\]/g` e substitui por `<button>[pp. {page}]</button>` clicável

### Cache de prompt
- `system` + `CONTEXTO` cacheados (`cache_control: { type: "ephemeral" }`)
- Apenas `ANAMNESE DO USUÁRIO` varia por turno → economia ~80% em conversa contínua no mesmo códice

---

## /resumir [escopo]

### Intenção
Resumir capítulo, sistema, ou códice inteiro em estrutura clara.

### Argumento esperado
- Texto livre OU vazio
- Exemplos: `/resumir cap 12`, `/resumir sistema cardiovascular`, `/resumir o livro inteiro`, `/resumir` (= o que estiver visível/atual)

### Retrieval específico
- Se escopo = "livro inteiro": pega top-k=20 chunks distribuídos uniformemente por seção
- Se escopo = capítulo/sistema: top-k=12 com query "{escopo} resumo principais conceitos"

### Prompt user message (template)
```
COMANDO: /resumir
ESCOPO: {escopo_ou_geral}

Gere um resumo estruturado em markdown com:
- ## Visão geral (3-5 linhas)
- ## Pontos-chave (lista de 6-12 bullets, cada um com [[CITE:N]])
- ## Conceitos críticos pra prova (3-5 itens com nome do conceito + 1 frase)
- ## O que NÃO está coberto no códice (se houver lacunas óbvias)

Tom: direto, foco em RETER pra prova de residência BR.
```

### Output esperado
Markdown estruturado com headers H2, bullets densos, citações inline em todo bullet de conteúdo, ≤ 800 tokens output.

### Fallback
Se retrieval volta < 3 chunks relevantes (similarity todas < 0.65):
> "O códice não tem material suficiente sobre '{escopo}'. Tenta um escopo mais amplo ou confere se subiu o capítulo certo."

### Exemplo
**Input:** `/resumir doenças cardiovasculares`

**Output esperado:**
```markdown
## Visão geral
As doenças cardiovasculares (DCVs) reúnem afecções do coração e vasos, principal causa de morte no Brasil [[CITE:412]]. O capítulo cobre HAS, IAM, IC, arritmias e doenças valvares.

## Pontos-chave
- HAS é definida como PA ≥ 140x90mmHg em medidas repetidas [[CITE:418]]
- IAM tipo 1 (ruptura de placa) vs tipo 2 (desbalanço oferta/demanda) [[CITE:435]]
- IC: classificação NYHA I-IV usada pra estratificar limitação funcional [[CITE:447]]
[...]

## Conceitos críticos pra prova
- **Tríade de Beck** (tamponamento cardíaco): hipotensão + bulhas abafadas + turgência jugular
- **Killip-Kimball** (IAM): I sem ICC → IV choque cardiogênico
[...]

## O que NÃO está coberto
O códice não detalha cardiopatias congênitas pediátricas — busca em livro de Pediatria.

_Material de estudo. Não substitui avaliação clínica presencial._
```

---

## /explicar [conceito]

### Intenção
Explicação didática de um conceito específico (mecanismo, fisiopato, ação farmacológica).

### Argumento esperado
- Obrigatório, texto livre
- Exemplos: `/explicar fisiopato IC esquerda`, `/explicar mecanismo dos IECA`, `/explicar como age morfina`

### Retrieval
- top-k=8, query = `{argumento}`
- Boost em chunks com keywords técnicas detectadas (mecanismo, fisiopato, ação, etc)

### Prompt user message
```
COMANDO: /explicar
CONCEITO: {conceito}

Explique em estrutura:
- ## O que é (1-2 frases)
- ## Mecanismo / fisiopato (parágrafo denso, com [[CITE:N]] em cada afirmação)
- ## Manifestações clínicas (lista com [[CITE:N]])
- ## Por que isso cai em prova (1-2 frases — ângulo Revalida/ENARE)

Tom: didático mas não infantilizado. Usa siglas médicas (AVC, IAM, etc) sem expandir cada vez.
```

### Output esperado
Markdown estruturado, ≤ 600 tokens, denso em citações.

### Fallback
Se conceito não está no códice:
> "O códice não cobre '{conceito}' diretamente. Quer que eu tente abordagem mais ampla ou prefere subir outro material?"

### Exemplo
**Input:** `/explicar mecanismo dos IECA`

**Output:**
```markdown
## O que é
IECA = inibidores da enzima conversora de angiotensina. Anti-hipertensivos de primeira linha em IC, HAS e nefropatia diabética [[CITE:512]].

## Mecanismo
Bloqueiam a ECA, que converte angiotensina I em angiotensina II — vasoconstritor potente [[CITE:514]]. Resultado: vasodilatação arterial e venosa, redução de pré e pós-carga [[CITE:515]]. Reduzem também a aldosterona, diminuindo retenção de Na+ e água [[CITE:516]].

## Manifestações clínicas (efeitos terapêuticos e adversos)
- ↓ PA sem taquicardia reflexa significativa [[CITE:517]]
- ↓ remodelamento ventricular pós-IAM [[CITE:520]]
- Tosse seca em ~10% (acúmulo de bradicinina) [[CITE:521]]
- Hipercalemia, IRA em estenose bilateral de artéria renal [[CITE:522]]

## Por que cai em prova
Revalida adora cobrar contraindicação (gestação — categoria D) e o efeito tosse vs alternativa BRA. ENARE foca em IC com FE reduzida.

_Material de estudo. Não substitui avaliação clínica presencial._
```

---

## /quizar [tópico]

### Intenção
Gerar 5 questões estilo Revalida/ENARE com gabarito comentado.

### Argumento esperado
- Obrigatório, texto livre
- Exemplos: `/quizar arritmias`, `/quizar DPOC exacerbação`

### Retrieval
- top-k=12 (mais contexto pra cobrir várias subáreas do tópico)

### Prompt user message
```
COMANDO: /quizar
TÓPICO: {tópico}

Gere 5 questões de múltipla escolha (A-E) estilo Revalida/ENARE, mistura de:
- 2 questões de caso clínico (vinheta com paciente, idade, sintomas → conduta)
- 2 questões de conceito direto (mecanismo, classificação)
- 1 questão de DDx ou exame complementar

Para CADA questão:
- Enunciado realista (vinheta clínica em 3-5 linhas se for caso)
- Alternativas A-E plausíveis (não óbvias — distratores bons)
- ## Gabarito: letra correta
- ## Comentário: por que correta + por que cada errada está errada [[CITE:N]]

IMPORTANTE: vinhetas são SIMULAÇÕES PEDAGÓGICAS. Não use "Como conduta para esse paciente" — use "Qual a conduta correta no caso simulado".
```

### Output esperado
Markdown com 5 blocos numerados, cada um com enunciado + alternativas + gabarito + comentário citado, ≤ 1500 tokens.

### Fallback
Se < 5 questões viáveis pelo material:
> "Consigo gerar só {n} questões com o que esse códice cobre sobre '{tópico}'. Quer mais amplo?"

### Exemplo (resumido)
**Input:** `/quizar IC`

**Output:**
```markdown
### Questão 1
Paciente de 68 anos, hipertenso, dispneia aos médios esforços há 3 meses, ortopneia, edema MMII +2/+4. Ecocardiograma: FE 32%. No caso simulado, qual a classe da IC e conduta inicial pedagogicamente correta?

A) IC de FE preservada — diurético de alça
B) IC de FE reduzida — IECA + betabloqueador + diurético se congestão
C) IC isolada de VD — espironolactona
[...]

**Gabarito: B**

**Comentário:** FE < 40% define IC com FE reduzida [[CITE:447]]. Tratamento de base: IECA/BRA + BB + ARM, com diurético quando há congestão [[CITE:451]]. (A) confunde HFpEF com HFrEF. (C) é específico de IC direita pura.

[Questões 2-5 análogas]

_Material de estudo. Não substitui avaliação clínica presencial._
```

---

## /caso [tópico]

### Intenção
Caso clínico simulado com vinheta, perguntas guiadas e raciocínio.

### Argumento esperado
- Obrigatório
- Exemplos: `/caso pneumonia comunitária`, `/caso AVC isquêmico`

### Retrieval
- top-k=10

### Prompt user message
```
COMANDO: /caso (caso clínico SIMULADO pra raciocínio diagnóstico — pedagógico)
TÓPICO: {tópico}

Construa um caso clínico SIMULADO com:

## Vinheta clínica
- Paciente fictício (idade, sexo, contexto)
- Queixa principal e HMA
- Antecedentes relevantes
- Exame físico
- Exames iniciais já feitos (se cabe)

## Pergunta 1 — Hipóteses diagnósticas
Liste 3-4 hipóteses ranqueadas com justificativa do códice [[CITE:N]]

## Pergunta 2 — Próximos exames
O que pediria pra confirmar/excluir, em ordem de prioridade [[CITE:N]]

## Pergunta 3 — Conduta pedagogicamente correta
Conduta APRENDIZADO (não prescrição real). Use "no caso simulado, a conduta seria..." [[CITE:N]]

## Aprendizado-chave
2-3 bullets do que esse caso ensina

REFORÇO: usar SEMPRE "caso simulado", "no cenário pedagógico", "raciocínio clínico de prova". NUNCA dar conduta como se fosse paciente real.
```

### Output esperado
Markdown estruturado, ≤ 1000 tokens.

### Fallback
> "O códice não tem material suficiente pra montar caso de '{tópico}'. Tenta tópico próximo ou sobe material mais específico."

---

## /diferenciar [doenças]

### Intenção
Tabela comparativa de diagnóstico diferencial entre 2-5 doenças.

### Argumento esperado
- Obrigatório, lista de doenças separadas por "vs", "x" ou vírgula
- Exemplos: `/diferenciar pneumonia vs bronquite vs DPOC`, `/diferenciar AVC isquêmico x hemorrágico`

### Retrieval
- top-k=4 chunks por doença separadamente, depois consolida (total ≤ 16)

### Prompt user message
```
COMANDO: /diferenciar (DDx pedagógico)
DOENÇAS: {lista}

Construa tabela markdown comparativa com colunas:
| Critério | {Doença 1} | {Doença 2} | ... |
|---|---|---|---|

Linhas obrigatórias:
- Etiologia
- Quadro clínico clássico
- Achados de exame físico
- Exames complementares-chave
- Tratamento de aprendizado (com [[CITE:N]] na linha que valida)

Após a tabela:
## Pegadinhas de prova
2-4 bullets de armadilhas comuns que diferenciam essas patologias em prova de residência.
```

### Output esperado
Tabela markdown + pegadinhas, ≤ 800 tokens.

### Fallback
Se uma das doenças não está no códice:
> "O códice não cobre '{doença_X}'. Quer comparar só as que ele tem ({lista_disponível})?"

---

## /dose [fármaco]

### Intenção
Posologia + mecanismo + indicações, SEMPRE com aviso de bula.

### Argumento esperado
- Obrigatório, nome do fármaco
- Exemplos: `/dose amoxicilina`, `/dose enalapril`

### **GUARDRAIL ESPECIAL** (ver `COMPLIANCE.md`)
- Antes do retrieval, intent-classifier verifica se a query contém indicador de paciente específico ("pra meu paciente", "tenho um caso", nome próprio, idade específica + sintoma)
- Se SIM → bloquear com mensagem de bloqueio padrão (ver COMPLIANCE)
- Se NÃO → seguir fluxo

### Retrieval
- top-k=6, query = `{fármaco} dose posologia mecanismo indicação`

### Prompt user message
```
COMANDO: /dose (informação farmacológica de ESTUDO — não prescrição)
FÁRMACO: {fármaco}

Apresente em estrutura:

## Mecanismo de ação
Parágrafo conciso com [[CITE:N]]

## Indicações principais
Lista com [[CITE:N]]

## Posologia (referência de estudo)
| Indicação | Dose adulto | Via | Frequência |
|---|---|---|---|
| ... | ... | ... | ... |
[com [[CITE:N]] na coluna de referência]

## Contraindicações e cuidados
Lista [[CITE:N]]

## Efeitos adversos relevantes
Lista [[CITE:N]]

## ⚠️ AVISO OBRIGATÓRIO
"As doses acima são REFERÊNCIA DE ESTUDO baseadas no códice. Para prescrição real, **consulte sempre a bula vigente, protocolos institucionais e o paciente individual**. Doses variam por idade, função renal/hepática, comorbidades e interações."
```

### Output esperado
Markdown com tabela de doses, sempre ≤ 700 tokens, aviso obrigatório no final.

### Fallback
Se fármaco não está no códice:
> "O códice não tem '{fármaco}'. Pra dose real e atualizada, consulta a bula ou Whitebook/Medscape — esse aqui é só material de estudo."

---

## Tabela-resumo de specs

| Comando | Argumento obrigatório? | top-k | Modelo | Max output | Guardrail extra |
|---|---|---|---|---|---|
| `/resumir` | não | 12-20 | Haiku/Sonnet | 800 tok | — |
| `/explicar` | sim | 8 | Haiku/Sonnet | 600 tok | — |
| `/quizar` | sim | 12 | Haiku/Sonnet | 1500 tok | Vinheta = "caso simulado" |
| `/caso` | sim | 10 | Haiku/Sonnet | 1000 tok | "Caso simulado", "pedagogicamente correta" |
| `/diferenciar` | sim (≥2) | 16 | Haiku/Sonnet | 800 tok | — |
| `/dose` | sim | 6 | Haiku/Sonnet | 700 tok | Intent classifier bloqueia "meu paciente"; aviso bula obrigatório |

---

## Implementação técnica (resumo dev)

### Roteamento
- Frontend detecta `/comando ` no início da mensagem
- Envia ao backend com `slash_command: "resumir"` no payload
- Backend monta prompt user message conforme template do comando
- Inclui `slash_command` no row de `consultations` pra analytics

### Configuração por comando (config-as-code)
Criar `lib/slash-commands.ts`:
```typescript
export const SLASH_COMMANDS = {
  resumir: {
    label: '/resumir',
    description: 'Resumo estruturado de capítulo, sistema ou livro',
    requiresArg: false,
    topK: 12,
    maxOutputTokens: 800,
    promptTemplate: '...' // ver acima
  },
  // ...
}
```

### Validação de argumento
- Se `requiresArg: true` e arg vazio → frontend exibe inline "Esse comando precisa de um tópico. Ex: `/explicar fisiopato IC`"

### Telemetria
- Evento `slash_command_used` com `{ command, codex_id, has_arg, response_tokens, cost_brl }`
