# Codex

> Transforme um PDF em um Códex.

SaaS de Q&A em PDF para estudantes de saúde — sobe qualquer livro, apostila ou atividade e converse com ele como um mestre curandeiro.

## Nicho

Faculdades de saúde: Medicina, Enfermagem, Biomedicina, Fisioterapia, Farmácia, Odontologia, Nutrição.

## Estrutura

- `index.html` — Landing page (V1.0, HTML estático)
- `brand/` — Brand assets, paleta, preview do brandbook
- `assets/` — Imagens, fontes, ícones

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
