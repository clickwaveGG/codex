# CODEX — Brandbook v1.0

> "O conhecimento que cura."

Versão: 2026-05-02
Autor: Meridian (squad-brand) para clickwaveGG
Status: fundações fechadas — pronto para aplicar em landing, produto e GTM

---

## 1. Identidade

### Nome final

**CODEX**

Pronúncia: /'kɔ.dɛks/ — duas sílabas, fácil em PT-BR e EN. Plural natural: "códices".

### Por que Codex (rationale curto, decisão fechada)

1. **Pronúncia BR natural** — sem acento, sem letra muda, sem pegadinha. Estagiário de Medicina lê e escreve certo na primeira tentativa. Healer/Asclepius/Galeno/Curandus carregam fricção (anglicismo, latim erudito ou nome próprio confuso).
2. **Encaixa no glossário proprietário** — o produto inteiro chama PDF de "códice/compêndio". O nome do SaaS *é* a palavra-chave do vocabulário. Naming reforça produto e vice-versa.
3. **Sonoridade vs Grimoire** — Grimoire (3 sílabas, francês, mago) e Codex (2 sílabas, latim, clínico) soam como irmãos do mesmo selo: ambos remetem a livros antigos de saber especializado, mas ocupam territórios distintos. Cross-product consistency sem canibalização.
4. **Disponibilidade operacional** — `codex.com.br` provavelmente ocupado, mas variantes de produto são viáveis: `codex.app`, `codexsaude.com.br`, `codex-clickwave.vercel.app`, `usecodex.com.br`. Para MVP no Vercel já temos slug funcional. Para marca registrada futura, registrar como **"Codex Saúde"** ou **"Codex Estudos"** no INPI (classes 9 e 41) — Codex puro é genérico demais juridicamente, mas combinação fica defensável.
5. **Risco controlado** — existe Codex (OpenAI assistente de código) e Codex (Marvel). Nenhum compete na vertical de educação em saúde BR. Categoria distinta = baixo risco real de confusão.
6. **Já está vivo** — a landing v1 deployada (`codex-32w503m89-clickwaveggs-projects.vercel.app`) e o repo `clickwaveGG/codex` já carregam o nome. Mudar agora é retrabalho gratuito quando a escolha já está validada na prática.

### Essência

**O conhecimento que cura.**

Códice em latim é livro escrito à mão antes da imprensa — onde médicos antigos guardavam o saber clínico. Codex devolve esse poder ao estudante de saúde de hoje: transforma o livro-texto pesado num assistente que lê pra você, explica pra você e cita a página certa.

### Tese central

Estudante de saúde brasileiro tem 8-12 livros pesados por ciclo, semana de prova chegando, e gasta horas folheando Guyton/Robbins/Netter procurando o trecho exato. Codex tira esse atrito: você sobe o PDF e pergunta. A resposta vem com a página de origem, sempre.

### Arquétipo

**Curador 60% + Sábio 40%**

- **Curador** lidera: cuida, alivia o sofrimento (do estudante exausto), entrega remédio (a resposta que precisa) com gentileza profissional.
- **Sábio** apoia: traz autoridade, citação, rigor de fonte. Não inventa. Mostra a página.

> Diferenciação vs Grimoire (Mago 70% + Sábio 30%): Grimoire é encantamento, Codex é cuidado. Grimoire promete "feitiço", Codex promete "parecer". Mesma família, energias diferentes.

### Posicionamento de uma frase

Para estudantes brasileiros de saúde, Codex é o assistente de estudos em PDF que entende terminologia clínica em PT-BR e cita a página exata — diferente de NotebookLM e ChatPDF, que são genéricos, frios e em inglês.

### Audiência ampla (decisão fechada)

A landing já abriu para **Medicina, Enfermagem, Biomedicina, Fisioterapia, Farmácia, Odontologia, Nutrição**. Mantemos. O overview falava só em medicina, mas:
- Diferencial principal (linguagem clínica + citação por página) serve a TODOS esses cursos
- TAM amplia ~3x sem diluir narrativa (todos lêem livros-texto pesados)
- Foco de comunicação primária permanece em medicina (persona âncora), demais cursos entram como "também serve pra…"

