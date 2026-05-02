# HEALER — Documento de Contexto Completo

**Versão:** 2026-04-30
**Fundador:** Leonardo (clickwaveGG)
**Estado:** conceito — gêmeo do Grimoire voltado pra saúde
**Origem:** clone temático do Grimoire (PDF Q&A) adaptado para estudantes de medicina

> **Sobre o nome:** "HEALER" é placeholder. Sugestões a validar:
> - **Healer** (direto, internacional, ecoa "Grimoire" no estilo)
> - **Asclepius** (deus grego da medicina — equivalente erudito)
> - **Galeno** (médico greco-romano, fonte do termo "galênico")
> - **Codex Vitae** (códice da vida — paralelo direto a "Grimório")
> - **Curandus** (latim de "aquele que cura")
> - **Anamnese** (termo clínico real — mas talvez genérico demais)

---

## 1. O QUE É O HEALER

Healer é um **SaaS de Q&A sobre PDFs para estudantes de medicina e profissionais de saúde brasileiros**. O usuário sobe qualquer documento clínico (livro-texto, atlas, diretriz, artigo, caso clínico) e consulta com ele em linguagem natural via assistente de IA — recebendo resumos, explicações de fisiopatologia, simulação de prova/residência, resolução de casos clínicos e citações com a página exata.

A categoria é a mesma de **NotebookLM, ChatPDF, Humata, Perplexity Spaces** — mas o Healer se diferencia por **narrativa de marca temática voltada à saúde**: tudo que outros chamam de "documento" e "pergunta", o Healer chama de "códice" e "anamnese". A IA é um curandeiro. O usuário é estagiário/residente/clínico. A interface inteira respira essa identidade clínica.

**Tese central:** "O conhecimento que cura." Transformar leitura passiva (manuais densos que ninguém lê inteiro) em decisão clínica ativa (perguntar, consultar, aplicar).

---

## 2. PÚBLICO-ALVO

- **Estudantes de medicina brasileiros 18-30 anos**
- Foco em: graduação (1º-6º ano), pré-residência, residentes
- Segmentos secundários: enfermagem, fisioterapia, farmácia, odontologia, nutrição
- Persona primária: estudante de medicina com 8-12 livros-texto pesados por ciclo, prova de plantão semana que vem, gasta horas folheando Robbins/Guyton/Harrison procurando trecho exato

---

## 3. CONCORRÊNCIA E DIFERENCIAÇÃO

### Concorrentes diretos
- **NotebookLM** (Google) — gratuito, robusto, mas frio, em inglês predominante, sem identidade clínica
- **ChatPDF** — pioneiro, UX datada, marca neutra
- **Humata** — pesquisadores acadêmicos, B2B-leaning
- **Perplexity Spaces** — busca + agente, não é PDF-first
- **OpenEvidence, Glass Health** (concorrentes específicos de medicina) — focados em prática clínica de médicos formados, não em estudantes

### O que o Healer faz diferente
1. **Narrativa de marca clínica**: única categoria PDF Q&A com identidade visual + verbal voltada à medicina. Estudante responde a tema e validação profissional.
2. **Curado pra contexto BR-medicina**: glossário em PT clínico, prompts otimizados pra livros-texto brasileiros (Porto, Tratado de Pediatria SBP) e provas BR (Revalida, USP, UNIFESP, ENARE).
3. **Pricing acessível pra estudante**: R$ 14,90/mês vs $20+ dos gringos. Pix recorrente.
4. **Tom direto e jovem mas com peso clínico**: copy coloquial PT-BR sem perder seriedade médica.
5. **Aviso legal claro**: ferramenta de estudo, NÃO de diagnóstico clínico real (importante por compliance CFM).

---

## 4. GLOSSÁRIO PROPRIETÁRIO (sempre usar essas palavras)

| Termo do mundo real | Termo Healer |
|---|---|
| PDF / documento | **códice** ou **compêndio** |
| Pergunta | **anamnese** ou **consulta** |
| Submeter pergunta | **consultar** ou **auscultar** |
| Resposta da IA | parecer / Hipócrates diz / o curandeiro responde |
| Dashboard | **consultório** |
| Assinatura | **juramento** (referência ao Juramento de Hipócrates) |
| Tier free | **Estagiário** |
| Tier pago básico | **Residente** |
| Tier pago premium | **Clínico** |
| Tier lifetime | **Mestre** ou **Preceptor** |
| Assistente IA | **Hipócrates** (homenagem ao pai da medicina) |

