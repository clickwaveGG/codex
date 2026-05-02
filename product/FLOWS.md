# FLUXOS DE UX — MVP Healer

**Versão:** 1.0 · 2026-05-02
**Escopo:** 6 fluxos críticos do MVP, cada um com estados loading/empty/error/success e dependências de back.

> **Glossário travado** (usar SEMPRE na copy): códice, compêndio, anamnese, consulta, auscultar, consultar, parecer, Hipócrates, consultório, juramento, Estagiário/Residente/Clínico/Mestre.

---

## FLUXO 1 — Onboarding (login → tour → primeiro códice)

### Objetivo
Levar usuário de "cliquei em entrar" até "fiz minha primeira consulta com sucesso" em ≤ 4 minutos.

### Etapas

#### 1.1 Tela de login (`/login`)
- **UI:** logo Healer centralizado, headline "Entre no consultório", subhead "Transforme livros-texto em consultor de bolso", botão único "Entrar com Google" (`<GoogleAuthButton />`).
- **Sem opção:** email/senha, magic link, outros providers.
- **Footer:** disclaimers "Material de estudo. Não substitui avaliação clínica." + links Termos / Privacidade.
- **Estados:**
  - **Loading** (Google popup aberto): botão vira spinner com texto "Validando juramento…"
  - **Error** (popup fechado / OAuth falhou): toast "Não rolou entrar. Tenta de novo?" + botão volta ao normal
  - **Success:** redireciona pra `/onboarding/welcome`
- **Back deps:** `POST /api/auth/callback/google` (Supabase Auth padrão)

#### 1.2 Tour de 3 telas (`/onboarding/welcome` → `/onboarding/how` → `/onboarding/disclaimer`)
- **Tela 1 — Boas-vindas:** "Bem-vindo ao consultório, {primeiro_nome}." Subhead: "Aqui você sobe seus códices e conversa com o Hipócrates pra estudar mais rápido." CTA "Próximo".
- **Tela 2 — Como funciona:** 3 ícones em linha — "Sobe um códice (PDF)" → "Faz uma anamnese" → "Recebe parecer com página citada". CTA "Próximo".
- **Tela 3 — Aviso clínico (obrigatório):** card destacado em Vital Red com texto exato:
  > "O Hipócrates é uma ferramenta de **estudo**. Ele te ajuda a entender, revisar e simular casos clínicos pra prova. **Não substitui avaliação clínica presencial nem prescrição de profissional habilitado.** Ao continuar, você concorda com os Termos de Uso."
  Checkbox obrigatório "Li e concordo". CTA "Entrar no consultório" (desabilitado até checkbox).
- **Estados:**
  - **Pular tour:** link discreto "pular" no canto superior direito (registra evento `onboarding_skipped`)
  - **Submit aviso clínico:** grava `users.compliance_accepted_at = now()` antes de redirecionar
- **Back deps:** `PATCH /api/users/me` (compliance_accepted_at)

#### 1.3 Primeiro upload de códice (`/consultorio?firstUpload=true`)
- **UI:** consultório vazio com call-to-action grande no centro: ilustração de pergaminho + "Sobe teu primeiro códice pra começar" + dropzone "Arrasta um PDF aqui ou clica pra selecionar".
- Ao subir: dispara FLUXO 2 (upload) com flag `firstUpload=true` que ao final redireciona direto pro chat com mensagem de boas-vindas pré-carregada.
- **Estado empty:** ilustração + copy "Teu consultório tá vazio. Bora subir o primeiro códice?"

### Métricas
- `onboarding_started`, `onboarding_step_completed` (step), `onboarding_completed`, `onboarding_skipped`, `first_codex_uploaded`, `first_consultation_sent`

---

## FLUXO 2 — Upload de códice

### Objetivo
Aceitar PDF, validar, parsear assíncrono, e devolver códice navegável em ≤ 90s p50 pra livros médios (300pp).

### Etapas

