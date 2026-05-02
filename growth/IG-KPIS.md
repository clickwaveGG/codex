# Codex — KPIs Instagram & Metas 30 Dias

**Documento:** métricas, metas e gatilhos de decisão para o Instagram do Codex
**Versão:** 2026-05-02
**Autor:** Catalyst (squad-growth)

---

## 1. Filosofia de medição

> **Princípio Catalyst:** vanity matters apenas como leading indicator. KPI que conta é negócio (waitlist signups → beta active → assinante pago).

Estrutura em 4 camadas, da mais "vaidosa" pra mais "real":

```
NORTH STAR (negócio):       inscritos waitlist no mês 1
   ↑
KPIs SECUNDÁRIOS (negócio): cliques bio, conv landing, abertura email, conv beta
   ↑
KPIs DE ENGAJAMENTO:        salvamentos, comentários, compartilhamentos, taxa engagement
   ↑
KPIs DE VAIDADE:            seguidores, alcance, impressões
```

Decisões importantes (matar série, ampliar pilar, abrir paid) são tomadas com base nos dois andares de cima — não nos dois de baixo.

---

## 2. Metas dos 30 dias (cenário base, conservador → ambicioso)

### 2.1 — VAIDADE (medida diária, comunicada semanalmente)

| Métrica | Meta conservadora | Meta base | Meta ambiciosa |
|---|---|---|---|
| **Seguidores ao final do mês 1** | 500 | 1.500 | 5.000+ |
| **Alcance acumulado mês 1** | 30.000 | 100.000 | 300.000+ |
| **Impressões acumuladas mês 1** | 80.000 | 300.000 | 1.000.000+ |
| **Visitas ao perfil mês 1** | 1.500 | 5.000 | 15.000+ |
| **Reels com 10k+ views** | 1 | 4 | 8+ |
| **Reels com 50k+ views (mini-viral)** | 0 | 1 | 3+ |

**Como ler:** se Leonardo tá na "conservadora" no D15, sinal pra reforçar pilar DOR (mais alcance) ou ampliar hashtags. Se tá na "ambiciosa", dobrar aposta nos formatos que estão funcionando.

### 2.2 — NEGÓCIO (medida diária, decisões semanais)

| Métrica | Meta conservadora | Meta base | Meta ambiciosa |
|---|---|---|---|
| **Cliques no link da bio mês 1** | 100 | 400 | 1.500+ |
| **Inscritos waitlist mês 1** | 150 | 1.000 | 3.000+ |
| **Inscritos waitlist via afiliado** | 30 | 100 | 500+ |
| **Beta-testers ativados (top 30 cadastra+ativa)** | 18 | 25 | 30 |
| **Conversão Free→Pago projetada (pós-beta)** | — | — | — (acontece pós mês 1) |

**Como ler:** Leonardo definiu meta de 1.000-3.000 inscritos waitlist. Isso casa com nossa "base → ambiciosa" se executar plano + ter 1 alavanca extra (viral, parceria forte, ou paid).

### 2.3 — ENGAJAMENTO (medida semanal)

| Métrica | Meta conservadora | Meta base | Meta ambiciosa |
|---|---|---|---|
| **Taxa de engajamento média (likes+comments+saves)/views** | 4% | 7% | 12%+ |
| **Comentários totais mês 1** | 200 | 600 | 2.000+ |
| **Salvamentos totais mês 1** | 300 | 1.000 | 3.000+ |
| **Compartilhamentos totais mês 1** | 100 | 400 | 1.500+ |
| **Stories views médias por sequência** | 50 | 200 | 800+ |
| **DMs recebidas mês 1** | 30 | 150 | 500+ |

**Como ler:** salvamentos é a métrica mais importante de engajamento pra Codex (sinaliza intenção real de "vou voltar nesse conteúdo"). Comentários são segundo (sinal de comunidade nascendo). Likes são último (mais ruído).

### 2.4 — CONVERSÃO ESPECÍFICA (etapas do funil — cross-ref `IG-FUNNEL.md`)

| Métrica | Meta |
|---|---|
| **CTR bio** (cliques link / visitas perfil) | 5% |
| **Conversão landing waitlist** (submit / view) | 25% |
| **Open rate Email #1 (boas-vindas)** | 60% |
| **Open rate Email #5 (DIA D)** | 70% |
| **Beta sign-up rate (top 30 ativa)** | 90% |
| **Beta D0 ativação completa** | 60% |

---

## 3. Cadência de medição

### Diária (5 min de manhã, Leonardo abre Meta Business Suite + PostHog)
- Inscritos waitlist nas últimas 24h
- Posts publicados ontem: views/likes/comments/saves
- Stories de ontem: views + respostas
- DMs novas
- Anomalias (post explodiu? CTR bio caiu?)

### Semanal (30 min toda segunda)
- Snapshot completo das 4 camadas
- Top 3 posts da semana (ranking por engajamento)
- Bottom 3 posts (entender o quê não funcionou)
- Funnel completo `IG-FUNNEL §5` — tendência semana sobre semana
- Decisões: qual pilar dobrar, qual matar, qual hipótese testar

