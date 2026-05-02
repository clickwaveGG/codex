# Codex — Instagram Positioning v1.0

**Documento:** posicionamento da conta @codex no Instagram
**Versão:** 2026-05-02
**Autor:** Catalyst (squad-growth)
**Estado:** pronto pra criar conta e publicar

---

## 1. Handle (DECISÃO)

**Handle escolhido: `@codex.saude`**

Fallbacks na ordem (caso ocupado):
1. `@codex.saude` — RECOMENDADO. Sinaliza categoria direto. SEO interno do IG bate quando alguém busca "saúde". Pareia com possível domínio `codexsaude.com.br`.
2. `@usecodex.br` — fallback 1. Padrão de SaaS BR (use+marca+br). Bom se Leonardo quiser deixar `@codex.saude` aberto pro futuro.
3. `@codex.app` — fallback 2. Pareia com domínio `codex.app` se ele for comprado. Risco: parece app genérico, sem pista de saúde.

Rationale resumido:
- `@codex` puro com certeza não está livre (conta legacy)
- `@codex.saude` é o que faz mais sentido pro nicho — estudante de medicina que busca por "codex" + "saúde" cai direto
- Evitar números no handle (`@codex2026` etc) — vira cara de bot

**Ação imediata:** Leonardo verifica disponibilidade dos 3 e cria conta.

---

## 2. Bio (DECISÃO — 150 chars)

```
Hipócrates de bolso pro estudante de saúde 🩺
Sobe teu Robbins, pergunta, recebe a página exata.
↓ entra na lista de espera
```

**Char count:** 144 (cabe nos 150).

Variantes A/B testáveis nas semanas 3-4:
- **B (mais técnico):** "Chat com teu PDF de medicina. Cita a página. PT-BR. 🩺 ↓ entra na lista de espera"
- **C (mais agressivo):** "Decifrei Robbins, Guyton e Porto pra ti. ↓ vira beta-tester antes de todo mundo"

**Link na bio:** landing com captura de email (waitlist) — ver IG-FUNNEL.md.

URL recomendada: usar `bio.link/codexsaude` ou `linktr.ee` SOMENTE se precisar agregar (waitlist + grupo WhatsApp + TikTok). Se for só a waitlist, link direto pra landing.

**Decisão:** começar com link direto pra landing (`/lista-espera`). Migra pra bio.link só se precisar de 3+ destinos.

---

## 3. Foto de perfil (DECISÃO)

**Usar:** `brand/logo/codex-favicon.svg` exportado em PNG 1080×1080 com fundo `#F7F9F8` (bg-page do brandbook).