#### 2.1 Iniciar upload
- **Trigger:** dropzone do consultório OU botão "+ Novo códice" no header
- **Validações client-side (antes de subir):**
  - Tipo MIME `application/pdf` → senão erro "Só aceito PDF por enquanto."
  - Tamanho ≤ 80MB → senão erro "Códice muito pesado. Limite é 80MB."
  - Cap de códices por tier (Estagiário 2, Residente 15, Clínico/Mestre ∞) → se cheio: paywall
- **UI durante upload:**
  - Progress bar com % real (XHR)
  - Microcopy "Recebendo o códice…" (0-100%)

#### 2.2 Parsing assíncrono
- Após upload completo, server retorna `codex_id` + status `processing`
- UI mostra **card do códice no consultório** com overlay "Decifrando o tratado…" + spinner + estimativa "~{tempoEstimado}s"
- Polling `GET /api/codices/{id}/status` a cada 2s OU subscribe Supabase Realtime no row `codices`
- Pipeline server-side:
  1. Download do storage
  2. `pdf-parse` extrai texto + números de página
  3. Chunking 800 tokens / overlap 100
  4. Embedding em batch de 100 (OpenAI text-embedding-3-small)
  5. Insert chunks no Supabase com vector + page
  6. Update `codices.status_processing = 'ready'`
- **Categorização automática:** durante parsing, pega 2000 tokens iniciais e pede ao Haiku pra sugerir categoria entre [Anatomia, Fisiologia, Bioquímica, Farmacologia, Patologia, Clínica Médica, Cirurgia, Pediatria, GO, Psiquiatria, Saúde Coletiva, Outros]. User confirma ao final.

#### 2.3 Confirmar título + categoria
- Modal aparece quando `status_processing = 'ready'`:
  - Título extraído (editável) — fallback: nome do arquivo sem `.pdf`
  - Categoria sugerida (dropdown editável) — default: sugestão do Haiku
  - Contador "{page_count} páginas decifradas"
  - Botão "Salvar e abrir códice"
- **Submit:** atualiza `codices.title` + `codices.category`, redireciona pra `/consultorio/{codex_id}`

### Estados
- **Loading (upload):** progress bar + microcopy "Recebendo…"
- **Loading (parsing):** card no grid com overlay verde semi-transparente + "Decifrando o tratado… ~45s"
- **Empty:** dropzone padrão (FLUXO 1.3)
- **Error PDF inválido:** "Esse PDF tá embaralhado (parece escaneado sem texto). Tenta um com texto pesquisável."
- **Error tamanho:** "Códice muito pesado. Limite é 80MB. Esse tá com {tamanho}MB."
- **Error cap tier:** modal paywall "Teu tier {Estagiário/Residente} segura {2/15} códices. Bora upgrade?"
- **Error parsing falhou (timeout > 5min):** card vermelho "Não consegui decifrar esse códice. Tenta de novo ou avisa o suporte." + botão "Tentar de novo" + botão "Remover"
- **Success:** modal de confirmar → consultório abre o códice

### Back deps
- `POST /api/codices` (multipart upload)
- `GET /api/codices/{id}/status` (polling)
- `PATCH /api/codices/{id}` (título + categoria)

### Microcopy temática (lista exata)
- "Recebendo o códice…"
- "Decifrando o tratado…"
- "Indexando os capítulos…"
- "Quase pronto pra consulta…"
- "Códice pronto. Bora consultar?"

---

## FLUXO 3 — Consultório (dashboard)

### Objetivo
Em ≤ 1 segundo desde login, usuário vê todos os códices, sabe qual abrir, e pode subir novo OU pesquisar.

### Layout
- **Header fixo:** logo Healer · busca global · contador de tier ("Estagiário · 27/50 consultas hoje") · avatar Google · menu (perfil, billing, sair)
- **Hero do consultório:** "Bom dia, {primeiro_nome}. Teus códices estão prontos." + botão "+ Novo códice"
- **Grid de códices:** 4 colunas desktop, 2 tablet, 1 mobile
- **Cada card de códice contém:**
  - Capa procedural (gradient verde determinístico baseado em hash do título; ícone da categoria sobreposto)
  - Título (truncado em 2 linhas)
  - Badge de categoria
  - "{n} consultas · última há {tempo_relativo}"
  - Hover: botão "Abrir consultório" + menu kebab (renomear, recategorizar, excluir)

