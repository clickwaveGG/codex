# Codex — Instagram Content Strategy v1.0

**Documento:** estratégia de conteúdo do @codex.saude no IG
**Versão:** 2026-05-02
**Autor:** Catalyst (squad-growth)
**Estado:** pronto pra executar 30 dias

---

## 1. Pilares de conteúdo (5 — DECISÃO)

A conta opera em 5 pilares. Cada peça da semana se encaixa em UM pilar. Distribuição alvo descrita no §3.

### Pilar 1 — DOR (30%) "tu já passou por isso?"
Conteúdo que ressoa com a dor real do estudante de saúde brasileiro.
- "Sensação de bater o livro fechado às 3 da manhã sem achar o trecho"
- "Quando o professor manda ler 80 páginas pra terça e o livro tem 1500"
- "Marcador colorido virou pista de pouso e tu ainda tá perdido"
- "Resumo de colega no WhatsApp não bate com a prova"
- "Folheia Robbins por 20 min pra confirmar 1 frase"

**Função no funil:** identificação. Estudante se vê. Salva o post. Comenta marcando colega.

### Pilar 2 — DEMO (25%) "olha o Hipócrates respondendo"
Mostra o produto FUNCIONANDO. Mesmo em estado de protótipo/wireframe nessa fase pré-MVP.
- Print/screen recording de chat com Hipócrates explicando fisiopato
- Antes/depois: "tempo pra achar tópico no Robbins" → manual 18 min vs Codex 12 segundos
- Slash-commands em ação (`/quizar`, `/caso`, `/diferenciar`)
- Citação clicável `[pp. 437]` em destaque
- Side-by-side com NotebookLM (em inglês, sem terminologia BR) vs Codex (PT-BR clínico)

**Função no funil:** desejo. "Quero usar isso AGORA". Driver direto pra waitlist.

### Pilar 3 — BASTIDORES (20%) "estou construindo isso solo"
Build in public. Leonardo mostrando o processo.
- Print do brandbook, do PRD, do schema Supabase
- "Hoje terminei a paleta — verde clínico + ouro" + grid de cores
- Decisões de produto comentadas: "por quê tirei o tier Especialista"
- Erros e refatorações: "embedei Robbins inteiro e estourou US$ 3 — limite agora é..."
- Foto da mesa de trabalho às 3 da manhã (Leonardo é noctívago — usar autenticamente)

**Função no funil:** confiança + comunidade. Estudante vira fã do criador, não só do produto. Conta lifetime começa aqui.

### Pilar 4 — DIDÁTICO (15%) "mini-aula usando Codex"
Mini-aulas REAIS de tema do ciclo, com o Codex como protagonista invisível.
- "Diferencial entre asma e DPOC em 1 carrossel" (gerado via `/diferenciar`)
- "5 questões estilo Revalida sobre IAM" (gerado via `/quizar`)
- "Caso clínico: dispneia + edema MMII — vamo raciocinar?"
- "3 mnemônicos que ainda funcionam em 2026"

Cada peça mostra o slash-command que originou o conteúdo no rodapé. "Esse carrossel veio do `/quizar IAM` rodando no Codex em 4 segundos".

**Função no funil:** alcance + valor. Conteúdo salvável que viraliza por utilidade. Direciona pra waitlist no CTA final.

### Pilar 5 — PROVA SOCIAL & WAITLIST (10%) "tá enchendo"
Updates do crescimento da conta + da lista. Cria FOMO orgânico.
- "Lista bateu 500 inscritos em 9 dias 🎫"
- "30 vagas no beta. 187 pessoas na fila."
- Print de DM de estudante pedindo acesso antecipado
- Stories de comentário de seguidor empolgado
- Anúncio de marcos: "primeiros 100 / 500 / 1000 inscritos"

**Função no funil:** urgência. Quem ainda não entrou sente que tá perdendo a janela.

---

## 2. Distribuição semanal por formato (DECISÃO)

Carga realista pra solo founder web designer com tempo limitado.

