# Avicena

> O conhecimento que cura.

SaaS de Q&A em PDF para estudantes de saúde — sobe qualquer livro, apostila ou atividade e consulta com o **Hipócrates** (assistente IA) como se fosse um preceptor experiente. Resposta com a página exata, sempre.

Nome inspirado em **Avicena (Ibn Sina, 980-1037)** — médico persa autor do *Cânone da Medicina*, principal livro-texto médico do mundo por mais de 600 anos.

> Nota: o nome interno do repositório (`codex`) e o projeto Vercel mantêm o codinome original por compatibilidade. O produto público chama-se **Avicena**.

## Nicho

Faculdades de saúde: Medicina, Enfermagem, Biomedicina, Fisioterapia, Farmácia, Odontologia, Nutrição.

## Estrutura

- `index.html` — Landing page (V1.0, HTML estático)
- `assets/` — Imagens, fontes, ícones (incluindo logo pixel art)
- `brand/` — Brand assets, paleta, preview do brandbook
- `product/` — PRD, fluxos, schema, roadmap
- `growth/` — Plano de Instagram + funil
- `finance/` — Unit economics + cenários

## Stack planejada (V1.0)

- Next.js 15 + Tailwind + shadcn
- Supabase (auth + Postgres + pgvector + storage)
- Anthropic Haiku 4.5 (LLM com prompt caching)
- OpenAI text-embedding-3-small (embeddings)
- Asaas (Pix recorrente + cartão)
- Vercel (deploy)

## Rodar local

Não exige build. Servidor estático qualquer:

```bash
npx serve
```

Abre `http://localhost:3000`.

## Deploy

Auto-deploy via Vercel a cada push na `main`.