### Estados
- **Loading:** skeleton de 6 cards com shimmer
- **Empty (sem códices):** ilustração de consultório vazio + "Teu consultório tá vazio. Bora subir o primeiro códice?" + dropzone (FLUXO 1.3)
- **Error fetch:** "Não consegui carregar teus códices. Tenta atualizar?" + botão "Tentar de novo"
- **Success:** grid renderizado

### Funcionalidades
- **Busca:** filtra cards por título (client-side; só MVP) — placeholder "Procurar nos teus códices…"
- **Ordenação default:** `updated_at DESC` (último consultado primeiro). Sem opção de reordenar no MVP.
- **Excluir:** confirm dialog "Excluir esse códice apaga ele e todas as anamneses dele. Sem volta. Tem certeza?"

### Back deps
- `GET /api/codices` (lista do user, com `consultations_count` e `last_consulted_at`)
- `DELETE /api/codices/{id}` (soft delete inicial; hard delete em 30d via cron)

### Microcopy
- "Bom dia/Boa tarde/Boa noite, {primeiro_nome}."
- "Teus códices estão prontos."
- "Procurar nos teus códices…"
- "Abrir consultório"

---

## FLUXO 4 — Conversa com Hipócrates

### Objetivo
Fazer o usuário sair de "abri o códice" para "tenho parecer com citação na página X" em ≤ 5 segundos perceptíveis (TTFT ≤ 1.8s).

### Layout
- **Coluna esquerda (sidebar 280px):** título do códice · botão "← Consultório" · histórico das anamneses anteriores deste códice (lista ordenada desc, primeira pergunta truncada em 60 chars como label)
- **Centro (main):** área de chat scrollável + composer fixo no rodapé
- **Coluna direita opcional (320px, abre on-demand):** preview do PDF na página citada quando user clica em [pp. 437]

### Composer
- Textarea autoresize 1-6 linhas, placeholder "Pergunta pro Hipócrates sobre teu material…"
- **Slash-command palette:** ao digitar `/` exibe dropdown com 6 comandos (ver `SLASH-COMMANDS.md`):
  - `/resumir` · `/explicar` · `/quizar` · `/caso` · `/diferenciar` · `/dose`
  - Cada um com descrição curta e exemplo
- Botão "Consultar" (envia) · ícone de cancelar quando streaming ativo
- Cmd/Ctrl+Enter envia · Enter quebra linha
- Contador discreto "{usadas}/{limite} consultas hoje" abaixo do composer

### Mensagem do usuário
- Bubble alinhada à direita, fundo Apothecary Green claro
- Avatar com inicial do nome
- Timestamp on-hover

### Mensagem do Hipócrates (parecer)
- Bubble alinhada à esquerda, fundo Deep Sage
- Avatar circular com símbolo de Hipócrates
- Header: "Hipócrates · {modelo: Haiku|Sonnet}"
- Corpo: markdown renderizado (headers, listas, tabela, code block pra fórmulas)
- **Citações inline:** cada parágrafo principal vira `[pp. 437-441]` clicável. Click abre preview do PDF naquela página.
- **Disclaimer rodapé:** texto cinza pequeno em CADA resposta:
  > "Material de estudo. Não substitui avaliação clínica presencial."
- Ações abaixo: copiar resposta · regenerar · feedback (👍/👎)

### Estados
- **Empty (primeira consulta no códice):**
  - Card central de boas-vindas: "Esse é o **{título}**, com {page_count} páginas decifradas. Pergunta o que quiser ou usa um comando rápido."
  - Chips de quick-start: `[/resumir o livro]` `[/explicar fisiopato cap. 1]` `[/quizar 5 questões]`
