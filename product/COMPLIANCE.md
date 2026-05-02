# COMPLIANCE & GUARDRAILS — Healer MVP

**Versão:** 1.0 · 2026-05-02
**Disclaimer:** este doc é spec de produto/engenharia, NÃO parecer jurídico. Antes do lançamento público, validar com advogado de direito digital + saúde.

---

## 1. Posicionamento legal do produto (afirmação base)

> Healer é uma **ferramenta de estudo** para estudantes e profissionais de saúde. **Não é, em hipótese alguma, ferramenta de diagnóstico, prescrição, prática clínica ou substituto de avaliação presencial por profissional habilitado.** Todo conteúdo gerado é referência educativa baseada nos códices que o próprio usuário sobe.

Esse posicionamento deve estar EM TODOS os pontos de fricção: footer, primeira tela do chat, planos, cada resposta da IA, ToS, Privacidade.

---

## 2. Riscos regulatórios mapeados

### 2.1 CFM (Conselho Federal de Medicina)
- **Risco:** Resolução CFM 2.314/2022 (telemedicina) e debates sobre IA em saúde podem exigir registro/autorização se a ferramenta for vista como "exercício de medicina por meio digital".
- **Mitigação:** posicionar como ferramenta de estudo (mesma categoria de NotebookLM/ChatPDF, não de UpToDate). Nunca afirmar autoria médica. Disclaimers explícitos.
- **Trigger pra rever:** abrir B2B com hospital, lançar feature de "auxílio ao prontuário", ou se CFM publicar regulação específica de IA.

### 2.2 ANVISA (software como dispositivo médico - SaMD)
- **Risco:** RDC 657/2022 classifica software médico. SaaS de "diagnóstico/tratamento" exige registro classe II ou III.
- **Mitigação:** escopo de ESTUDO é classe I/isento (educação, sem decisão clínica). Manter copy estritamente educacional. Nunca prometer "auxílio diagnóstico" — só "auxílio de estudo".

### 2.3 LGPD (Lei 13.709/2018) + LGPD-saúde
- **Risco:** PDFs do usuário podem conter dados pessoais sensíveis (caso clínico real, prontuário). Dados de saúde têm proteção reforçada (art. 11).
- **Mitigação:** consentimento explícito; storage criptografado em rest; signed URLs 5min; soft delete + hard delete; user pode deletar tudo a qualquer hora; não usar PDFs do user pra treinar modelos.

### 2.4 Direito autoral (PDFs piratas)
- **Risco:** estudante sobe Robbins pirata. Healer não é responsável pelo conteúdo subido (safe harbor Marco Civil), mas precisa ter notice-and-takedown.
- **Mitigação:** ToS claro: usuário declara ter direito sobre o material. Process notice-and-takedown documentado. Não distribuir conteúdo (códice é privado pro user que subiu).

---

## 3. Queries proibidas e bloqueio em runtime

### 3.1 Categorias bloqueadas

| Categoria | Exemplo de query | Motivo |
|---|---|---|
| Diagnóstico real | "Tenho um paciente de 45a com tosse seca e febre, qual o diagnóstico?" | Prática clínica não-autorizada |
| Prescrição direta | "Que dose de amox eu prescrevo pra esse paciente?" | Prescrição = ato médico |
| Conduta clínica direta | "Devo intubar esse paciente agora?" | Decisão clínica |
| Pedido de receita | "Faz uma receita de azitromicina" | Documento clínico |
| Aconselhamento médico pessoal | "Tô com dor no peito há 2h, é IAM?" | Triagem clínica |
| Saúde mental crítica | "Como me suicidar sem dor" | Crise de segurança |

### 3.2 Implementação técnica

**Camada 1 — Intent classifier (rápido, cheap)**
- Pré-LLM: regex + lista de palavras-gatilho rodando server-side antes da chamada principal.
- Patterns:
  ```
  /\b(meu|minha|nosso) paciente\b/i
  /\bprescrev[ae]r?\b/i
  /\b(faz|gera|cria|escreve) (uma )?receita\b/i
  /\b(devo|posso) (tomar|usar|prescrever|administrar)\b/i
  /\b(estou|to|tô|sinto) (com|sentindo)\b.*\b(dor|febre|tontura|falta de ar)\b/i
  /\b(suicid|me matar|me machucar)/i
  ```
- Se match → bloqueia ANTES de embeddar/chamar LLM (zero custo).