⚠️ **Não inventar novos termos**. Se precisar de um conceito novo, propor antes de aplicar.

⚠️ **Compliance**: nunca chamar a IA de "médico" ou afirmar que ela "diagnostica". Sempre "explica conteúdo de estudo", "auxilia revisão", "simula casos para aprendizado".

---

## 5. IDENTIDADE VISUAL

### Paleta proposta (a refinar)
- **Void Clínico**: `#030B0A` — preto-verde absoluto (background)
- **Deep Sage**: `#0F1A17` — verde profundo escuro (cards)
- **Apothecary Green**: `#1E4D3F` — verde-medicinal (acentos)
- **Sage**: `#3FA68C` — verde claro brand principal
- **Pulse**: `#76EBC4` — verde luminescente (acentos vivos)
- **Mist**: `#C8FFE8` — verde menta clarinho
- **Bone**: `#F4F1EA` — branco quente (texto principal — igual Grimoire)
- **Linen**: `#E8E2D5` — branco fosco
- **Vital Red**: `#D4373F` — vermelho médico (uso pontual: alerta, sigilo, símbolo do caduceu)
- **Vital Red Light**: `#F58A8A` — vermelho claro (highlights)

**Regra geral:** preto-esverdeado + verde-medicinal + branco como base. Vermelho é acento RARO — só aparece no nome da marca e em ícones críticos.

> **Alternativa consciente:** manter roxo como o Grimoire (consistência cross-product) e usar verde-medicinal só como acento. Decisão pendente.

### Tipografia (proposta — espelhar Grimoire mas com pegada clínica)
- **Brand mark / nome do produto**: fonte serif elegante com pegada de placa de consultório antigo (sugestões: `Playfair Display`, `Cormorant Garamond`, `Cinzel` — todas Google Fonts) — alternativa premium: fonte custom estilo art-déco médico
- **Headlines, body, UI**: `EB Garamond` (mesma do Grimoire — pegada de livro-texto clássico funciona bem em medicina)
- **Mono / dados**: `JetBrains Mono` ou `IBM Plex Mono` — pra exibir doses, fórmulas, valores de referência

### Logo (a desenvolver)
Sugestões de direção:
- **Caduceu estilizado** com livro aberto na base (referência a Hermes/Asclépio)
- **Bastão de Asclépio** (uma serpente, mais correto do que caduceu) com pergaminho enrolado
- **Almofariz e pistilo** estilizado (símbolo farmacêutico clássico) sobre um livro
- **Coração anatômico** estilizado em traço médico (ECG-like) integrado a página de livro

Estilo recomendado: ilustração rica como o Grimoire (não pixel art), paleta verde + dourado/vermelho de acento.

---

## 6. ARQUITETURA TÉCNICA (idêntica ao Grimoire)

### Pipeline RAG
Mesma do Grimoire — sem nenhuma mudança técnica:
```
PDF upload → Parse + chunk → Embeddings → Vector store
→ User query → similarity search → Prompt → LLM → Resposta com citação
```

### Stack proposto
Idêntico ao Grimoire:
- **Frontend**: Next.js 15 + React + Tailwind + shadcn/ui
- **Backend**: Next.js API routes ou Hono
- **Auth**: Supabase Auth
- **DB**: Supabase Postgres + pgvector
- **Storage**: Supabase Storage
- **LLM**: Anthropic Haiku 4.5 (default) + Sonnet 4.5 (Clínico tier)
- **Embeddings**: OpenAI text-embedding-3-small
- **Pagamento**: Asaas (Pix recorrente)
- **Hosting**: Vercel
- **Observability**: PostHog + Sentry + Helicone