| Formato | Quantidade/semana | Pilar dominante |
|---|---|---|
| **Reels** | 3 (seg/qua/sex) | DOR + DEMO + DIDÁTICO |
| **Carrossel** | 2 (ter/qui) | DEMO + BASTIDORES |
| **Post único** (foto/imagem) | 1 (sáb) | BASTIDORES ou PROVA SOCIAL |
| **Stories** | 5-7/semana (1 por dia útil + 2 fim de semana) | LIVRE — bastidores rápidos, polls, takes |
| **Lives** | 1 a partir da semana 3 | DEMO + Q&A |

**Total:** 6 posts no feed/semana + stories diárias + 1 live a partir de S3.

### Por quê essa distribuição

- **Reels 3x semana** é o teto realista pra solo founder produzir bem (cada reel toma 1-3h se quer parecer profissional). Mais que isso, qualidade despenca.
- **Carrossel 2x semana** porque carrossel ainda é o formato com maior tempo de tela e maior chance de salvamento — crítico pra crescimento orgânico.
- **Stories diários** mantêm a conta viva nas top stories de quem segue, mas custam pouco (1-3 min cada).
- **Post único 1x semana** tipo "foto da mesa de trabalho 4h da manhã" pra humanizar sem custo de produção.
- **Lives semanais a partir de S3** quando já houver 200+ seguidores — antes disso vira live vazia, demotivador.

### Peso por dia da semana

```
SEG  Reel (DOR)
TER  Carrossel (DEMO ou DIDÁTICO)
QUA  Reel (BASTIDORES ou DEMO)
QUI  Carrossel (DIDÁTICO ou BASTIDORES)
SEX  Reel (DEMO ou DOR)
SÁB  Post único (BASTIDORES) — engajamento melhor sábado de manhã
DOM  Off feed (só story leve) — protege folga do founder e algoritmo
```

Horários ótimos pra IG no nicho saúde-estudante BR (validados em outras contas):
- **Seg-Sex:** 12h-13h (intervalo) ou 19h-21h (estudo noturno)
- **Sáb:** 9h-11h (acordou, café da manhã)
- **Dom:** evitar (algoritmo pune e audiência tá com família)

Recomendação: **postar feed 19h30** (cobre ambos os turnos de pico) e **stories ao longo do dia** (manhã, almoço, noite).

---

## 3. Frequência consolidada

| Métrica | Mês 1 (semanas 1-4) |
|---|---|
| Posts no feed/mês | 24 (6/sem × 4 sem) |
| Stories/mês | 28-32 |
| Reels específicos/mês | 12 |
| Carrosséis/mês | 8 |
| Posts únicos/mês | 4 |
| Lives/mês | 2 (uma S3, uma S4) |

**Tempo estimado de produção solo:** 8-12h/semana = ~1h30 por dia.

Se Leonardo extrapolar isso, é hora de chamar `content-orqx` pra escalar produção (ver §8).

---

## 4. Hashtags estratégicas (3 grupos × 20 tags cada)

Combinar 1 tag de cada grupo + 7-10 tags por post. Não usar 30 tags em todo post (algoritmo IG hoje pune excesso).

### Grupo A — Nicho saúde estudantil BR (mirado, baixa-média concorrência)
Usar 4-5 dessas em cada post — é a base do alcance qualificado.

```
#estudantedemedicina   #futuromedico       #medicinabrasil
#residenciamedica       #revalida2026      #usmedicine
#enfermagembr          #fisioterapiabr     #farmaciabr
#odontologiabr         #nutricaouniversitaria  #biomedicinabrasil
#estudaresaude         #caderno           #vidademed
#vesperadeprova        #rotinademed       #internatomedico
#marathoner            #dicademedicina
```

### Grupo B — IA & EdTech (médio alcance, audiência apta a converter)
Usar 2-3 dessas em cada post — atrai estudante curioso por tech.

```
#iaparaestudo          #chatgpt            #notebooklm
#estudoinovador        #ferramentasdeestudo  #produtividadeacademica
#edtechbrasil          #appdeestudo        #estudonainternet
#estudarcomia          #pdftoolsbr         #aiforstudents
#chatpdf               #gpt4medicina       #automacaoestudo
#tecnologiaeducacional #estudosdigitais   #cursorai
#claudeai              #anthropicclaude
```

### Grupo C — Ampliação (alto volume, descoberta)
Usar 2-3 dessas em cada post — mais alcance bruto, menor qualificação.