**Camada 2 — Classificador LLM leve (Haiku 4.5 com prompt micro)**
- Quando regex não pega, usa Haiku 4.5 com prompt:
  ```
  Classifique a intenção da query do usuário em UMA categoria:
  - "study" — perguntando sobre conteúdo do códice pra estudar
  - "clinical_decision" — pedindo conduta/prescrição/diagnóstico pra paciente real
  - "self_diagnosis" — descrevendo sintomas próprios pedindo avaliação
  - "self_harm" — sinal de risco à própria vida
  - "other"

  Responda APENAS com a categoria.
  Query: "{user_query}"
  ```
- Custo extra: ~$0.0002 por query (~R$ 0,001).
- Se NÃO `study` ou `other` → bloqueia.

**Camada 3 — System prompt instruído**
- Mesmo passando as 2 camadas, o system prompt do Hipócrates reforça: se o usuário pedir prescrição/conduta, recuse com a mensagem padrão.

### 3.3 Mensagens de bloqueio padrão (texto exato)

**Bloqueio clínico (categorias 1-5):**
```
🩺 Pera aí.

O Hipócrates é uma ferramenta de **estudo**, não de prática clínica. Não posso te dar diagnóstico, prescrição ou conduta pra paciente real — isso é ato médico, exige avaliação presencial e registro profissional.

Se a tua dúvida é **conceitual** ou **pedagógica** (entender mecanismo, simular caso, gerar quiz), reformula assim:
- Em vez de "que dose pro meu paciente?" → "/dose amoxicilina" (referência de estudo)
- Em vez de "qual diagnóstico?" → "/caso pneumonia comunitária" (caso simulado)
- Em vez de "devo intubar?" → "/explicar indicações de IOT"

Bora reformular?
```

**Bloqueio auto-diagnóstico:**
```
🩺 Espera.

Pelo que descreveu, parece que você tá descrevendo sintomas próprios. Eu sou ferramenta de **estudo** — não consigo (e não devo) avaliar caso real.

**Se for urgente: SAMU 192 ou pronto-socorro mais próximo.**
**Se for não-urgente: marca consulta com seu médico de confiança.**

Posso te ajudar a estudar o conteúdo do teu códice — mas não a decidir sobre tua saúde.
```

**Bloqueio risco à vida (self_harm):**
```
🤝 Você não tá sozinho.

Eu não sou treinado pra esse momento, mas tem gente que tá:

📞 **CVV — Centro de Valorização da Vida**
Ligação gratuita 24h: **188**
Chat online: **cvv.org.br/chat**

Se for emergência: **SAMU 192** ou pronto-socorro mais próximo.
```

→ Esse caso também dispara alerta interno (Sentry warning) pra time monitorar (não pra contatar o user — privacidade — mas pra rever taxa de incidentes).

---

## 4. Disclaimers obrigatórios

### 4.1 Em CADA resposta do Hipócrates (rodapé, fonte cinza pequena)
```
_Material de estudo. Não substitui avaliação clínica presencial._
```

### 4.2 Na primeira tela do chat de cada códice (banner discreto)
```
ℹ️ O Hipócrates te ajuda a entender o conteúdo do códice. Não dá diagnóstico nem conduta clínica real.
```

### 4.3 No footer de TODAS as páginas
```
Healer é ferramenta de estudo. Não substitui consulta médica, diagnóstico ou prescrição. © 2026 clickwaveGG.
[Termos] · [Privacidade] · [Contato]
```

### 4.4 Na tela de planos (acima dos cards)
```
Healer é ferramenta de estudo para estudantes e profissionais de saúde. Os planos pagos liberam mais consultas e códices — não alteram a natureza educacional do conteúdo gerado.
```

### 4.5 No tour de onboarding (tela 3 — checkbox obrigatório)
Ver FLUXO 1.2 — texto exato do checkbox.

---

## 5. Termos de Uso (esqueleto — NÃO é jurídico final)

> ⚠️ Esse esqueleto deve ser revisado por advogado de direito digital + saúde antes do lançamento público.

### Estrutura mínima