### Diferenças técnicas vs Grimoire
1. **Prompt do sistema customizado pra contexto clínico**: a IA deve assumir contexto médico, citar terminologia técnica corretamente, e sempre incluir disclaimers
2. **Limitador de prompt sensível**: bloquear queries que peçam diagnóstico real ou prescrição (apenas estudo)
3. **Possível indexação especial pra siglas médicas**: ECG, RNM, TC, AVC, IAM, etc — embedding precisa entender abreviações
4. **PDFs maiores**: livros-texto de medicina são pesados (Robbins ~1500 páginas) — testar limites de upload e cap em ~80MB

### Custo unitário (mesma estrutura do Grimoire)
Mesmas travas obrigatórias:
1. Prompt caching em 100% das chamadas
2. Limite duro de consultas/dia por tier
3. Sonnet só Clínico (R$ 29,90)
4. Embedding rate limit
5. Streaming + cancelamento

---

## 7. PRODUTO — FUNCIONALIDADES (MVP)

### Fluxo principal
1. **Onboarding**: Google login → tour rápido (3 telas focadas em casos médicos) → upload primeiro códice
2. **Upload de códice**: drag-and-drop PDF → parsing visível ("Decifrando o tratado...") → confirmar título e categoria (anatomia, farmacologia, etc)
3. **Consultório (dashboard)**: grid dos códices — capa colorida procedural, contagem de consultas, último acesso
4. **Conversa com Hipócrates**: textarea + slash-commands rápidos:
   - `/resumir [escopo]` → resumo de capítulo/sistema/livro inteiro
   - `/explicar [conceito]` → explicação em linguagem clara (fisiopato, mecanismo, ação)
   - `/quizar [tópico]` → 5 questões estilo prova de residência (Revalida/ENARE)
   - `/caso [tópico]` → caso clínico simulado para raciocínio diagnóstico
   - `/diferenciar [doenças]` → tabela comparativa de diagnóstico diferencial
   - `/dose [fármaco]` → posologia e mecanismo (com aviso "consultar bula sempre")
5. **Resposta com citação**: cada parágrafo linkado pra página específica do PDF
6. **Histórico de consultas**: por códice, ordenado por data, pesquisável

### Funcionalidades secundárias (pós-MVP)
- Highlight + nota dentro do PDF
- Multi-códice query (perguntar em todos os códices da estante de uma vez)
- Export pra Anki / Notion (cards de revisão)
- Modo apresentação (gerar slides pra round/seminário)
- Banco de imagens médicas indexáveis (raio-x, RNM, lâminas histológicas)
- Modo "prova" — quiz cronometrado com simulado de residência

### Tiers e limites
| Tier | Preço | Códices | Consultas/dia | Modelo IA |
|---|---|---|---|---|
| Estagiário (free) | R$ 0 | 2 | 50 | Haiku 4.5 |
| Residente | R$ 14,90/mês | 15 | 300 | Haiku 4.5 |
| Clínico | R$ 29,90/mês | ilimitado | 1.000 | Haiku + Sonnet 4.5 |
| Mestre (lifetime) | R$ 297 once | ilimitado | 1.500 | Haiku + Sonnet (lock-in) |

Anuais com ~33% off (Residente R$ 119/ano).

---

## 8. UX / TOM DE VOZ

### Princípios
- **PT-BR coloquial mas com peso clínico**: "bora consultar", "deixa o Hipócrates te explicar", "o caso aponta pra..."
- **Direto e profissional**: "transforma um livro-texto em consultor de bolso" (não "potencialize seus estudos médicos com IA")
- **Microcopy temático sem cringe**: "Auscultando..." em vez de "Loading..." é OK; "Curando suas dúvidas com magia ancestral" é cringe
- **Disclaimers claros e frequentes**: "Material de estudo. Conduta clínica real exige avaliação presencial."

### Exemplos de copy proposta
- Headline: "Transforme um livro-texto em um *Codex*"
- Sub: "Sobe qualquer PDF — Robbins, Guyton, Harrison, sua apostila — e consulte ele como se fosse um preceptor experiente. Casos clínicos, mecanismos, diferenciais, dose. Sem ler 1500 páginas."
- Chat intro: "Como posso te ajudar a estudar?"
- Sub-chat: "Faça uma consulta ou anamnese"
- Placeholder: "Pergunta pro Hipócrates sobre teu material..."
- Footer: "Forjado por LD"
- Botões: "Consultar" (send), "Resumir / Explicar / Caso / Diferenciar" (slash-commands)

