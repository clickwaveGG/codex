# PRD — MVP Healer (codinome Codex)

**Versão:** 1.0 · 2026-05-02
**Owner produto:** Leonardo (clickwaveGG)
**Status:** Aprovado para build (FASE 1 inicia imediatamente após esse doc)
**Codinome interno:** Codex · **Nome público:** placeholder "Healer" (a ser substituído pelo brandbook)

---

## 1. Visão e tese

Healer é o **consultório de bolso do estudante de medicina BR**: o usuário sobe seus códices (livros-texto, atlas, diretrizes, apostilas) e conversa com o Hipócrates — assistente IA com peso clínico — para resumir, explicar fisiopato, gerar quizzes estilo Revalida/ENARE, simular casos e diferenciar doenças, sempre com citação de página. **Tese:** "O conhecimento que cura" — transformar leitura passiva de 1500 páginas de Robbins em decisão de estudo ativa, em PT-BR coloquial mas com peso técnico, por um preço que cabe no bolso de estudante (R$ 14,90/mês vs R$ 100+ dos gringos).

---

## 2. Personas

### Persona primária — Marina, 22, M4 USP
- **Cenário:** quarta-feira, 23h, prova de Cardio sexta. Tem Porto Cardiologia (1200pp) + apostila do CA + 3 artigos. Não vai ler tudo.
- **Job to be done:** "Me explica fisiopato da insuficiência cardíaca esquerda, com mecanismo, em linguagem que eu absorva em 5min, e me dá 5 questões pra eu testar."
- **Frustração com alternativas:** ChatGPT alucina dose; NotebookLM é em inglês frio; ChatPDF não cita página direito; resumão de cursinho custa R$ 200/mês.
- **O que faz Marina pagar R$ 14,90:** poder upar 15 códices da matéria, ter `/quizar` no estilo prova BR, e ter resposta com link "ver na pág. 437 do Porto" pra confiar.

### Persona secundária — Pedro, 27, R1 Clínica Médica HC
- **Cenário:** plantão de 36h, paciente novo na enfermaria com sintoma raro. Tem Harrison no celular mas não dá tempo de folhear.
- **Job to be done:** "Diferencial de hiponatremia hipotônica euvolêmica — me dá tabela rápida, com critérios e dose dos exames pra pedir."
- **O que faz Pedro pagar R$ 29,90 (Clínico):** Sonnet 4.5 mais inteligente, 1000 consultas/dia, códices ilimitados (todo o livro de cada especialidade que rotacionou).

> **Persona out-of-scope MVP:** profissional formado em prática clínica real (esse é OpenEvidence/UpToDate, não nosso jogo). Manter aviso CFM-friendly explícito.

---

## 3. Escopo MVP vs out-of-scope

### Dentro do MVP (build FASE 1-4)
- Auth Google OAuth via Supabase (sem email/senha — reduz suporte)
- Upload PDF (cap 80MB, 1500pp), parsing assíncrono com status visível ("Decifrando o tratado…")
- Consultório (dashboard) com grid de códices, capa procedural por categoria, busca textual local
- Chat com Hipócrates: textarea + 6 slash-commands + streaming SSE + citação clicável de página
- Histórico de consultas por códice
- 4 tiers (Estagiário/Residente/Clínico/Mestre) com caps duros + upgrade flow Asaas Pix
- Disclaimers CFM em footer + 1ª tela do chat + cada resposta da IA
- Termos + Privacidade (esqueleto LGPD-saúde)
- Observability mínima: PostHog eventos, Sentry erros, Helicone custo LLM

### Fora do MVP (matar agora, considerar pós-launch)
- Login email/senha · Magic link · Apple/Microsoft OAuth
- Multi-códice query (perguntar em todos de uma vez)
- Highlight + nota dentro do PDF
- Export pra Anki / Notion
- Modo apresentação (slides)
- Banco de imagens médicas indexáveis (raio-X, RNM, lâminas)
- Modo prova cronometrado
- App mobile nativo (web responsivo basta)
- Compartilhamento de códice entre usuários
- Colaboração / workspaces de turma
- OCR de PDF escaneado (forçar PDFs com texto — exibir erro educado)
- Suporte a outros idiomas além de PT-BR
- Versionamento de códice (re-upload sobrescreve)
- Gestão de equipe (B2B2C com cursinhos é V2)

