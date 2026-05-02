# ACCEPTANCE CRITERIA — Healer MVP

**Versão:** 1.0 · 2026-05-02
**Formato:** Gherkin (Given/When/Then). Cada feature lista cenários happy + edge.
**Uso:** dev marca cada cenário como ✅ antes de PR ir pra prod. QA roda manual no staging.

---

## FEATURE 1 — Autenticação (Google OAuth)

### Cenário 1.1 — Login bem-sucedido (primeira vez)
**Given** o usuário visita `/login`
**And** clica em "Entrar com Google"
**And** seleciona uma conta Google válida
**When** o OAuth callback retorna sucesso
**Then** um row é criado em `auth.users` (Supabase)
**And** um row é criado em `user_profiles` com `tier='estagiario'`
**And** o usuário é redirecionado pra `/onboarding/welcome`

### Cenário 1.2 — Login retorno (já tem conta)
**Given** o usuário existe em `user_profiles` e já completou onboarding
**When** ele faz login via Google
**Then** ele é redirecionado direto pra `/consultorio` (não pro onboarding)

### Cenário 1.3 — Falha de OAuth
**Given** o usuário fecha o popup do Google ou o OAuth retorna erro
**When** o callback é processado
**Then** ele permanece em `/login`
**And** vê um toast "Não rolou entrar. Tenta de novo?"

### Cenário 1.4 — Logout
**Given** o usuário está logado
**When** ele clica em "Sair" no menu do avatar
**Then** a sessão é invalidada
**And** ele é redirecionado pra `/`

---

## FEATURE 2 — Onboarding

### Cenário 2.1 — Tour completo
**Given** o usuário acabou de fazer signup
**When** ele clica "Próximo" nas 3 telas e marca o checkbox de aceite
**Then** `user_profiles.compliance_accepted_at`, `terms_accepted_at`, `privacy_accepted_at` são setados pra `now()`
**And** ele é redirecionado pra `/consultorio?firstUpload=true`

### Cenário 2.2 — Tentar continuar sem aceitar disclaimer
**Given** o usuário está na tela 3 do tour
**And** o checkbox de aceite NÃO está marcado
**When** ele tenta clicar em "Entrar no consultório"
**Then** o botão está desabilitado (não dispara nada)

### Cenário 2.3 — Pular tour
**Given** o usuário está na tela 1 do tour
**When** ele clica em "pular"
**Then** ele vai pra tela 3 (disclaimer obrigatório, não pode pular)

### Cenário 2.4 — Já completou onboarding e tenta acessar URL de onboarding
**Given** o usuário tem `compliance_accepted_at != NULL`
**When** ele acessa `/onboarding/welcome`
**Then** ele é redirecionado pra `/consultorio`

---

## FEATURE 3 — Upload de códice

### Cenário 3.1 — Upload bem-sucedido (PDF válido < 80MB)
**Given** o usuário Estagiário tem 0 códices
**When** ele dropa um PDF de 25MB com 300 páginas
**Then** o PDF é uploaded pro Storage `codices/{user_id}/{codex_id}.pdf`
**And** um row em `codices` é criado com `status='processing'`
**And** o card do códice aparece no consultório com overlay "Decifrando o tratado…"
**And** após ≤ 90s, `status='ready'` e o modal de confirmar título+categoria abre
**And** após confirmação, `consultations_count=0` e o usuário entra no chat

### Cenário 3.2 — PDF muito grande (> 80MB)
**Given** o usuário tenta subir PDF de 120MB
**When** o upload é validado client-side
**Then** o upload NÃO inicia
**And** aparece toast "Códice muito pesado. Limite é 80MB. Esse tá com 120MB."

### Cenário 3.3 — Arquivo não é PDF
**Given** o usuário arrasta um .docx
**When** validação client roda
**Then** toast "Só aceito PDF por enquanto."

### Cenário 3.4 — PDF escaneado sem texto
**Given** PDF passa validação client e upload
**When** parsing tenta extrair texto e retorna < 100 chars totais
**Then** `codices.status='failed'`, `status_message='PDF parece escaneado sem texto. Tenta um PDF com texto pesquisável.'`
**And** o card mostra estado erro com botão "Remover"

### Cenário 3.5 — Estagiário tenta subir 3º códice (cap=2)
**Given** o usuário Estagiário já tem 2 códices ativos
**When** ele tenta subir o 3º
**Then** o upload é bloqueado client-side
**And** abre modal paywall "Teu tier Estagiário segura 2 códices. Bora upgrade?"
**And** dispara evento PostHog `paywall_hit { reason: 'cap_codex' }`

### Cenário 3.6 — Parsing demora > 5min (timeout)
**Given** parsing está em curso há > 5 min
**When** o cron de health-check roda
**Then** `status='failed'`, mensagem "Não consegui decifrar esse códice. Tenta de novo ou avisa o suporte."
**And** card mostra botões "Tentar de novo" e "Remover"