```
#estudo                #medicina           #saude
#educação             #aprender           #vidauniversitaria
#universitario         #estudante          #tecnologia
#brasil2026            #produtividade      #aprendizado
#startupbr             #empreendedorismo   #saastoolsbr
#construindoempublico  #buildinpublic     #foundersbrasil
#solofounder           #appbrasileiro
```

### Combinação modelo (copiar e colar como base)

```
#estudantedemedicina #futuromedico #vesperadeprova #estudaresaude
#iaparaestudo #ferramentasdeestudo
#construindoempublico #saastoolsbr #medicina
```

(9 tags — sweet-spot atual do IG)

---

## 5. Padrão visual (DECISÃO — templates Canva)

Brandbook do Codex já trava paleta + tipografia. Aplicar EXATAMENTE no IG. Sem variação por humor — consistência cria reconhecimento de marca em feed.

### 5 templates Canva pra criar no Dia 1

#### Template REEL-COVER (1080×1920)
- Fundo: `#0F1A14` (dark elev) ou `#F2F5F3` (bg-warm) alternando
- Headline: Playfair Display 700, branco (`#F4F1EA`) ou `#0F1A14`, máx 6 palavras, centralizado vertical
- Acento: barra dourada `#C4982A` 4px abaixo do título
- Logo Codex pequeno no canto inferior direito (mark.svg, 60×60)

#### Template CARROSSEL-CAPA (1080×1350 — 4:5)
- Fundo: `#F7F9F8` (bg-page)
- Eyebrow superior: Inter 500 14px tracking-wider uppercase em `#5A6B62` (text-secondary) — ex: "DEMO · DIA 03"
- Título: Playfair 700 38-48px em `#0F1A14`
- Subtítulo: Inter 400 18px em `#5A6B62`
- Indicador de slides: 5 dots no rodapé, primeiro em `#0B7A65` (primary), demais em `#DDE5E1` (border)
- Logo Codex horizontal no rodapé esquerdo

#### Template CARROSSEL-MIOLO (1080×1350)
- Fundo: `#FFFFFF` (bg-elevated) com borda `#EBF0ED` 1px
- Número do slide: Playfair 700 64px em `#C4982A` (accent) no topo esquerdo
- Headline do slide: Inter 600 24px em `#0F1A14`
- Body: Inter 400 18px em `#0F1A14`
- Quando mostrar print de chat: card com border-left 4px `#C4982A` (replica o pattern do brandbook §9 "resposta da IA")

#### Template CARROSSEL-CTA (último slide)
- Fundo: `#0B7A65` (primary)
- Headline: Playfair 700 42px em `#F4F1EA` (text-on-dark) — "Entra na lista de espera"
- CTA descrito: Inter 500 18px branco — "Link na bio · primeiros 30 viram beta"
- Logo Codex mono-white centralizado embaixo

#### Template POST-ÚNICO-FOTO (1080×1080)
- Foto real (mesa, tela, código) sem filtro forte
- Overlay inferior 30% altura: gradiente `#0F1A14` → transparente
- Caption sobre overlay: Playfair 700 36px branco, máx 8 palavras
- Logo no canto inferior direito (mark mono-white)

### Identidade visual de Reels (vídeo)

- **Abertura (1s):** logo Codex animado entrando, fundo `#0F1A14`, ENTRADA SUTIL — sem sound design exagerado
- **Texto na tela (toda fala):** Inter 700 + outline preto + ALL CAPS quando quiser ênfase
- **Cor de destaque dentro do vídeo:** dourado `#C4982A` em palavras-chave (ex: "página exata" em dourado, resto branco)
- **Logo bug** no canto inferior direito durante todo o reel (transparência 70%)
- **Música:** trending sounds OK desde que instrumentais ou minimalistas — evitar áudio de "guru" ou "viral cringe"

### Ferramentas

- **Canva Pro** R$ 36/mês — recomendo OBRIGATÓRIO. Templates ficam salvos. Marca custom.
- **CapCut** (free) — edição de Reels mobile. Suficiente.
- **Loom** — gravar telas pra demos. Free tier basta.
- **Figma** já está no fluxo do Leonardo — usar pra wireframes que viram reel/carrossel.

---

## 6. Tom de voz aplicado por formato