- **Loading (enviando):** mensagem do user aparece imediatamente; bubble do Hipócrates aparece com 3 dots animados + microcopy "Auscultando…"
- **Loading (streaming ativo):** texto vai aparecendo token-a-token; botão "Consultar" vira "Cancelar" (X)
- **Error LLM falhou:** bubble vermelho "O Hipócrates engasgou. Tenta de novo?" + botão "Tentar de novo" (reusa mesma anamnese)
- **Error query proibida:** bubble amarelo com texto exato (ver `COMPLIANCE.md` seção Bloqueios)
- **Cap diário batido:** composer desabilitado + banner topo "Você bateu seu cap de {limite} consultas hoje. Bora upgrade pra mais?" + CTA "Ver planos"
- **Success:** parecer renderizado com citações clicáveis

### Funcionalidades técnicas
- **Streaming SSE** via `POST /api/consultations` (response `text/event-stream`)
- **Cancelamento:** abort signal no fetch + server interrompe stream Anthropic via `controller.abort()`
- **Citação:** cada chunk RAG retornado vem com metadata `{codex_id, page}`. LLM é instruído a inserir `[[CITE:page_number]]` no texto. Frontend faz parse e converte em `<button>[pp. {page}]</button>` clicável.
- **Histórico salvo:** ao final do streaming OU em caso de cancel/erro, grava `consultations` com `query`, `response` (parcial se cancel), `slash_command` (se houver), `tokens_input/output`, `cost_estimate`.

### Microcopy
- "Pergunta pro Hipócrates sobre teu material…" (placeholder)
- "Auscultando…" (loading)
- "Hipócrates está consultando os anais…" (loading mais longo > 3s)
- "Material de estudo. Não substitui avaliação clínica presencial." (disclaimer rodapé)
- "Consultar" (botão send)
- "Cancelar consulta" (botão durante stream)
- "Tentar de novo" (após erro)

### Back deps
- `POST /api/consultations` (SSE streaming)
- `GET /api/consultations?codex_id={id}` (sidebar de histórico)
- `GET /api/codices/{id}/page/{page_num}` (preview do PDF)

---

## FLUXO 5 — Histórico de consultas

### Objetivo
User encontra anamnese antiga em ≤ 3 cliques e revisita o parecer.

### Localização
- Sidebar esquerda do `/consultorio/{codex_id}` (FLUXO 4)
- Página dedicada `/consultorio/{codex_id}/historico` quando lista > 20 itens

### Layout sidebar
- Header "Anamneses" + botão "+" (nova consulta = clear chat)
- Lista vertical: cada item = card pequeno
  - 1ª linha: primeira pergunta truncada (60 chars)
  - 2ª linha: tempo relativo ("há 2h", "ontem", "29 abr")
  - Ícone do slash-command se foi usado
- Item ativo: highlight Apothecary Green
- Rodapé sidebar: "Ver todas →" (vai pra página dedicada se > 20)

### Página dedicada `/consultorio/{codex_id}/historico`
- Tabela: data · tipo (slash-command ou livre) · pergunta truncada · ações (abrir, deletar)
- Busca textual (server-side com `ILIKE` em `consultations.query`)
- Filtro por slash-command (chip toggle)
- Paginação 20/página

### Estados
- **Empty:** "Sem anamneses ainda. Faz a primeira pergunta no consultório."
- **Loading:** skeleton 5 itens
- **Error:** "Não carreguei o histórico. Recarrega a página?"
- **Search empty:** "Nada encontrado pra '{query}'."

### Back deps
- `GET /api/consultations?codex_id={id}&limit=20` (sidebar)
- `GET /api/consultations?codex_id={id}&search=&slash=&page=` (página dedicada)
- `DELETE /api/consultations/{id}`

### Microcopy
- "Anamneses"
- "Ver todas →"
- "Sem anamneses ainda. Faz a primeira pergunta no consultório."

---

## FLUXO 6 — Upgrade de tier (paywall → Asaas Pix → confirmação)

### Objetivo
Converter usuário que bateu cap em pagante em ≤ 90 segundos, sem fricção.