Por quê o favicon e não o horizontal:
- Foto de perfil do IG é círculo de ~110px na timeline. Logo horizontal vira mancha ilegível.
- O favicon já tem o quadrado arredondado com símbolo centralizado — perfeito pro crop circular.
- Símbolo verde (#0B5A4A) + marcador dourado (#C4982A) sobre fundo claro = contraste bom em qualquer tema do IG.

**Alternativa secundária:** se Leonardo gerar uma versão "rica" via Midjourney (prompt no brandbook §6), trocar pelo PNG ilustrado quando estiver pronto. Não bloqueia o lançamento da conta.

**Foto de capa do Reels (cover):** templates Canva com fundo `#0F1A14` (dark elev) + Playfair branco. Ver IG-CONTENT-STRATEGY.md §5.

---

## 4. Highlights iniciais (DECISÃO — 5 covers)

5 highlights na ordem de leitura (esquerda pra direita):

| Highlight | Cover | Conteúdo |
|---|---|---|
| **🩺 manifesto** | Símbolo Codex grande sobre `#0F1A14` | 3-5 stories explicando o quê é o Codex, pra quem, o quê resolve. Pinned. |
| **📖 como funciona** | Ícone de PDF + seta + chat | Demo passo a passo: subir códice → pergunta → resposta com citação |
| **⚡ bastidores** | Tela de código sobre fundo dark | Print do PRD, do brandbook, do schema, primeiras telas do app |
| **💬 dúvidas** | Balão de chat verde | FAQs respondidas: "vai ser pago?", "quando lança?", "funciona com Robbins?", etc |
| **🎫 lista de espera** | Marcador dourado + texto "BETA" | CTA permanente pra waitlist + status atual ("já temos X inscritos") |

Cover style padrão (template Canva único):
- Fundo `#0F1A14` (dark elev) ou `#F2F5F3` (bg-warm) alternando
- Emoji ou ícone do brandbook centralizado
- 1 palavra abaixo em Inter 600 + tracking-wider + uppercase + branco/text
- Borda interna sutil 2px primary (#0B7A65)

---

## 5. Tom de voz aplicado a Instagram

Aplicação direta do brandbook §7 ao formato IG:

### Princípios IG-específicos (camada extra do tom geral)

1. **Primeira linha do Reel/Carrossel é HOOK ou nada** — perde o usuário em 1 segundo. Nada de "Olá pessoal, hoje vou falar sobre...". Direto: "Tu já passou madrugada folheando Robbins atrás de um trecho?"

2. **Tu, não você** — o IG do Codex fala "tu" coloquial brasileiro. "Você" só em legenda formal de disclaimer/parceria/imprensa.

3. **Frase curta. Ponto. Outra frase.** — feed do IG não tolera parágrafo. Máximo 2 linhas de raciocínio antes de quebrar com vírgula, ponto ou emoji.

4. **Glossário aplicado mas sem exigir conhecimento prévio** — "códice" pode aparecer, mas na primeira menção do post tem que vir contexto: "subir um códice (teu PDF do Robbins)". Não fazer o usuário pesquisar.

5. **Coloquial, não infantil** — "bora", "manda ver", "vamo lá" OK. "kkkkk", "bb", "hihi" não. Estudante de medicina é jovem mas leva o estudo a sério; tom precisa respeitar isso.

6. **Emoji como pontuação, não enfeite** — 🩺 📖 ⚡ 💊 ↓ → ✓ ✗ podem aparecer. 🚀🔥✨💪 banidos (brandbook §7).

7. **Disclaimer CFM curto em alguns posts** — quando o post mencionar conduta clínica simulada ou dose, fechar com "*material de estudo. não substitui avaliação clínica.*" em itálico no fim. Não em todo post — vira ruído.

### 3 frases-modelo pra IG

- **Hook tipo dor:** "Tu sabe a sensação de bater o livro fechado às 3 da manhã sem achar o trecho?"
- **Hook tipo demo:** "Olha o que acontece quando tu pede pro Hipócrates explicar fisiopato de IC esquerda 👇"
- **Hook tipo bastidores:** "Estou construindo um chat com PDF pra estudante de medicina. Hoje terminei o schema."

---

## 6. O que esta conta É

1. **Construção pública (build in public) de um produto pra estudante de saúde brasileiro** — Leonardo mostra bastidores reais, sem maquiagem. Print de Cursor, schema do Supabase, conversa com a IA, decisão de paleta. Cria identificação com quem também está construindo coisa.

2. **Mini-aulas práticas usando o produto** — cada Reel/carrossel resolve uma dúvida real de matéria do ciclo (fisiologia cardiovascular, farmacologia básica, anatomia palpatória) usando o Codex como ferramenta. O produto vira o herói implícito.

3. **Pipeline de waitlist** — toda peça leva a "entra na lista de espera". O IG não é vitrine de marca, é máquina de captura de email pré-lançamento.

---

## 7. O que esta conta NÃO é

1. **Não é "guru de medicina dando dica"** — Leonardo não é médico nem estudante de medicina. Postura é de criador de ferramenta, não de professor. "Construí isso pra TE ajudar" > "Olha como eu sou expert em medicina".

2. **Não é blog de notícias da área** — não vamos comentar polêmica do CFM, descoberta científica do mês, novo medicamento aprovado. Foco é estudo + produto.

3. **Não é meme account** — humor sutil tudo bem ("o Hipócrates é tipo aquele R3 que sabe tudo mas não te trata mal"), mas não viramos perfil de meme de medicina (mercado saturado, baixa conversão pra waitlist).

---

## 8. Marcos públicos da conta (próximos 30 dias)

| Marco | Quando | Como anunciar |
|---|---|---|
| Conta criada + primeiros 10 posts | Dia 1-7 | Highlight 🩺 manifesto + 1 carrossel "o quê é o Codex" pinado |
| Landing waitlist no ar | Dia 8-10 | 1 reel anunciando + 1 carrossel "como entra na lista" + story diário 1 semana |
| Primeira live | Dia 18-21 | Anúncio 5 dias antes + lembretes 24h e 1h antes |
| Beta privado abre | Dia 25-30 | "30 vagas pros primeiros da lista" — gera FOMO real |

---

**Fim do IG-POSITIONING.md.** Próximo: `IG-CONTENT-STRATEGY.md`.