### Reels
- Hook na primeira frase obrigatório (ver IG-POSITIONING §5).
- Caption curta (40-80 palavras). Reforça o hook e fecha com CTA.
- Áudio: voz própria do Leonardo (autenticidade) ou texto-na-tela puro. Evitar narração de IA pelo menos no mês 1.
- Duração ideal: 15-30s. Acima disso, retenção cai.

### Carrosséis
- Slide 1 = headline + promessa. "5 sinais que tu precisa de um chat com PDF de medicina"
- Slides 2-N = 1 ideia por slide, 2-3 frases máximo
- Penúltimo slide = recap ou insight final
- Último slide = CTA waitlist (template fixo)
- Caption: 80-150 palavras explicando contexto + CTA + hashtags

### Posts únicos
- Foto/imagem fala mais que legenda
- Caption: 30-100 palavras, tom íntimo (foto da mesa às 4h: "tava decidindo se ia dormir ou refatorar o schema. Refatorei.")
- Sempre fechar com 1 CTA mole ("comenta aí", "marca alguém") ou hard ("link na bio")

### Stories
- 1-3 stories por sequência, raramente mais
- Sempre 1 elemento interativo (poll, slider, pergunta, quiz)
- Reposta DM no story com discrição (sem expor handle do user)
- "Link sticker" obrigatório quando direcionar pra waitlist

---

## 7. Frameworks de hook reutilizáveis (BIBLIOTECA)

10 templates de hook que Leonardo pode adaptar infinitamente. Cada hook tem track record provado em conta de educação BR.

1. "Tu já passou ___?" → Pilar DOR
2. "Olha o que acontece quando ___ 👇" → Pilar DEMO
3. "Estou construindo ___. Hoje terminei ___." → Pilar BASTIDORES
4. "Em ___ segundos eu te explico ___" → Pilar DIDÁTICO
5. "Ninguém fala isso, mas ___" → Pilar DOR ou BASTIDORES
6. "3 jeitos de ___ — qual tu usa?" → Pilar DIDÁTICO
7. "Eu testei ___ vs ___ e o resultado foi ___" → Pilar DEMO (comparativo)
8. "Se tu estuda ___, isso vai te economizar ___" → Pilar DEMO
9. "A pior coisa de ler ___ é ___" → Pilar DOR
10. "Antes de pagar curso de ___, faz isso primeiro" → Pilar DIDÁTICO

---

## 8. Sinais pra escalar produção

Acionar `content-orqx` pra apoio quando QUALQUER um desses gatilhos disparar:

- Conta passou de 2.000 seguidores e produção saturou Leonardo
- Algum reel passou 50k views — vale dobrar a aposta (série) e criar mais 5 nessa pegada
- Beta abriu e tem 100+ usuários gerando histórias REAIS pra reposicionar conteúdo (UGC)
- Leonardo precisa focar 2 semanas no build (sprint 1.3 ou 2.x) — content-orqx pode preparar 2 semanas de conteúdo evergreen pré-aprovado

---

## 9. O que NÃO fazer (lições do nicho saúde-edu BR)

1. **Não compartilhar conteúdo médico SEM disclaimer** quando envolver dose, conduta clínica, sinal de alarme — risco real de CFM e de morte de paciente real (sim, alguém pode achar que é diagnóstico de verdade)
2. **Não brigar com NotebookLM ou ChatGPT** — público pode achar invejoso. Posicionar como "alternativa BR pra estudante" e deixar a comparação implícita.
3. **Não usar foto de paciente real, raio-x identificável, prontuário** — LGPD-saúde fulminante. Usar imagens genéricas, atlas livres, geração IA.
4. **Não prometer aprovação em prova/residência** — "vai passar na Revalida" é cilada. "Pode te ajudar a estudar mais focado" é defensável.
5. **Não copiar formato de "guru de medicina" do TikTok** (gritando, apontando, vermelho-amarelo) — choca o nicho que tem peso clínico.
6. **Não pular semana** — algoritmo do IG pune ausência. Se Leonardo viajar, deixar 7 dias agendados via planejador (Later, Buffer, Meta Business Suite native).

---

**Fim do IG-CONTENT-STRATEGY.md.** Próximo: `IG-CALENDAR-30DAYS.md`.