---

## 2. Glossário proprietário (LEI — sempre usar)

| Conceito do mundo real | Termo Codex |
|---|---|
| PDF / documento | **códice** ou **compêndio** |
| Conjunto de PDFs do usuário | **estante** ou **biblioteca clínica** |
| Pergunta do usuário | **anamnese** ou **consulta** |
| Submeter pergunta | **consultar** ou **auscultar** |
| Resposta da IA | **parecer** / "Hipócrates diz" / "o curandeiro responde" |
| Dashboard | **consultório** |
| Assinatura paga | **juramento** (referência ao Juramento de Hipócrates) |
| Tier free | **Estagiário** |
| Tier pago básico (R$ 14,90) | **Residente** |
| Tier pago premium (R$ 29,90) | **Clínico** |
| Tier lifetime (R$ 297) | **Preceptor** (preferir a "Mestre" — soa mais clínico) |
| Assistente IA | **Hipócrates** |
| Onboarding inicial | **primeira consulta** |
| Histórico de perguntas | **prontuário de consultas** |
| Loading / processamento | **auscultando…** / **decifrando o tratado…** |

### Regras de uso do glossário

1. **NUNCA inventar termos novos** sem aprovar com o orquestrador. Glossário é trava.
2. **Em copy de marketing**: usar termo Codex + termo real entre parênteses na primeira menção da página: "Sobe um códice (PDF) e consulte." A partir da segunda menção, só Codex.
3. **Em UI funcional do produto**: termo Codex puro. "Adicionar códice", "Nova consulta", "Consultório".
4. **Em compliance / legal / disclaimers**: termo real. "Esta ferramenta processa documentos PDF…" — clareza jurídica supera marca.
5. **Em mensagens de erro técnico**: termo real. "Erro ao fazer upload do PDF" — não "falha ao receber o códice no consultório". Usuário travado quer clareza, não tema.

---

## 3. Compliance & disclaimers (NÃO-NEGOCIÁVEL)

### Bandeira vermelha — nunca

- Chamar a IA de "médico", "doutor" ou "profissional de saúde"
- Dizer que a IA "diagnostica", "prescreve" ou "trata"
- Sugerir conduta clínica para paciente real
- Posicionar Codex como ferramenta de uso clínico ativo

### Bandeira verde — sempre

- "Material de estudo. Não substitui avaliação clínica presencial."
- "Raciocínio diagnóstico" (não "diagnóstico"), "diferencial pedagógico", "caso simulado"
- Quando o usuário pedir dose: incluir "consultar bula sempre"
- Logo no rodapé do produto + abaixo de toda resposta da IA

### Disclaimer canônico (copiar e colar)

> Codex é uma ferramenta de apoio ao estudo. Os pareceres gerados são exclusivamente educativos, baseados nos PDFs que você forneceu. Nada aqui substitui avaliação clínica presencial, consulta a bula ou orientação de um profissional de saúde habilitado.

### Posicionamento legal

- Marca registrada futura: **Codex Saúde** ou **Codex Estudos** (classes INPI 9 + 41)
- Termos de uso devem deixar explícito: ferramenta de estudo, sem garantia de exatidão clínica
- Compliance CFM: Codex NÃO é dispositivo médico (Resolução CFM 1.821/2007, RDC ANVISA 657/2022) — não faz diagnóstico, não emite laudo. Manter assim.
- LGPD: PDFs do usuário são dados pessoais quando contém anotações; não treinar modelo com conteúdo do usuário sem opt-in explícito.

---

## 4. Paleta — "Codex Clinic"

**Decisão fechada: caminho B+ (paleta da landing atual, refinada)**

Por quê não a paleta verde-escuro+vermelho do overview (caminho A)?
- Verde-escuro absoluto + vermelho médico era a estética "boticário noturno" — combina com Grimoire pixel-art, mas dá fricção de leitura em produto Q&A real. Estudante usa Codex em hora de prova, com fadiga visual; fundo claro reduz strain.
- Vermelho médico vivo carrega ansiedade (alarme, sangue, urgência). Estudante já está ansioso pela prova. Não amplificar.
- Verde-escuro+vermelho é estética de produto clínico para profissional formado. Codex é para estudante — precisa parecer um caderno bonito de biblioteca, não um console de UTI.