### Cenário 3.7 — Cancelar upload em andamento
**Given** upload está em 40%
**When** o usuário clica em X (cancelar)
**Then** o XHR é abortado
**And** nenhum row é criado em `codices`
**And** o arquivo parcial é removido do storage

---

## FEATURE 4 — Consultório (dashboard)

### Cenário 4.1 — Empty state (sem códices)
**Given** usuário recém-criou conta e não tem códice
**When** ele acessa `/consultorio`
**Then** vê ilustração + "Teu consultório tá vazio. Bora subir o primeiro códice?" + dropzone

### Cenário 4.2 — Listagem com códices
**Given** usuário tem 8 códices em estados variados
**When** acessa `/consultorio`
**Then** vê grid 4 colunas (desktop)
**And** códices em `status='processing'` mostram overlay "Decifrando…"
**And** códices em `status='ready'` mostram capa + título + categoria + contador de consultas
**And** ordenação é `updated_at DESC`

### Cenário 4.3 — Busca filtra
**Given** usuário tem códices "Robbins", "Porto", "Harrison"
**When** digita "Por" no campo de busca
**Then** apenas card "Porto" permanece visível
**And** busca acontece client-side (sem requisição)

### Cenário 4.4 — Excluir códice
**Given** usuário clica em kebab de um códice → "Excluir"
**When** confirma no dialog
**Then** `codices.deleted_at = now()`
**And** card desaparece do grid (com fade out)
**And** card NÃO volta após reload

### Cenário 4.5 — Cap de tier exibido corretamente
**Given** usuário Residente com 47 consultas hoje
**When** vê o header
**Then** lê "Residente · 47/300 consultas hoje"

---

## FEATURE 5 — Chat com Hipócrates

### Cenário 5.1 — Primeira consulta no códice (empty state)
**Given** usuário entra em `/consultorio/{codex_id}` pela primeira vez
**Then** vê card boas-vindas "Esse é o {título}, com {N} páginas decifradas..."
**And** vê 3 chips quick-start

### Cenário 5.2 — Consulta livre bem-sucedida
**Given** usuário com cap disponível e códice ready
**When** digita "Explica fisiopato IC esquerda" e clica em Consultar
**Then** mensagem do user aparece imediatamente alinhada à direita
**And** bubble do Hipócrates aparece com "Auscultando…"
**And** após ≤ 1.8s p50 começa o streaming
**And** texto aparece token-a-token
**And** ao final, citações `[pp. 437]` viram botões clicáveis
**And** disclaimer "Material de estudo..." aparece em cinza no rodapé
**And** row em `consultations` é criado com `tokens_input/output/cached`, `cost_brl_cents`
**And** `consultations_today` do user incrementa em 1

### Cenário 5.3 — Slash-command `/explicar` com argumento
**Given** usuário digita `/explicar` e palette aparece
**When** completa "/explicar mecanismo dos IECA" e envia
**Then** request inclui `slash_command='explicar'`
**And** prompt user message usa template do `/explicar`
**And** resposta segue estrutura: O que é / Mecanismo / Manifestações / Por que cai em prova

### Cenário 5.4 — Slash-command sem argumento obrigatório
**Given** usuário digita `/explicar` (sem mais nada)
**When** clica enviar
**Then** mensagem inline aparece: "Esse comando precisa de um tópico. Ex: `/explicar fisiopato IC`"
**And** request NÃO é enviado pro server

### Cenário 5.5 — Cancelar streaming
**Given** streaming está em curso
**When** usuário clica no botão X (cancelar)
**Then** o fetch é abortado
**And** server cancela stream Anthropic via `controller.abort()`
**And** `consultations.response` é salvo com texto parcial

### Cenário 5.6 — Cap de consultas batido
**Given** usuário Estagiário com `consultations_today = 50`
**When** ele tenta enviar 51ª consulta
**Then** server retorna `402 cap_consultations`
**And** composer fica desabilitado
**And** banner aparece "Você bateu seu cap de 50 consultas hoje. Bora upgrade pra mais?"
**And** dispara `paywall_hit { reason: 'cap_consultations' }`

### Cenário 5.7 — Query bloqueada (compliance)
**Given** usuário envia "Tenho um paciente com tosse, qual antibiótico prescrevo?"
**When** intent classifier detecta "meu paciente" + "prescrevo"
**Then** server NÃO embeda nem chama LLM
**And** row em `consultations` é criado com `blocked=true`, `block_reason='clinical_decision'`
**And** SSE retorna evento `blocked` com mensagem padrão
**And** `consultations_today` NÃO incrementa
**And** dispara `consultation_blocked { reason: 'clinical_decision' }`