### Triggers do paywall
1. Bateu cap diário de consultas
2. Bateu cap de códices ao tentar subir mais
3. Tentou usar Sonnet 4.5 (Clínico-only) sendo Estagiário/Residente
4. Clicou em "Ver planos" no menu

### Tela de planos `/planos`
- Header "Faça seu juramento" + sub "Mais consultas, mais códices, melhor IA. Pix recorrente, cancela quando quiser."
- 3 cards lado-a-lado (mobile: stack):

| Estagiário | Residente | Clínico | Mestre |
|---|---|---|---|
| R$ 0 | R$ 14,90/mês | R$ 29,90/mês | R$ 297 (vitalício) |
| 2 códices | 15 códices | ∞ códices | ∞ códices |
| 50 cons/dia | 300 cons/dia | 1.000 cons/dia | 1.500 cons/dia |
| Haiku 4.5 | Haiku 4.5 | + Sonnet 4.5 | + Sonnet 4.5 |
| Atual / "Continuar" | "Fazer juramento" | "Fazer juramento" | "Comprar lifetime" |

- Toggle "Mensal / Anual (-33%)" no topo dos cards de Residente e Clínico
- Card "Mestre" destacado com badge "Para sempre"

### Checkout (`/planos/checkout?tier=residente`)
1. Sistema chama `POST /api/billing/subscribe { tier, period }`
2. Server cria customer + assinatura no Asaas, retorna `qr_code_pix` + `payment_id`
3. UI exibe QR Code Pix grande + código copy-paste + valor + "Vence em 5 minutos"
4. Polling `GET /api/billing/payment/{id}` a cada 3s
5. Quando Asaas confirma pagamento (webhook → upgrade `users.tier`), polling detecta e redireciona pra `/planos/sucesso`

### Tela de sucesso `/planos/sucesso`
- "Juramento feito. Bem-vindo ao consultório {Residente/Clínico/Mestre}."
- "Teus novos limites: {n} códices · {n} consultas/dia"
- CTA "Voltar ao consultório"
- Dispara `subscription_started` (PostHog)

### Estados
- **Loading checkout:** spinner "Preparando teu Pix…"
- **Error Asaas timeout/falha:** "Não consegui gerar o Pix. Tenta de novo?" + retry
- **Error pagamento expirou:** "QR expirou. Gerar novo?" + botão "Gerar novo Pix"
- **Success:** redirect

### Cancelamento
- Em `/planos`, usuário pagante vê botão "Cancelar juramento" pequeno no rodapé do card ativo
- Confirm: "Cancelando agora, você mantém o acesso até {dia X}. Depois disso, volta pro Estagiário. Quer mesmo?"
- Asaas cancel via `DELETE /api/billing/subscription`. Mantém `subscriptions.current_period_end` ativo até fim do ciclo pago.

### Microcopy
- "Faça seu juramento"
- "Pix recorrente, cancela quando quiser"
- "Vence em 5 minutos"
- "Juramento feito. Bem-vindo ao consultório {tier}."
- "Cancelar juramento"

### Back deps
- `POST /api/billing/subscribe` (cria assinatura Asaas, retorna QR)
- `GET /api/billing/payment/{id}` (polling status)
- `POST /api/billing/webhook` (Asaas → server, upgrade tier)
- `DELETE /api/billing/subscription` (cancela)

---

## Anexo — Padrões transversais

### Acessibilidade (mínimo MVP)
- Contraste AA WCAG (verde-medicinal sobre Bone passa; testar Sage sobre Void Clínico)
- Foco visível em todos os interativos
- Aria-labels nos botões com ícone
- Atalhos teclado: Cmd/Ctrl+K abre busca global, Cmd/Ctrl+Enter envia consulta, Esc cancela streaming

### Mobile (responsivo)
- Sidebar do chat vira drawer (hambúrguer no header)
- Composer fixo no bottom com safe-area-inset-bottom (iOS)
- Slash-command palette vira bottom-sheet em mobile

### Notificações
- Toast canto inferior direito (desktop) / topo (mobile), 4s, ícones por tipo (success, warn, error, info)