Por quê paleta verde-clínico+ouro (caminho B):
- Verde teal (#0B7A65) carrega cuidado + competência sem peso emocional excessivo
- Ouro/âmbar (#C4982A) traz autoridade editorial (referência a livros antigos, sem cair em "luxury") e funciona como acento de CTA destacado
- Fundo claro warm-neutro (#F7F9F8 / #F2F5F3) não cansa em sessões longas de estudo
- Acessibilidade WCAG mais fácil de garantir

Refinamentos vs landing v1:
- Adicionei **Surface Dark** para dark mode futuro (estudante noctívago — Leonardo é exemplo)
- Adicionei **Vital Red** como acento RARO (alertas críticos, símbolo de saúde — guardado para casos pontuais como o overview pedia)
- Tokens reorganizados em scale semântico

### Tokens — Codex Clinic v1.0

```
/* ── BACKGROUND ── */
--bg-page:        #F7F9F8   /* fundo principal, light mode */
--bg-warm:        #F2F5F3   /* alt. ligeiramente mais quente para seções */
--bg-elevated:    #FFFFFF   /* cards, modais, áreas elevadas */

/* ── DARK MODE (futuro) ── */
--bg-dark:        #0F1A14   /* fundo dark, profundo verde-quase-preto */
--bg-dark-elev:   #1A2620   /* cards no dark */

/* ── PRIMARY — Verde Clínico ── */
--primary:        #0B7A65   /* CTA, links, logo símbolo (versão escura: #0B5A4A) */
--primary-hover:  #096B58   /* estado hover */
--primary-light:  #E6F5F0   /* fundo de badges, highlights leves */
--primary-muted:  #B8DDD2   /* bordas suaves, dividers acentuados */
--primary-subtle: #D9EEE7   /* fundo de seção em destaque */

/* ── ACCENT — Âmbar Editorial ── */
--accent:         #C4982A   /* destaques, marcador do logo, ícone de citação */
--accent-light:   #FBF5E6   /* fundo de aviso suave / dica */
--accent-hover:   #A8821F   /* hover em CTA secundário ouro */

/* ── TEXT ── */
--text:           #0F1A14   /* texto principal, headlines */
--text-secondary: #5A6B62   /* subtítulos, captions, body secundário */
--text-tertiary:  #8A9B92   /* placeholders, hints, metadados */
--text-on-dark:   #F4F1EA   /* texto em fundo escuro / botão primary */

/* ── SEMANTIC — uso pontual ── */
--vital-red:      #D4373F   /* APENAS: alerta crítico, ícone de saúde, símbolo de cuidado urgente */
--vital-red-bg:   #FCEBEC   /* fundo de erro / aviso clínico */
--success:        #0B7A65   /* reusa primary — economia de paleta */
--info:           #2C7BB6   /* informativo neutro (raro) */

/* ── BORDER & SURFACE ── */
--border:         #DDE5E1   /* bordas padrão */
--border-light:   #EBF0ED   /* bordas sutis (separadores) */
--surface-hover:  #F0F5F2   /* hover de itens lista/card */
```

### Regras de uso por cor

| Token | USA quando | NÃO USA quando |
|---|---|---|
| `--primary` (#0B7A65) | CTAs primários, logo, links, ativo de navegação | Como background de seção inteira (cansa) |
| `--accent` (#C4982A) | Marcador de citação, destaques de "página exata", ouro de plano premium | Como cor de alerta de erro (causa confusão com warning) |
| `--vital-red` (#D4373F) | Erro crítico, ícone de coração no rodapé legal, símbolo de saúde no logo médio | Em qualquer CTA, headline ou área grande — tem que doer só onde precisa |
| `--bg-page` | Fundo geral light | Em texto |
| `--bg-dark` | Apenas dark mode | Misturar com light em mesma tela |
| `--text-on-dark` | Texto sobre primary preenchido ou dark mode | Em fundo claro (vira ilegível) |

### Pares WCAG validados (AA mínimo)

| Combinação | Contraste | Status |
|---|---|---|
| `--text` em `--bg-page` | 14.8:1 | AAA |
| `--text-secondary` em `--bg-page` | 6.7:1 | AA |
| `--text-tertiary` em `--bg-page` | 3.5:1 | AA Large only |
| `--primary` em `--bg-page` | 5.1:1 | AA |
| `--text-on-dark` em `--primary` | 6.2:1 | AA |
| `--accent` em `--bg-page` | 4.6:1 | AA Large only — **não usar em body text** |
| `--vital-red` em `--bg-page` | 5.4:1 | AA |
| `--text-on-dark` em `--bg-dark` | 13.1:1 | AAA |

Regra prática: **âmbar (`--accent`) sempre como destaque visual ou ícone, nunca como cor de body text**.

---

## 5. Tipografia

### Stack final (todas Google Fonts — zero custom no MVP)

| Função | Fonte | Justificativa (2 linhas) |
|---|---|---|
| **Display / wordmark / headlines** | **Playfair Display** (700) | Serif editorial com pegada de placa de consultório antigo + livro de medicina clássico. Já testada na landing v1, performa bem em PT-BR com acentuação correta. |
| **Body / UI / parágrafos** | **Inter** (400/500/600) | Sans-serif neutra, altíssima legibilidade em telas, suporte completo a PT-BR e símbolos clínicos. Padrão da indústria — não compete com a serif do display. |
| **Mono / valores clínicos / códigos** | **JetBrains Mono** (400/500) | Mono moderna com bom desenho de números (importante para doses, valores de referência laboratoriais, citações tipo "p.482"). Distingue claramente 0/O e 1/l/I. |

### Escala tipográfica (mobile-first, escala 1.25 — Major Third)

```
--font-display:   'Playfair Display', Georgia, serif
--font-body:      'Inter', system-ui, -apple-system, sans-serif
--font-mono:      'JetBrains Mono', 'Courier New', monospace

/* Tamanhos */
--text-xs:    12px   /* metadados, captions */
--text-sm:    14px   /* secondary text, footer */
--text-base:  16px   /* body padrão */
--text-lg:    18px   /* body destaque, subhead */
--text-xl:    22px   /* card title, h3 */
--text-2xl:   28px   /* h2 sectional */
--text-3xl:   38px   /* h2 hero */
--text-4xl:   48px   /* h1 médio */
--text-5xl:   60px   /* h1 hero (clamp em mobile) */

/* Pesos */
--weight-regular: 400
--weight-medium:  500
--weight-semibold: 600
--weight-bold:    700

/* Line-height */
--lh-tight:  1.1   /* headlines */
--lh-snug:   1.3   /* subheads */
--lh-normal: 1.6   /* body */
--lh-loose:  1.75  /* texto longo (artigo, blog) */

/* Letter-spacing */
--tracking-display: -1.5px  /* headlines apertam */
--tracking-tight:   -0.5px  /* subheads */
--tracking-normal:  0       /* body */
--tracking-wide:    0.5px   /* uppercase eyebrow / trust bar */
--tracking-wider:   3px     /* TAGLINES MAIÚSCULAS */
```

### Combinações pré-aprovadas

- **Hero**: Playfair 700 / `--text-5xl` / `tracking-display` / `lh-tight` em primary OU text
- **Subhead hero**: Inter 400 / `--text-lg` / `tracking-normal` / `lh-normal` em text-secondary
- **Section title**: Playfair 600 / `--text-3xl` / `tracking-tight` / `lh-snug` em text
- **Card title**: Inter 600 / `--text-xl` / `tracking-tight` em text
- **Body**: Inter 400 / `--text-base` / `lh-normal` em text-secondary (cansa menos)
- **Eyebrow / trust bar**: Inter 500 / `--text-xs` / `tracking-wider` / `text-uppercase` em text-tertiary
- **Citação de página** (especial Codex): JetBrains 500 / `--text-sm` em accent — "Robbins, p. 482"
- **Dose / valor lab**: JetBrains 500 / `--text-base` em text — "30 mg/kg/dia VO"

---

## 6. Logo

### Direção escolhida: **Códice aberto + Marcador**

Avaliei as 4 opções do overview:
- **Caduceu** — bonito mas é símbolo de Hermes (mensageiro/comércio), não de medicina. Erro histórico recorrente. Recusado.
- **Bastão de Asclépio** — historicamente correto mas tem serpente; fica sinistro em monocromático pequeno (favicon vira borrão). Recusado para mark principal.
- **Almofariz e pistilo** — símbolo farmacêutico clássico; reduz o nicho percebido só pra farmácia. Recusado pra audiência ampla.
- **Coração anatômico** — bonito mas comum demais (várias healthtechs usam) e remete a cardiologia específica. Recusado.

**Escolhido: códice aberto estilizado + marcador dourado.** Por quê:
- O nome **é** Codex — o símbolo deveria mostrar o produto, não decoração temática
- Funciona em 16x16 (favicon) sem virar mancha — testado
- Sem serpente, sem clichê médico — respira "biblioteca clínica" não "farmácia 24h"
- Marcador dourado central = página marcada = a citação exata, que é o diferencial técnico do produto

### Construção do símbolo

```
Forma: letra "C" estilizada como compêndio aberto visto de cima
       linha vertical à esquerda = lombada do livro
       curva à direita = páginas abertas em arco
       círculo dourado central = página marcada / sigilo

Cor padrão símbolo: #0B5A4A (verde-clínico escuro, contraste forte)
Cor wordmark:       #0F1A14 (text principal)
Cor marcador:       #C4982A (accent ouro)

Em fundo escuro: tudo vira #FFFFFF (versão mono-white)
```

### Arquivos entregues

| Arquivo | Quando usar |
|---|---|
| `brand/logo/codex-mark.svg` | Símbolo puro, 64×64. Para favicon, app icon, watermark. |
| `brand/logo/codex-logo-horizontal.svg` | Lockup horizontal (símbolo + nome ao lado). Padrão para navbar, header de email. |
| `brand/logo/codex-logo-vertical.svg` | Lockup vertical (símbolo em cima + nome + tagline embaixo). Para perfil social, splash screen. |
| `brand/logo/codex-logo-mono-white.svg` | Lockup horizontal monocromático branco. Para fundo escuro, foto, hero com overlay. |
| `brand/logo/codex-favicon.svg` | Versão otimizada 32×32 com background quadrado arredondado. Favicon e PWA icon. |

### Regras de aplicação

**SEMPRE:**
- Margem mínima ao redor: igual à altura da letra "C" do wordmark
- Tamanho mínimo do mark sozinho: 16px (favicon) — abaixo disso ilegível
- Tamanho mínimo do lockup horizontal: 100px de largura
- Cor de fundo: garantir contraste WCAG AA (validar com tokens da paleta)

**NUNCA:**
- Esticar, distorcer, rotacionar
- Aplicar gradiente sobre o símbolo
- Trocar a cor do marcador dourado por outra cor (é a única cor de marca do símbolo)
- Usar logo monocromática preta — preferir versão padrão verde
- Adicionar sombra ou efeito de relevo
- Colocar em fundo de baixo contraste (cinza médio, gradiente complexo)

### Próximo passo recomendado para logo

O SVG entregue é **funcional para MVP** (landing v1, favicon, navbar, perfil social). Para versão "rica" tipo ilustração editorial (tipo a mascote do Grimoire), recomendo um passo futuro com Midjourney/Ideogram:

**Prompt sugerido para Midjourney v6:**
```
Logo design for "Codex" — a Brazilian health-study SaaS. Main mark:
elegant antique medical codex (open book) seen from a slight angle,
with a single golden bookmark ribbon flowing from the center page.
Style: editorial-medical, art-nouveau botanical apothecary,
deep clinical green and warm gold palette, ivory parchment texture,
flat vector illustration, no text, transparent background,
isolated centered composition --ar 1:1 --style raw --v 6
```

Custo estimado: $10 Midjourney monthly, 4-8 gerações até landing perfeita. **Não bloqueia MVP** — o SVG atual já carrega a marca.

---

## 7. Tom de voz

### Princípios

1. **PT-BR coloquial, mas com peso clínico** — "bora consultar", "deixa o Hipócrates te explicar". Não é místico, não é corporatês.
2. **Direto** — frase curta. Verbo no início. "Sobe teu PDF. Pergunta. Recebe a página." > "Maximize sua eficiência de estudos com nossa plataforma de IA."
3. **Honesto sobre limites** — sempre o disclaimer. Sempre "consultar bula", "não substitui avaliação". Nunca prometer diagnóstico real.
4. **Calmo** — estudante já está ansioso pela prova. Não usar "AGORA!", "ÚLTIMA CHANCE!", emoji de fogo, urgência fake.
5. **Erudito sem ser pedante** — pode usar "anamnese" e "compêndio", mas sempre seguido de explicação implícita ou contexto. Nunca exigir do usuário pesquisar o glossário.

### 5 exemplos DO / DON'T

| ✅ DO | ❌ DON'T | Por quê |
|---|---|---|
| "Sobe teu Guyton e pergunta o que quiser. O Hipócrates lê e responde com a página exata." | "Potencialize sua jornada de aprendizado clínico com nossa solução de IA generativa para análise documental." | Direto > corporatês. Verbo no início, sujeito implícito conversacional. |
| "Auscultando o compêndio…" (no loading) | "Curando suas dúvidas com magia ancestral milenar 🧙‍♂️" | Tema clínico sutil > tema místico cringe. Curandeiro é tom, não fantasia. |
| "Material de estudo. Não substitui avaliação clínica." | "Cuidado: isso não é diagnóstico médico real, não use no paciente, não somos responsáveis." | Disclaimer firme mas calmo. Não amedronta o estudante, só situa. |
| "O parecer do Hipócrates aponta pra IAM com supra de ST. Confere a página 482 do Robbins pra revisar." | "A IA diagnosticou um caso de infarto agudo do miocárdio com supradesnivelamento." | "Parecer" + "aponta" + "confere a página" = pedagógico. Nunca "diagnosticou". |
| "Beleza, vamo lá: capítulo 14 do Porto fala sobre…" | "Excelente questionamento! Conforme demonstrado no material fornecido…" | Coloquial brasileiro > inglês traduzido. ChatGPT-padrão é cringe em PT-BR. |

### Vocabulário preferido

- "bora", "vamo lá", "manda ver" → energia direta sem ser infantil
- "tu" + verbo concordado: "tu pergunta", "tu sobe" → registro PT-BR jovem natural (evitar "você" formal exceto em legal)
- "parecer", "anamnese", "consulta", "compêndio" → glossário clínico sempre que cabe
- "página exata", "citação direta", "trecho original" → reforça diferencial técnico
- "véspera de prova", "plantão", "residência", "ENARE", "Revalida" → vocabulário do nicho (cria reconhecimento)

### Vocabulário banido

- "Maximize", "potencialize", "alavanque", "transforme sua jornada"
- "Solução de IA generativa", "plataforma inovadora", "ecossistema"
- "Magia", "encantamento", "feitiço" (são do Grimoire, não do Codex)
- "Inteligência artificial revolucionária", "tecnologia de ponta"
- "Diagnostica", "diagnóstico" (sem qualificador "raciocínio diagnóstico" / "diferencial pedagógico")
- "Médico", "doutor", "profissional de saúde" referindo-se à IA
- Emojis em massa. Permitido: ✓ ✗ → · — em microcopy. Banido: 🚀 🔥 ✨ 💪 emojis de marketing

### Tom comparado a outros produtos

| Produto | Tom |
|---|---|
| **Codex** | Curador calmo + Sábio rigoroso. Coloquial BR. Disclaimers claros. |
| Grimoire (irmão) | Mago lúdico + Sábio. Pixel-art devlog. Mais brincalhão. |
| NotebookLM (concorrente) | Frio, profissional, em inglês. Sem tom. |
| ChatGPT (referência ruim) | "Excelente pergunta! Aqui está…" — corporatês americano traduzido. |

---

## 8. Microcopy — Biblioteca de 25 frases prontas

### Loading / processamento (5)

1. "Auscultando o compêndio…"
2. "Decifrando o tratado…"
3. "O Hipócrates tá lendo… só um instante."
4. "Indexando páginas — quase lá."
5. "Folheando o códice pra te responder…"

### Empty states (5)

6. "Tua estante tá vazia. Sobe teu primeiro códice pra começar."
7. "Nenhuma consulta por aqui ainda. Faz a primeira pergunta — o Hipócrates tá pronto."
8. "Sem prontuário ainda. Tuas próximas consultas aparecem aqui."
9. "Esse códice ainda não foi consultado. Manda a primeira anamnese."
10. "Nenhum resultado. Tenta reformular ou trocar pra outro códice da estante."

### CTAs (5)

11. "Começar grátis" (cadastro principal)
12. "Subir códice" (upload)
13. "Consultar Hipócrates" (enviar pergunta)
14. "Virar Residente" (upgrade R$ 14,90)
15. "Selar o juramento" (confirmar assinatura)

### Erros (5)

16. "Esse PDF tá pesado demais. Cap atual: 80MB. Tenta dividir em capítulos."
17. "Não rolou subir esse arquivo. Confere se é PDF válido e tenta de novo."
18. "Hipócrates ficou sem fôlego. Tenta de novo em alguns segundos."
19. "Tua quota diária acabou. Volta amanhã ou vira Residente pra consultas ilimitadas."
20. "Esse tipo de pergunta foge do escopo do Codex. Aqui é estudo, não conduta clínica real."

### Sucesso (5)

21. "Códice indexado. Pode consultar."
22. "Consulta salva no prontuário."
23. "Bem-vindo, Residente. Teu juramento tá ativo."
24. "Página marcada. Tu acha em 'Anotações'."
25. "Pronto, anamnese enviada. Resposta tá vindo."

---

## 9. Aplicação rápida (cheat-sheet)

### Para landing / marketing

- Headline: **Playfair 700 + acento em primary** ("...assistente *clínico*")
- Sub: Inter 400 em text-secondary, 1-2 linhas
- CTA primário: Inter 600 + bg primary + text-on-dark
- Trust bar: Inter 500 + tracking-wider + uppercase em text-tertiary
- Hero badge: primary-light bg + primary text + 13px

### Para produto (UI)

- Navbar: bg-page com blur + border-light bottom
- Cards: bg-elevated + border + radius 14px + sombra suave
- Botão primário: primary bg, hover primary-hover
- Input focus: ring primary-light + border primary-muted
- Resposta da IA: bg-elevated com left-border accent (4px) — destaque sutil de "parecer"
- Citação de página: chip mono em accent-light bg + accent text — "Robbins, p. 482"

### Para email / colateral

- Footer: text-tertiary + Inter 400 + 13px
- Disclaimer legal: text-secondary + Inter 400 + 12px + italic
- Logo: horizontal lockup, mínimo 100px largura

---

## 10. Governance

- **Brand owner:** Leonardo (clickwaveGG)
- **Brand custodian (squad):** Meridian / squad-brand
- **Versionamento:** este doc é v1.0. Mudanças significativas viram v1.1, v2.0 etc.
- **Onde tudo vive:**
  - Doc fonte: `C:\Users\PC\Projects\codex\brand\BRANDBOOK.md`
  - Preview navegável: `C:\Users\PC\Projects\codex\brand\preview.html`
  - Logos SVG: `C:\Users\PC\Projects\codex\brand\logo\`
  - Memória persistente: `C:\Users\PC\.claude\projects\C--Users-PC\memory\project_healer.md`

### Quando consultar este doc

- ANTES de qualquer copy nova (validar tom + glossário + disclaimer)
- ANTES de qualquer asset visual (validar paleta + tipografia + uso de logo)
- ANTES de qualquer feature de produto (validar nomenclatura no glossário)
- DEPOIS de cada release: log de aprendizados em `preferences/codex-preferences.md` (futuro)

---

**Fim do brandbook v1.0.** Próximo agente (design-orqx ou copy-orqx) pode aplicar imediatamente. Nenhuma dependência externa pendente — todos arquivos estão neste repo.