### Cenário 5.8 — Tentar usar Sonnet sendo Residente
**Given** usuário Residente envia query com `model_preference='sonnet'`
**When** middleware verifica tier
**Then** server retorna `403 forbidden { hint: "Sonnet 4.5 é exclusivo do tier Clínico" }`
**And** modal aparece "Quer melhor IA? Upgrade pro Clínico"

### Cenário 5.9 — Citação clicável
**Given** Hipócrates retornou resposta com `[[CITE:437]]`
**When** usuário clica em "[pp. 437]"
**Then** abre coluna direita com preview do PDF na página 437
**And** signed URL do storage é gerado com TTL 5min

### Cenário 5.10 — Erro do LLM (Anthropic 5xx)
**Given** Anthropic API retorna 503
**When** consultation tenta ser executada
**Then** SSE retorna evento `error`
**And** bubble vermelha aparece "O Hipócrates engasgou. Tenta de novo?"
**And** botão "Tentar de novo" reusa a mesma anamnese
**And** `consultations_today` NÃO incrementa

### Cenário 5.11 — Feedback thumbs up/down
**Given** resposta do Hipócrates renderizada
**When** usuário clica em 👍
**Then** `consultations.user_feedback = 1`
**And** dispara evento `consultation_feedback { feedback: 1, slash_command, model }`

---

## FEATURE 6 — Histórico

### Cenário 6.1 — Sidebar com últimas anamneses
**Given** usuário está em `/consultorio/{codex_id}` com 12 consultations
**Then** sidebar mostra as 20 mais recentes (ou todas, se < 20)
**And** cada item mostra primeiros 60 chars da query + tempo relativo

### Cenário 6.2 — Clicar em anamnese antiga
**Given** sidebar tem item da consultation X
**When** usuário clica
**Then** chat carrega aquela conversa específica (query + response)
**And** URL muda pra `/consultorio/{codex_id}?consultation={id}`

### Cenário 6.3 — Buscar no histórico
**Given** usuário em `/consultorio/{codex_id}/historico`
**When** digita "IC esquerda"
**Then** server filtra `WHERE query ILIKE '%IC esquerda%'`
**And** retorna apenas matches

### Cenário 6.4 — Excluir consultation
**Given** usuário clica em ícone delete de uma consultation
**When** confirma
**Then** row deletado
**And** sidebar atualiza removendo o item
**And** se era a ativa, redireciona pra empty state do códice

---

## FEATURE 7 — Upgrade de tier (Asaas Pix)

### Cenário 7.1 — Iniciar checkout Residente Mensal
**Given** usuário Estagiário em `/planos`
**When** clica "Fazer juramento" no card Residente Mensal
**Then** server cria customer Asaas (se não existe), assinatura mensal Pix
**And** UI mostra QR Code Pix grande + valor R$ 14,90 + "Vence em 5min"
**And** polling a cada 3s consulta status

### Cenário 7.2 — Pagamento confirmado (webhook)
**Given** usuário pagou Pix no app do banco
**When** Asaas envia `PAYMENT_CONFIRMED` webhook
**Then** `billing_events` row criado
**And** `subscriptions.status = 'active'`
**And** `user_profiles.tier = 'residente'`
**And** próximo polling do frontend detecta e redireciona pra `/planos/sucesso`
**And** dispara `subscription_started { tier: 'residente', period: 'monthly', amount_brl_cents: 1490 }`

### Cenário 7.3 — Pix expira sem pagamento
**Given** QR Pix gerado há 5min sem pagamento
**When** Asaas envia `PAYMENT_OVERDUE`
**Then** UI mostra "QR expirou. Gerar novo?"
**And** clicar gera novo Pix com nova expiração

### Cenário 7.4 — Cancelar assinatura
**Given** usuário Residente ativo até 2026-06-02
**When** clica em "Cancelar juramento" e confirma
**Then** Asaas subscription é cancelada
**And** `subscriptions.cancel_at_period_end = true`, `canceled_at = now()`
**And** `tier` continua 'residente' até 2026-06-02
**And** em 2026-06-03, cron faz downgrade pra 'estagiario'
**And** dispara `subscription_canceled { tier: 'residente', days_active: N }`

### Cenário 7.5 — Compra Mestre lifetime
**Given** usuário em `/planos`
**When** clica "Comprar lifetime" no card Mestre (R$ 297)
**Then** Asaas gera pagamento avulso (não subscription)
**And** após confirmação webhook, `tier='mestre'`, `subscriptions.period='lifetime'`, `current_period_end = NULL`

### Cenário 7.6 — Webhook duplicado (idempotência)
**Given** Asaas envia mesmo `PAYMENT_CONFIRMED` 2 vezes
**When** segundo evento chega
**Then** `billing_events` detecta `asaas_payload->>'id'` já existente
**And** retorna 200 sem reprocessar
**And** `tier` NÃO muda novamente