### Decisão crítica: out-of-scope mesmo se "fácil"
- Editor de capa do códice (capa procedural baseada em hash do título — zero customização no MVP)
- Reordenar códices (ordem fixa: data de upload desc)
- Renomear conversa (cada conversa = nome auto-gerado pela 1ª query truncada em 60 chars)

---

## 4. Core loop (5 frases)

1. **Subo um códice** (Robbins, Porto, apostila do CA) e o sistema decifra em background.
2. **Abro o códice no consultório** e vejo placeholder convidando "Pergunta pro Hipócrates sobre teu material…".
3. **Faço uma anamnese** com slash-command (`/explicar fisiopato IC esquerda`) e o Hipócrates responde com streaming, citando "Porto Cardio pp. 437-441".
4. **Repito** — encadeio mais consultas no mesmo códice (resumir capítulo, gerar quiz, simular caso) e o histórico fica salvo.
5. **Bato no cap diário** (Estagiário 50/dia, Residente 300/dia) → paywall aparece com upgrade Pix em 2 cliques.

---

## 5. Métricas de sucesso

### North star
**Consultas auscultadas / usuário ativo / semana** (proxy de valor real entregue, não login)
- Target Beta: ≥ 25 consultas/usuário/semana
- Target lançamento: ≥ 40

### Ativação (D0)
- Definição: usuário fez login + subiu 1 códice + completou ≥ 3 consultas na primeira sessão
- Target: ≥ 50% dos sign-ups ativam em D0

### Retenção
- D7 ≥ 35% (volta e faz ≥ 1 consulta no dia 7)
- D30 ≥ 18%
- W4 ativos / W1 ativos ≥ 25%

### Conversão monetária
- Free → Residente em ≤ 14 dias: ≥ 4%
- Free → Clínico (skip Residente): ≥ 0,8%
- Lifetime Mestre / total pagantes: ≤ 15% (sem queimar margem)
- Churn mensal pagante: ≤ 8%

### Receita
- MRR mês 3 pós-lançamento: R$ 8k
- MRR mês 6: R$ 25k (gatilho pra investir em paid media)
- ARPPU: ≥ R$ 18

### Custo unitário (trava de margem)
- Custo LLM/consulta médio (caching ativo): ≤ R$ 0,012 Haiku · ≤ R$ 0,06 Sonnet
- Custo embedding por códice médio (300pp): ≤ R$ 0,08 (one-shot)
- Margem bruta por Residente ativo (300 cons/dia max usados na média): ≥ 70%

### Performance
- Time to first token (chat): ≤ 1,8s p50
- Tempo de parsing códice 300pp: ≤ 90s p50
- Uptime API: ≥ 99,5%

---

## 6. Definition of Ready to Ship (DORS)

Cada feature do MVP só vai a produção se cumprir TODOS os critérios abaixo. Sem exceção.

### Funcional
- [ ] Cobre os critérios Gherkin do `ACCEPTANCE-CRITERIA.md`
- [ ] Estados loading / empty / error / success implementados (não basta o happy path)
- [ ] Copy temática do glossário aplicada (códice/anamnese/Hipócrates/consultório)
- [ ] Funciona em Chrome/Edge/Safari últimas 2 versões (mobile + desktop)
- [ ] Responsivo: 360px (mobile) → 1920px (desktop)

### Compliance
- [ ] Disclaimer "material de estudo, não substitui avaliação clínica" presente
- [ ] Queries proibidas (ver `COMPLIANCE.md`) bloqueadas com mensagem padrão
- [ ] Dados pessoais protegidos por RLS no Supabase (user só lê o próprio)
- [ ] Termos + Privacidade linkados no footer

### Técnico
- [ ] Auth obrigatório em toda rota privada (`/api/*` exceto `/api/billing/webhook`)
- [ ] Rate limit aplicado conforme tier
- [ ] Erro retorna JSON estruturado `{error: {code, message, hint?}}`
- [ ] Logs estruturados em Sentry (não vaza PII em mensagem de erro)
- [ ] Eventos PostHog disparam (`codex_uploaded`, `consultation_sent`, `paywall_hit`, `subscription_started`)
- [ ] Custo LLM logado em Helicone com `userId` + `tier` + `slashCommand`
- [ ] Sem chave/secret em código (tudo `.env` + Vercel env)