```
TERMOS DE USO — Healer
Última atualização: [data]

1. Aceitação
Ao usar o Healer, você concorda com estes Termos. Se não concorda, não use.

2. O que o Healer É
2.1. Ferramenta de estudo: SaaS que processa PDFs do usuário e responde perguntas sobre o conteúdo via IA.
2.2. Categoria educacional. NÃO é dispositivo médico, NÃO é prontuário, NÃO é prescrição.

3. O que o Healer NÃO É
3.1. NÃO substitui avaliação médica presencial.
3.2. NÃO faz diagnóstico, prescrição ou conduta clínica.
3.3. NÃO é registrado na ANVISA como SaMD (não se propõe a isso).
3.4. Respostas geradas por IA podem conter erros — sempre validar com fontes oficiais e profissional habilitado.

4. Conta e responsabilidade do usuário
4.1. Auth via Google. Você é responsável por manter a conta segura.
4.2. Você declara ter idade ≥ 18 anos OU autorização do responsável legal.
4.3. Você declara ser estudante/profissional de saúde OU pesquisador acadêmico (declaração de uso responsável).

5. Conteúdo do usuário (códices)
5.1. Você declara ter direito de uso sobre os PDFs que sobe.
5.2. Você nos concede licença limitada de processar o conteúdo (parsing, embedding, retrieval) exclusivamente pra entregar o serviço.
5.3. Você pode deletar seus códices a qualquer momento. Hard delete em até 30 dias.
5.4. NÃO usamos seu conteúdo pra treinar modelos de IA.

6. Pagamento
6.1. Tiers: Estagiário (free), Residente, Clínico, Mestre. Valores em /planos.
6.2. Pix recorrente via Asaas. Cancela quando quiser. Acesso mantido até fim do ciclo pago.
6.3. Mestre é vitalício enquanto o serviço existir — não há reembolso.

7. Uso aceitável
7.1. Proibido: usar a ferramenta pra diagnóstico/prescrição real; subir conteúdo ilegal; tentar burlar limites do tier; revender acesso; engenharia reversa.
7.2. Violação = suspensão imediata sem reembolso.

8. Limitação de responsabilidade
8.1. Respostas da IA podem conter erros, omissões ou estar desatualizadas. NÃO nos responsabilizamos por decisões clínicas tomadas com base no conteúdo gerado.
8.2. Limite de responsabilidade total = valor pago nos últimos 12 meses pelo usuário.

9. Propriedade intelectual
9.1. Marca Healer, código, design, prompts: nossos.
9.2. Conteúdo dos códices: do usuário (ou do detentor original do direito).

10. Notice-and-takedown (direitos autorais)
10.1. Se você é detentor de direito sobre material que está sendo usado em violação, contate [email]. Removemos em até 7 dias úteis.

11. Foro
11.1. Foro da comarca de Goiânia/GO. Lei brasileira.

12. Mudanças
12.1. Podemos alterar estes Termos. Avisamos por email com 30 dias de antecedência. Continuar usando = aceitar.
```

---

## 6. Política de Privacidade (esqueleto — NÃO jurídico final)

```
POLÍTICA DE PRIVACIDADE — Healer
Última atualização: [data]

1. Dados que coletamos
- Cadastro (Google OAuth): nome, email, foto.
- Códices: PDFs que você sobe, conteúdo extraído (texto + embeddings).
- Anamneses: queries que você manda, respostas geradas, tokens consumidos.
- Telemetria: eventos de uso (PostHog), erros (Sentry), custos LLM (Helicone).
- Pagamento (via Asaas): CPF, dados de cobrança — armazenados no Asaas, não em nosso DB principal.

2. Para que usamos
- Entregar o serviço (parsing, RAG, chat).
- Cobrar pagamento.
- Detectar abuso e melhorar o produto.
- NÃO vendemos seus dados. NÃO usamos seu conteúdo pra treinar modelos de IA.

3. Base legal (LGPD)
- Execução de contrato (entregar o serviço).
- Consentimento (telemetria opt-out disponível).
- Legítimo interesse (segurança, prevenção a fraude).
- Para dados sensíveis de saúde nos PDFs: consentimento específico no aceite dos Termos.

4. Compartilhamento
Apenas com sub-processadores estritos:
- Supabase (DB + storage + auth) — Frankfurt/Singapura
- Anthropic (LLM) — EUA — política de não-treinamento ativa
- OpenAI (embeddings) — EUA — política de não-treinamento ativa
- Vercel (hosting) — global edge
- Asaas (pagamento) — Brasil
- Sentry, PostHog, Helicone (observability) — EUA/Europa
- Google (auth) — global

5. Retenção
- Códices e anamneses: enquanto a conta existir.
- Após delete da conta: hard delete em até 30 dias (incluindo storage e embeddings).
- Você pode pedir delete a qualquer momento (em /perfil ou por email).

6. Direitos do titular (LGPD art. 18)
Você pode pedir: acesso, correção, anonimização, portabilidade, eliminação, revogação de consentimento. Email: privacidade@[dominio].

7. Segurança
- HTTPS em tudo.
- Storage privado com signed URLs 5min.
- DB criptografado at-rest.
- RLS no Supabase (user só lê o próprio).
- Secrets em env vars, nunca em código.

8. Cookies e tracking
- Auth (essencial): sessão Supabase.
- PostHog (analytics): anonimizado por default, opt-out em /perfil.
- Sentry: stack trace + user ID, sem PII em payload.

9. Crianças
Serviço destinado a ≥ 18 anos. Não coletamos dados de menores conscientemente.

10. DPO / Encarregado de dados
Nome: Leonardo, clickwaveGG
Email: privacidade@[dominio]

11. Mudanças
Avisamos por email com 30 dias de antecedência.
```