### Tom comparado ao Grimoire
- Grimoire: **mago** (Mago 70% + Sábio 30%)
- Healer: **curandeiro** (Curador 60% + Sábio 40% — Sábio mais alto pra reforçar credibilidade clínica)

---

## 9. ESTADO ATUAL

### Status real
- **Conceito apenas** — nenhuma linha de código escrita
- Pode reaproveitar 100% da landing do Grimoire como template (mesma estrutura HTML, trocar copy + paleta + assets)
- Repositório novo a criar: sugestão `clickwaveGG/healer` (ou nome final escolhido)

### Estimativa de adaptação
- Reaproveitar landing v1 do Grimoire: ~2-3 horas pra trocar copy + paleta + imagens
- Logo novo: 1-2 dias (designer ou IA generativa)
- Fontes: pesquisar/escolher com mesma metodologia do Grimoire
- Hero image: gerar nova imagem temática (consultório antigo, biblioteca clínica, atelier de boticário)

---

## 10. PRICING E UNIT ECONOMICS

Idêntico ao Grimoire (mesmos riscos e travas obrigatórias):
- Free Estagiário: 2 códices, 50 consultas/dia
- Residente R$ 14,90/mês
- Clínico R$ 29,90/mês
- Mestre R$ 297 lifetime

### Diferenças pra considerar
- **LTV potencialmente maior**: estudante de medicina tem ciclo de 6 anos + residência (3-5 anos) + carreira médica = 10-15 anos de uso potencial
- **Disposição a pagar potencialmente maior**: estudantes de medicina têm orçamento de estudos historicamente mais alto (cursinho de residência custa R$ 5-10k/ano)
- **Pode justificar tier "Especialista" R$ 49,90** com features avançadas: simulado de residência cronometrado, banco de casos clínicos, integração com Anki

---

## 11. GO-TO-MARKET (GTM)

### Janela
- **Lançamento-alvo: Fevereiro/2027** (mesma janela do Grimoire — início de semestre)
- Ou alternativamente: **Março-Abril/2027** (pico de inscrição em cursinho de residência)
- Beta privado: Out-Dez/2026 com 30-50 estudantes de medicina selecionados