### Mensal (1h ao final do mês)
- Retro completa: meta atingida em cada camada?
- ROI por canal (orgânico vs afiliado vs eventual paid)
- Decisão de pivot: matar conta? expandir pra TikTok? ativar paid?

### Ferramentas pra coleta
- **Meta Business Suite** (nativo IG) — vaidade + engajamento direto
- **PostHog** — funil + cliques bio + conversão landing + emails
- **Resend dashboard** — open rate + CTR emails
- **Google Sheet** consolidando o que importa por semana (Leonardo monta uma vez, atualiza domingo à noite)

---

## 4. Gatilhos de decisão (DO / KILL / BOOST)

### Quando MATAR uma série de conteúdo

Critério: 3 posts consecutivos do mesmo pilar abaixo da metade da média da conta.

Exemplo:
- Conta tem média 2.000 views por reel
- Pilar BASTIDORES tem 3 reels com 800, 600, 700 views
- → MATAR a série de bastidores. Substituir por mais DOR ou DEMO.

Outro critério: pilar com 4 posts consecutivos sem CTR pra bio. Sinal: pilar entretém mas não converte. Repensar CTAs ou matar.

### Quando DOBRAR uma série

Critério: 1 post passa 3x a média da conta em views OU saves OU comments.

Exemplo:
- Reel D5 (5 sinais que tu precisa de ferramenta nova) faz 30k views vs média 5k
- → Imediatamente: criar 3 reels mesma estrutura "5 sinais que..." em outras dores
- → Em 7 dias: virar série fixa "às sextas, sinais"

### Quando ABRIR paid media (Meta Ads)

Premissa Leonardo: budget paid R$ 0-2k disponível. Critérios pra ativar (qualquer um):

1. **Reel orgânico ultrapassa 50k views naturalmente** → boost com R$ 200-500 pra ampliar pra 200k+ (custo previsto R$ 5-10/k impressão pra esse perfil)
2. **Ativações da landing rodando bem** (conversão >20%) MAS volume de tráfego é o gargalo → R$ 500 em Meta Ads direcionando audiência similar a quem inscreveu
3. **Semana 4 antes do beta abrir, lista está em 60-70% da meta** → R$ 500-1.000 último push pra fechar a meta com paid
4. **Parceria com afiliado deu CPV (custo por visualização) muito eficiente** (estudante de medicina ativando waitlist a R$ 0.30) → boost orgânico do afiliado com R$ 200

### Quando NÃO abrir paid

- Conta tem <500 seguidores e CTR bio <3% (paid joga gasolina em problema de pitch)
- Landing converte <15% (paid traz tráfego que vaza no funil — gasta sem retorno)
- Mês 1 sem viral nenhum (sinal: orgânico não engajou, paid não vai consertar)

### Quando AMPLIAR pra TikTok

Esse é gatilho pro **mês 2-3**, não pro mês 1. Critérios pra abrir TikTok @codex.saude (mesmo handle):

1. IG já bate 1.500+ seguidores E pelo menos 2 reels com 50k+ views
2. Existe um repurposing fácil (reels do IG performam bem como TikTok)
3. Leonardo tem capacidade pra responder comentário em mais 1 plataforma (não dilui o IG)

Mês 1 = focar 100% no IG. TikTok é distração.

### Quando AMPLIAR pra Twitter/LinkedIn

Twitter (X): ativar SE o produto pegar tração com dev/founder community (build in public viraliza lá). Mês 2+, opcional.
LinkedIn: NÃO ativar pra esse produto (audiência B2C universitária não está no LinkedIn).

---

## 5. Métricas que NÃO importam (não seguir)

Pra evitar ruído na decisão:

- **Likes individuais** — likes são ruído. Saves e comments importam.
- **Reach demográfico micro** (idade exata por gênero) — só importa se tiver volume estatístico (1.000+ contas alcançadas).
- **Hora exata "ideal" de postar** — mito; o que importa é consistência. Postar 19h30 sempre.
- **Quantidade de hashtags usadas vs limite** — diferença marginal entre 9 e 30 tags. Foco no MIX certo, não na quantidade.
- **Seguidores por dia isolado** — observar tendência de 7 dias. Dia isolado pode oscilar.

---

## 6. Sinais de "tá funcionando" (greenlight)

Se NA SEMANA 4 desses sinais aparecerem, manter rumo no mês 2 sem mudanças grandes:

- ✓ 1.000+ inscritos na waitlist
- ✓ Pelo menos 2 reels com 30k+ views
- ✓ Salvamentos > 1.000 cumulativo
- ✓ DMs com gente perguntando "quando lança?" sem ser estimulada
- ✓ 3+ parcerias com afiliado fechadas
- ✓ Open rate emails consistentemente >45%
- ✓ Beta abriu com 30/30 confirmados ativando D0

---

## 7. Sinais de "tem problema" (red flags)

Se DOIS OU MAIS desses aparecerem, parar e RECALIBRAR antes de continuar mês 2:

- ✗ Crescimento de seguidores estagnado por 14 dias seguidos
- ✗ Inscritos waitlist <300 no D30 (muito abaixo da base)
- ✗ Open rate Email #1 <40% (problema de assunto/remetente)
- ✗ Conversão landing <12% (landing tá ruim)
- ✗ Zero parceria fechada após 15 outreach (pitch ou produto não convencendo)
- ✗ Top 30 do beta: <50% ativam (problema de produto, não de growth)
- ✗ Engagement rate cai mês a mês (audiência tá esfriando)

### Plano de contingência por red flag

| Red flag | Ação imediata |
|---|---|
| Crescimento estagnado | Variar formato — testar 2 reels novos com hooks fora do padrão |
| Inscritos baixos | Reescrever bio + landing → testar variante por 7 dias |
| Email open baixo | Trocar assunto + remetente → A/B com metade da lista |
| Landing conversão baixa | Tirar campos do form → simplificar pra só email |
| Zero parceria | Revisar pitch DM com copy-orqx → testar nova abordagem |
| Beta D0 baixo | Handoff `product-orqx` + `design-orqx` pra revisar onboarding |
| Engagement caindo | Aumentar pilar BASTIDORES (autenticidade) → cortar pilar fraco |

---

## 8. Decisões de pivot do plano (quando trocar estratégia)

### Pivot pequeno (revisar tática, manter estratégia)
**Quando:** 1 red flag por 7 dias.
**Ação:** ajustar tática (hashtags, horários, formato dominante) sem mudar pilares.

### Pivot médio (rebalançar pilares)
**Quando:** 2 red flags por 14 dias OU pilar inteiro abaixo de 50% da média.
**Ação:** matar 1 pilar (ex: cortar BASTIDORES), aumentar peso de outro (DEMO 25% → 40%).

### Pivot grande (repensar GTM)
**Quando:** 3+ red flags no D30 OU meta de waitlist <30% (menos de 300 inscritos).
**Ação:** convocar reunião com `sinapse-orqx` (Imperator) — pode indicar:
- Mensagem do produto não está clara → handoff `brand-orqx` ou `copy-orqx`
- Audiência IG não converte → testar TikTok ou Discord
- Produto ainda não tá pronto pra GTM → atrasar lançamento beta

### Não pivotar quando
- Apenas 1 semana ruim depois de 2 semanas boas (volatilidade normal de crescimento)
- Único reel ruim cercado de outros bons (post solto não define estratégia)
- Meta atingida em 2 das 3 camadas (negócio + engajamento bons, vaidade fraca = OK)

---

## 9. Reportagem semanal (template — Leonardo preenche em 15 min)

```
SEMANA [1/2/3/4] — [intervalo de datas]

📊 VAIDADE
- Seguidores: [X] (+[Y] na semana, [Z%] vs semana anterior)
- Alcance acumulado: [X]
- Reels publicados: [N] (top: "[nome]" com [X]k views)

💼 NEGÓCIO
- Inscritos waitlist na semana: [X] (cumulativo: [Y])
- Cliques bio: [X]
- Conversão landing: [X%]
- Top fonte de inscritos: [orgânico / afiliado / paid]

🤝 ENGAJAMENTO
- Engagement rate médio: [X%]
- Top post (saves): "[nome]" com [X] saves
- DMs novas: [X]

🎯 DECISÕES DA SEMANA
- DOBRAR: [pilar/série que vai escalar]
- MATAR: [pilar/série que vai cortar]
- TESTAR: [hipótese nova pra próxima semana]

⚠️ RED FLAGS
- [se houver]

✅ GREEN FLAGS
- [se houver]

📅 PRÓXIMA SEMANA
- [3-5 ações concretas]
```

Salvar em `growth/WEEKLY-REPORTS/` (criar pasta quando começar).

---

## 10. Visão consolidada — tabela única (a régua do mês 1)

| Camada | Métrica | D7 | D14 | D21 | D30 |
|---|---|---|---|---|---|
| VAIDADE | Seguidores | 100 | 400 | 800 | 1.500 |
| VAIDADE | Alcance acumulado | 8k | 30k | 60k | 100k |
| NEGÓCIO | Cliques bio cumulativo | 30 | 120 | 250 | 400 |
| NEGÓCIO | Waitlist signups cumulativo | 30 | 200 | 600 | 1.000 |
| NEGÓCIO | Parcerias fechadas | 0 | 1 | 3 | 5 |
| ENGAJAMENTO | Engagement rate médio | 6% | 7% | 7% | 7% |
| ENGAJAMENTO | Saves cumulativo | 80 | 300 | 600 | 1.000 |
| ENGAJAMENTO | DMs cumulativo | 15 | 60 | 100 | 150 |
| FUNIL | CTR bio | 4% | 5% | 5% | 5% |
| FUNIL | Conv landing | 22% | 25% | 25% | 25% |
| FUNIL | Open rate emails | — | 55% | 50% | 60% (D5) |
| BETA | Top 30 ativados | — | — | — | 25 |

---

**Fim do IG-KPIS.md.** Última seção: report final pro Leonardo.