### Performance
- [ ] LCP ≤ 2,5s na landing
- [ ] TTFB chat ≤ 1,8s p50
- [ ] Bundle JS rota chat ≤ 350KB gzip

### UX
- [ ] Estados loading com microcopy temática ("Auscultando…", "Decifrando o tratado…", "Hipócrates está consultando os anais…")
- [ ] Toast de erro em PT-BR humano (não "Internal Server Error")
- [ ] Botão de cancelar streaming presente e funcional

### Custo
- [ ] Prompt caching ativo em 100% das chamadas Anthropic (verificar header `cache_control`)
- [ ] Cap diário por tier travado server-side (não client)
- [ ] Sonnet 4.5 inacessível pra Estagiário e Residente (validação dupla: middleware + prompt router)

---

## 7. Não-objetivos explícitos

- **Não somos UpToDate / OpenEvidence**: não é ferramenta de prática clínica real. Repete-se: ferramenta de ESTUDO.
- **Não competimos com cursinho de residência**: não temos vídeo-aula, não temos professor.
- **Não somos rede social**: nada de feed, follow, share público.
- **Não fazemos análise de imagem médica no MVP**: sem visão computacional, sem laudar raio-X, sem ler RNM.

---

## 8. Decisões de produto travadas (não revisitar no MVP)

1. **Auth só Google.** Email/senha duplica suporte e não move conversão.
2. **Sem editor de capa.** Capa procedural por hash do título — economiza UX surface.
3. **1 conversa por códice por vez.** Sem multi-thread no MVP (simplifica histórico).
4. **PDF only.** Sem .docx, .epub, .txt no MVP.
5. **PT-BR only.** Idioma da UI e do prompt do sistema.
6. **Pix recorrente Asaas.** Sem cartão (quase ninguém de 22 anos tem cartão de crédito sobrando).
7. **Cap diário hard.** Quando bate o limite, paywall — sem soft warning.
8. **Sonnet 4.5 só Clínico.** Travado em middleware. Não negocia.

---

## 9. Riscos do MVP (mitigados no escopo)

| Risco | Mitigação no MVP |
|---|---|
| LLM alucinar dose de fármaco | `/dose` retorna SEMPRE com aviso "consultar bula" + bloqueio de queries diretas tipo "qual dose pra paciente X" |
| PDF gigante (Robbins 1500pp) estoura custo embedding | Cap 80MB; chunking 800 tokens com overlap 100; rate-limit embedding 50 chunks/s |
| CFM bater porta | Disclaimer em 3 lugares; copy nunca usa "diagnóstico" sem qualificador "raciocínio diagnóstico"; ToS deixa claro "estudo, não conduta clínica" |
| LGPD-saúde (PDFs do user podem ter dados sensíveis se for caso real) | Storage privado com signed URLs 5min; soft delete + hard delete em 30d; consentimento explícito no sign-up |
| Custo LLM disparar em usuário power | Cap diário hard server-side; alerta Sentry quando user passa de 80% |
| Estudante não pagar R$ 14,90 | Free generoso (2 códices, 50 cons/dia) gera valor antes de paywall — paywall só aparece em D2-D5 quando ele já tá viciado |

---

## 10. Premissas que precisam virar fato durante o build

1. Embedding de livro 300pp custa ≤ R$ 0,08 — **validar na FASE 1 com Robbins capítulo 1**
2. Haiku 4.5 com prompt cache + RAG entrega resposta clínica boa — **validar com 50 perguntas teste de prova de residência na FASE 2**
3. Asaas Pix recorrente funciona pra estudante BR sem cartão — **validar com 5 betas pagantes na FASE 3**
4. Disclaimer + termo de uso satisfaz risco CFM (ou pelo menos não acelera ele) — **validar com advogado antes da FASE 4**

---

## 11. Handoff

Este PRD aprovado destrava:
- `FLOWS.md` (UX detalhado dos 6 fluxos)
- `SLASH-COMMANDS.md` (spec técnica dos 6 comandos)
- `COMPLIANCE.md` (CFM + LGPD-saúde)
- `SCHEMA.sql` (Supabase Postgres)
- `API-ROUTES.md` (endpoints Next.js)
- `ACCEPTANCE-CRITERIA.md` (Gherkin por feature)
- `ROADMAP.md` (fases + sprints)

Dev pode iniciar FASE 1 do roadmap assim que ler estes 8 documentos.