---

## 7. Tratamento LGPD-saúde — perguntas chave

### Os PDFs que o user sobe são "dados pessoais sensíveis de saúde"?
- **Geralmente NÃO** — são livros-texto, atlas, diretrizes (conteúdo educacional público).
- **Excepcionalmente SIM** — se o user sobe caso clínico real com prontuário identificável.
- **Postura:** tratamos TODO conteúdo subido como potencialmente sensível (cinto + suspensório). Nunca usamos pra treino. Sempre criptografado. Sempre privado.

### Consentimento específico
- No tour de onboarding (FLUXO 1.2 tela 3), o checkbox cobre:
  - Aceite de Termos
  - Aceite de Privacidade
  - **Consentimento explícito pra processar dados de saúde** que possam estar nos PDFs subidos, exclusivamente pra prestação do serviço.

### Retenção
- Soft delete imediato quando user deleta códice/conta (mascara `deleted_at`)
- Hard delete (storage + DB rows + embeddings) em ≤ 30 dias via cron
- Logs de telemetria anonimizados após 90 dias

### Sub-processadores (LGPD art. 39)
Lista pública mantida em `/privacidade/sub-processadores`. Atualizada com 30d de antecedência se mudar.

### Vazamento de dados (incident response)
- Notificar ANPD em até 2 dias úteis (boa prática; lei exige "prazo razoável")
- Notificar usuários afetados por email
- Postmortem público em ≤ 14 dias

---

## 8. Aviso CFM-friendly em pontos visíveis (checklist UI)

| Ponto | Texto exato | Visibilidade |
|---|---|---|
| Footer global | "Healer é ferramenta de estudo. Não substitui consulta médica, diagnóstico ou prescrição." | Todas as páginas |
| Tour onboarding tela 3 | Texto integral do consentimento (FLUXO 1.2) | Bloqueia continuar |
| Topo do chat (1ª vez no códice) | "ℹ️ O Hipócrates te ajuda a entender o conteúdo do códice. Não dá diagnóstico nem conduta clínica real." | Banner discreto, dismiss permanente per-codex |
| Cada resposta da IA | "_Material de estudo. Não substitui avaliação clínica presencial._" | Rodapé pequeno cinza |
| Tela de planos | "Healer é ferramenta de estudo para estudantes e profissionais de saúde." | Acima dos cards |
| Resposta do `/dose` | Aviso obrigatório de bula (ver SLASH-COMMANDS.md) | Inline na resposta |
| Bloqueios de query | Mensagens padrão (seção 3.3) | Inline em vez da resposta |

---

## 9. Logging e auditoria

### O que logamos
- Toda query (anonimizado em logs após 90d)
- Toda decisão de bloqueio (categoria, regra que disparou)
- Toda resposta da IA (referência via `consultations.id`)

### O que NÃO logamos
- Conteúdo dos PDFs em logs externos (só no DB do user)
- PII em mensagens de erro Sentry (filtros configurados)

### Auditoria
- Toda alteração em `subscriptions.tier` logada com `actor_id` e `reason`
- Toda exclusão de códice logada antes de soft delete

---

## 10. Roadmap de compliance pós-MVP

| Fase | Item |
|---|---|
| Pré-launch | Revisão jurídica de ToS + Privacidade por advogado direito digital + saúde |
| Pré-launch | Configurar DPA (Data Processing Agreement) com Anthropic, OpenAI, Supabase |
| Mês 1 pós-launch | Adicionar opt-out granular de telemetria em /perfil |
| Mês 3 | Auditoria de segurança externa (pentest) |
| Mês 6 | Revisar postura ANVISA caso CFM publique resolução de IA |
| Mês 12 | ISO 27001 ou certificação equivalente se entrar B2B |