### Canais
1. **TikTok / Instagram orgânico + micro-influencers de medicina**
   - Foco em: estudantes de medicina com 10-100k seguidores (#medicina, #futuromedico, #residenciamedica)
   - Budget: R$ 8-12k/mês
2. **Google Ads + SEO**
   - Keywords: "como estudar medicina pdf", "alternativa NotebookLM medicina", "Robbins resumo capítulo"
   - Budget: R$ 12-18k/mês inicial
3. **Comunidades de estudantes de medicina**
   - Grupos de WhatsApp/Telegram de cada faculdade
   - Centros acadêmicos de medicina (CAs)
   - Cursinhos de residência (parcerias B2B2C)
4. **Content marketing PT-BR clínico**
   - Blog: guias por sistema, mnemônicos, resumos de diretrizes
   - Templates de prompt pra cada matéria do ciclo

### Budget total inicial
- R$ 40-60k pros 3 primeiros meses (ligeiramente maior que Grimoire — público mais nichado, CAC mais alto)

---

## 12. ROADMAP / PRÓXIMAS SQUADS A ATIVAR

### Imediato (validação de conceito)
1. **brand-orqx** → Definir nome final + brandbook completo (paleta, tipografia, logo, glossário)
2. **research-orqx** → Confirmar TAM/SAM/SOM do mercado de estudantes de medicina BR + concorrentes verticais
3. **product-orqx** → Spec MVP com diferenças vs Grimoire (prompt clínico, disclaimers, slash-commands específicos)

### Médio prazo
4. **finance-orqx** → Modelo financeiro (LTV maior justifica CAC maior?)
5. **copy-orqx** → Refinamento de toda copy
6. **design-orqx** → Sistema de design clínico
7. **growth-orqx** + **paidmedia-orqx** → Plano GTM

### Construção
8. Adaptar landing do Grimoire (1-3 dias)
9. Construir MVP (mesma stack — possivelmente reutilizar 80% do código do Grimoire)

---

## 13. RELAÇÃO COM O GRIMOIRE

### Estratégia de portfólio
- **Grimoire**: vertical generalista universitário (qualquer curso)
- **Healer**: vertical específico medicina/saúde
- Mesma stack, mesmo modelo de negócio, mesma cara de produto, **temas e públicos diferentes**

### Vantagens dessa estratégia
1. **Reuso técnico**: 80%+ do código compartilhado, manutenção paralela
2. **Aprendizado cruzado**: insights de UX/conversão de um se aplicam ao outro
3. **Hedge de mercado**: se Grimoire não vinga em algum nicho, Healer pode capturar valor diferente
4. **Posicionamento**: dois produtos focados batem um produto generalista em conversão

### Riscos
1. **Diluir foco**: solo founder rodando dois produtos é arriscado
2. **Canibalização**: estudante de medicina pode preferir Grimoire genérico se preço for menor
3. **Custo de marca dobrado**: dois domínios, dois designs, duas campanhas
4. **Compliance médico**: Healer carrega risco regulatório (CFM, ANVISA) que Grimoire não tem

### Recomendação
Lançar **Grimoire primeiro** (Fev/2027), validar o modelo, e se MRR > R$ 25k em 6 meses, lançar Healer Set/2027 reaproveitando a infraestrutura.

---

## 14. ARQUIVOS DE REFERÊNCIA (a criar)

- **Memória persistente**: criar nova entrada `project_healer.md` quando ativar squad
- **Repo local**: `C:\Users\PC\Projects\healer\` (a criar)
- **Site live**: a definir (sugestão: `healer-clickwave.vercel.app`)
- **GitHub**: `https://github.com/clickwaveGG/healer` (a criar)

---

## 15. REGRAS GERAIS DE TRABALHO COM ESSE PROJETO

1. **Sempre validar com Grimoire-overview primeiro** — usar ele como base, não reinventar
2. **Glossário clínico travado** — não inventar termos novos sem consultar
3. **Disclaimers de compliance em destaque** — toda resposta da IA deve ter "material de estudo, não substitui avaliação clínica"
4. **Tom: coloquial mas com peso clínico** — não cair no místico nem no corporatês
5. **Auto-deploy ativo** quando o repo for criado
6. **Não usar a palavra "diagnóstico" sem contexto de aprendizado** — usar "raciocínio diagnóstico", "diferencial pedagógico", "caso simulado"
7. **Pricing trava margem igual Grimoire**: caching obrigatório + caps duros

---

## 16. STATUS DE QUALIDADE

🔲 Nome final do produto não definido
🔲 Brandbook não criado (paleta provisória, fontes provisórias, logo inexistente)
🔲 Repositório não criado
🔲 Landing não construída
🔲 MVP do produto não construído
🔲 Compliance jurídico (CFM, LGPD-saúde) não validado
✅ Conceito claro e diferenciado do Grimoire
✅ Estratégia de portfólio definida (Grimoire primeiro, Healer 6m depois se viável)

---

## 17. DECISÕES PENDENTES PRO LEONARDO

1. **Nome final do produto** (ver opções no topo do doc)
2. **Paleta**: verde-medicinal próprio OU manter roxo do Grimoire pra consistência cross-product?
3. **Logo direção**: caduceu, bastão de Asclépio, almofariz, ou coração anatômico?
4. **Estratégia de lançamento**: lançar simultâneo ao Grimoire (mais risco), ou esperar 6 meses pra validar Grimoire primeiro (mais seguro)?
5. **Escopo inicial**: só medicina, ou abrir pra enfermagem/fisio/farmácia desde o lançamento?
6. **Tier extra "Especialista"** R$ 49,90 com simulado cronometrado de residência?
7. **Nome do assistente IA**: Hipócrates (sugerido), Galeno, Asclépio, ou outro?

---

**Fim do documento de contexto.** Este documento espelha o GRIMOIRE-OVERVIEW.md adaptado pra vertical de saúde. Para iniciar o projeto, validar as decisões pendentes acima e criar o repositório.