---

## FEATURE 8 — Compliance / Bloqueios

### Cenário 8.1 — Detecção regex "meu paciente"
**Given** usuário envia "amoxi pro meu paciente de 8 anos"
**When** intent classifier roda
**Then** regex `/\b(meu|minha) paciente\b/i` casa
**And** bloqueio retornado SEM chamar Haiku classifier nem LLM principal

### Cenário 8.2 — Detecção LLM classifier (caso ambíguo)
**Given** usuário envia "Tô com dor no peito há 2h, posso ter infartado?"
**When** regex não casa, mas Haiku classifier retorna `self_diagnosis`
**Then** bloqueio retornado com mensagem de auto-diagnóstico
**And** custo do classifier (~R$ 0,001) é logado em Helicone

### Cenário 8.3 — Self-harm dispara alerta
**Given** usuário envia query com pattern `/\b(suicid|me matar)/i`
**When** match
**Then** retorna mensagem CVV
**And** Sentry warning disparado tag `compliance.self_harm`

### Cenário 8.4 — Disclaimer presente em toda resposta
**Given** Hipócrates responde qualquer query
**Then** resposta termina com "_Material de estudo. Não substitui avaliação clínica presencial._"
**And** se LLM esquecer, frontend força append do disclaimer

### Cenário 8.5 — `/dose` sem indicação de paciente real
**Given** usuário envia `/dose amoxicilina`
**When** intent classifier roda
**Then** classifica como `study` (sem trigger)
**And** resposta inclui tabela de dose + aviso obrigatório de bula

### Cenário 8.6 — `/dose` com indicação de paciente real
**Given** usuário envia "qual dose de amox pra criança de 8 anos com 25kg que tô atendendo agora"
**When** intent classifier roda
**Then** classifica como `clinical_decision`
**And** bloqueio aplicado

---

## FEATURE 9 — Performance

### Cenário 9.1 — TTFT chat
**Given** condições normais (Anthropic OK, RAG OK)
**When** usuário envia consulta
**Then** primeiro token chega em ≤ 1.8s p50, ≤ 3s p95

### Cenário 9.2 — Parsing códice 300pp
**Given** PDF de 300pp / 25MB
**When** parsing roda
**Then** completa em ≤ 90s p50

### Cenário 9.3 — LCP landing
**Given** usuário acessa landing pela primeira vez (cold)
**When** mede LCP
**Then** ≤ 2.5s

---

## FEATURE 10 — Observabilidade

### Cenário 10.1 — Eventos PostHog
**Given** usuário completa fluxo completo (signup → upload → 3 consultas → upgrade)
**When** verifica PostHog
**Then** vê eventos na ordem:
- `signup_completed`
- `onboarding_completed`
- `codex_uploaded`
- `consultation_sent` (×3)
- `paywall_hit` (se cap batido)
- `checkout_started`
- `subscription_started`

### Cenário 10.2 — Custo logado em Helicone
**Given** consultation completa
**When** verifica Helicone
**Then** request aparece com properties `userId`, `tier`, `slashCommand`
**And** custo total e cached tokens visíveis

### Cenário 10.3 — Erro 500 capturado em Sentry
**Given** erro inesperado em `/api/codices`
**When** Sentry recebe
**Then** stack trace presente
**And** `userId` taggeado
**And** payload da query NÃO está no Sentry (PII filter)

---

## FEATURE 11 — LGPD / Delete

### Cenário 11.1 — Excluir conta
**Given** usuário clica "Excluir minha conta"
**When** confirma 2x (modal duplo) e confirma com texto "EXCLUIR"
**Then** `user_profiles.deleted_at = now()`
**And** todos códices soft-deleted
**And** subscription Asaas cancelada
**And** logout imediato
**And** banner "Sua conta será permanentemente apagada em 30 dias. Login novamente nesse período cancela a exclusão."

### Cenário 11.2 — Hard delete cron
**Given** conta soft-deletada há > 30d
**When** cron roda
**Then** `user_profiles` row deletado (CASCADE em codices, chunks, consultations, subscriptions)
**And** storage files removidos
**And** zero PII permanece

---

## DEFINITION OF DONE consolidada (resumo dev)

Antes de PR ser mergeada pra `main`:
- [ ] Todos cenários da feature do PR cobertos por teste manual em staging
- [ ] Cenários de erro testados (não só happy path)
- [ ] Disclaimers compliance presentes onde exigido
- [ ] Eventos PostHog disparam corretamente
- [ ] Loading/empty/error states implementados
- [ ] Mobile testado em 360px width
- [ ] Performance verificada (TTFT ≤ 1.8s, parsing ≤ 90s)
- [ ] RLS policy testada (criar 2 users, garantir que A não vê dado de B)
- [ ] Lint + typecheck passando
- [ ] Sem secret commitado
