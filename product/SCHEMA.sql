-- ============================================================================
-- SCHEMA SUPABASE POSTGRES — HEALER MVP
-- Versão: 1.0 · 2026-05-02
-- Stack: Supabase (Postgres 15 + pgvector + auth.users)
-- Aplicar em ordem. Após aplicar, rodar seeds (não incluídos aqui).
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 0. Extensões
-- ----------------------------------------------------------------------------

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgvector";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- busca textual em consultations

-- ----------------------------------------------------------------------------
-- 1. ENUMs
-- ----------------------------------------------------------------------------

CREATE TYPE user_tier AS ENUM ('estagiario', 'residente', 'clinico', 'mestre');

CREATE TYPE codex_status AS ENUM ('uploading', 'processing', 'ready', 'failed');

CREATE TYPE codex_category AS ENUM (
  'anatomia', 'fisiologia', 'bioquimica', 'farmacologia', 'patologia',
  'clinica_medica', 'cirurgia', 'pediatria', 'ginecologia_obstetricia',
  'psiquiatria', 'saude_coletiva', 'outros'
);

CREATE TYPE slash_command AS ENUM (
  'resumir', 'explicar', 'quizar', 'caso', 'diferenciar', 'dose'
);

CREATE TYPE subscription_status AS ENUM (
  'active', 'past_due', 'canceled', 'expired', 'pending'
);

CREATE TYPE billing_period AS ENUM ('monthly', 'yearly', 'lifetime');

-- ----------------------------------------------------------------------------
-- 2. TABLE: user_profiles (estende auth.users do Supabase)
-- ----------------------------------------------------------------------------
-- auth.users já tem id, email, etc. Aqui adicionamos campos de produto.

CREATE TABLE public.user_profiles (
  id                          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name                TEXT,
  avatar_url                  TEXT,
  tier                        user_tier NOT NULL DEFAULT 'estagiario',
  consultations_today         INT NOT NULL DEFAULT 0,
  consultations_today_reset_at TIMESTAMPTZ NOT NULL DEFAULT date_trunc('day', now() AT TIME ZONE 'America/Sao_Paulo'),
  total_consultations         INT NOT NULL DEFAULT 0,
  compliance_accepted_at      TIMESTAMPTZ,         -- aceite do disclaimer no onboarding
  terms_accepted_at           TIMESTAMPTZ,
  privacy_accepted_at         TIMESTAMPTZ,
  asaas_customer_id           TEXT,                -- vincula ao customer no Asaas
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at                  TIMESTAMPTZ
);

CREATE INDEX idx_user_profiles_tier ON public.user_profiles(tier) WHERE deleted_at IS NULL;
CREATE INDEX idx_user_profiles_asaas ON public.user_profiles(asaas_customer_id) WHERE asaas_customer_id IS NOT NULL;

-- Trigger: atualizar updated_at
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_user_profiles_updated
BEFORE UPDATE ON public.user_profiles
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- Trigger: criar profile automaticamente quando user faz signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, display_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ----------------------------------------------------------------------------
-- 3. TABLE: codices (PDFs subidos pelo user)
-- ----------------------------------------------------------------------------

CREATE TABLE public.codices (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id             UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  title               TEXT NOT NULL,
  category            codex_category NOT NULL DEFAULT 'outros',
  file_path           TEXT NOT NULL,           -- path no Supabase Storage bucket "codices"
  file_size_bytes     BIGINT NOT NULL,
  page_count          INT,                     -- preenchido após parsing
  status              codex_status NOT NULL DEFAULT 'uploading',
  status_message      TEXT,                    -- mensagem de erro se status = 'failed'
  cover_seed          TEXT NOT NULL,           -- hash determinístico pra capa procedural
  consultations_count INT NOT NULL DEFAULT 0,
  last_consulted_at   TIMESTAMPTZ,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMPTZ
);

CREATE INDEX idx_codices_user ON public.codices(user_id, updated_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_codices_status ON public.codices(status) WHERE status IN ('uploading', 'processing');
CREATE INDEX idx_codices_user_category ON public.codices(user_id, category) WHERE deleted_at IS NULL;

CREATE TRIGGER trg_codices_updated
BEFORE UPDATE ON public.codices
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- 4. TABLE: chunks (texto + embeddings de cada códice)
-- ----------------------------------------------------------------------------

CREATE TABLE public.chunks (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  codex_id    UUID NOT NULL REFERENCES public.codices(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE, -- denormalizado pra RLS performática
  page        INT NOT NULL,                    -- número da página no PDF original
  chunk_index INT NOT NULL,                    -- ordem do chunk dentro do códice
  content     TEXT NOT NULL,                   -- ~800 tokens
  token_count INT NOT NULL,
  embedding   VECTOR(1536) NOT NULL,           -- OpenAI text-embedding-3-small
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Índice ANN HNSW (mais rápido que ivfflat pra <1M chunks/codex)
-- ops cosseno (similarity = 1 - distance)
CREATE INDEX idx_chunks_embedding_hnsw ON public.chunks
  USING hnsw (embedding vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);

CREATE INDEX idx_chunks_codex ON public.chunks(codex_id, chunk_index);
CREATE INDEX idx_chunks_user ON public.chunks(user_id);

-- ----------------------------------------------------------------------------
-- 5. TABLE: consultations (histórico de Q&A)
-- ----------------------------------------------------------------------------

CREATE TABLE public.consultations (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id             UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  codex_id            UUID NOT NULL REFERENCES public.codices(id) ON DELETE CASCADE,
  query               TEXT NOT NULL,
  response            TEXT,                    -- pode ser parcial se streaming foi cancelado
  slash_command       slash_command,           -- NULL se foi pergunta livre
  citations           JSONB,                   -- [{page: 437, chunk_id: "..."}, ...]
  retrieved_chunks    JSONB,                   -- [{chunk_id, page, similarity}, ...] pra debug
  model_used          TEXT NOT NULL,           -- ex: 'claude-haiku-4-5', 'claude-sonnet-4-5'
  tokens_input        INT NOT NULL DEFAULT 0,
  tokens_output       INT NOT NULL DEFAULT 0,
  tokens_cached       INT NOT NULL DEFAULT 0,  -- pra calcular economia de cache
  cost_brl_cents      INT NOT NULL DEFAULT 0,  -- estimativa em centavos
  blocked             BOOLEAN NOT NULL DEFAULT false,
  block_reason        TEXT,                    -- categoria do bloqueio (ver COMPLIANCE)
  user_feedback       SMALLINT,                -- 1 = thumbs up, -1 = thumbs down, NULL = sem feedback
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_consultations_user_codex ON public.consultations(codex_id, created_at DESC);
CREATE INDEX idx_consultations_user ON public.consultations(user_id, created_at DESC);
CREATE INDEX idx_consultations_query_trgm ON public.consultations USING gin (query gin_trgm_ops);
CREATE INDEX idx_consultations_blocked ON public.consultations(blocked) WHERE blocked = true;

-- Trigger: atualizar contadores no codex e user_profile após inserir consultation
CREATE OR REPLACE FUNCTION public.handle_new_consultation()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.blocked = false THEN
    UPDATE public.codices
    SET consultations_count = consultations_count + 1,
        last_consulted_at   = NEW.created_at,
        updated_at          = NEW.created_at
    WHERE id = NEW.codex_id;

    UPDATE public.user_profiles
    SET consultations_today  = consultations_today + 1,
        total_consultations  = total_consultations + 1
    WHERE id = NEW.user_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_consultations_inserted
AFTER INSERT ON public.consultations
FOR EACH ROW EXECUTE FUNCTION public.handle_new_consultation();

-- ----------------------------------------------------------------------------
-- 6. TABLE: subscriptions (Asaas)
-- ----------------------------------------------------------------------------

CREATE TABLE public.subscriptions (
  id                       UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                  UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  tier                     user_tier NOT NULL,
  status                   subscription_status NOT NULL DEFAULT 'pending',
  period                   billing_period NOT NULL,
  asaas_subscription_id    TEXT UNIQUE,             -- ID no Asaas (NULL pra Mestre lifetime)
  asaas_customer_id        TEXT NOT NULL,
  current_period_start     TIMESTAMPTZ,
  current_period_end       TIMESTAMPTZ,             -- pra Mestre lifetime: NULL ou data muito longe
  amount_brl_cents         INT NOT NULL,            -- valor em centavos
  cancel_at_period_end     BOOLEAN NOT NULL DEFAULT false,
  canceled_at              TIMESTAMPTZ,
  created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_subscriptions_user ON public.subscriptions(user_id, status);
CREATE INDEX idx_subscriptions_asaas ON public.subscriptions(asaas_subscription_id) WHERE asaas_subscription_id IS NOT NULL;
CREATE INDEX idx_subscriptions_period_end ON public.subscriptions(current_period_end) WHERE status = 'active';

CREATE TRIGGER trg_subscriptions_updated
BEFORE UPDATE ON public.subscriptions
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ----------------------------------------------------------------------------
-- 7. TABLE: billing_events (log webhook Asaas pra auditoria/debug)
-- ----------------------------------------------------------------------------

CREATE TABLE public.billing_events (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
  subscription_id UUID REFERENCES public.subscriptions(id) ON DELETE SET NULL,
  asaas_event     TEXT NOT NULL,                   -- ex: 'PAYMENT_CONFIRMED', 'SUBSCRIPTION_CANCELED'
  asaas_payload   JSONB NOT NULL,                  -- payload completo pra auditoria
  processed       BOOLEAN NOT NULL DEFAULT false,
  processed_at    TIMESTAMPTZ,
  error_message   TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_billing_events_user ON public.billing_events(user_id, created_at DESC);
CREATE INDEX idx_billing_events_unprocessed ON public.billing_events(created_at) WHERE processed = false;

-- ============================================================================
-- 8. ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE public.user_profiles  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.codices        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chunks         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.consultations  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.billing_events ENABLE ROW LEVEL SECURITY;

-- user_profiles: user só lê/edita o próprio
CREATE POLICY "user_profiles_select_own" ON public.user_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "user_profiles_update_own" ON public.user_profiles
  FOR UPDATE USING (auth.uid() = id);

-- codices: user só CRUD os próprios
CREATE POLICY "codices_select_own" ON public.codices
  FOR SELECT USING (auth.uid() = user_id AND deleted_at IS NULL);

CREATE POLICY "codices_insert_own" ON public.codices
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "codices_update_own" ON public.codices
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "codices_delete_own" ON public.codices
  FOR DELETE USING (auth.uid() = user_id);

-- chunks: user só lê os do próprio códice (via user_id denormalizado)
CREATE POLICY "chunks_select_own" ON public.chunks
  FOR SELECT USING (auth.uid() = user_id);

-- INSERT/UPDATE/DELETE de chunks: somente service_role (pipeline backend)

-- consultations: user só CRUD as próprias
CREATE POLICY "consultations_select_own" ON public.consultations
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "consultations_insert_own" ON public.consultations
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "consultations_update_own" ON public.consultations
  FOR UPDATE USING (auth.uid() = user_id); -- pra feedback thumbs up/down

CREATE POLICY "consultations_delete_own" ON public.consultations
  FOR DELETE USING (auth.uid() = user_id);

-- subscriptions: user só lê as próprias (escrita só via service_role)
CREATE POLICY "subscriptions_select_own" ON public.subscriptions
  FOR SELECT USING (auth.uid() = user_id);

-- billing_events: nenhum acesso de cliente — só service_role
-- (sem policy = bloqueia tudo via RLS)

-- ============================================================================
-- 9. FUNÇÃO RPC: similarity search (RAG retrieval)
-- ============================================================================

-- Recebe codex_id, query embedding, top_k, threshold
-- Retorna top-k chunks ordenados por similarity, respeitando RLS via auth.uid()

CREATE OR REPLACE FUNCTION public.search_chunks(
  p_codex_id UUID,
  p_query_embedding VECTOR(1536),
  p_top_k INT DEFAULT 8,
  p_min_similarity FLOAT DEFAULT 0.65
)
RETURNS TABLE (
  chunk_id    UUID,
  page        INT,
  content     TEXT,
  similarity  FLOAT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Garantir que o codex pertence ao caller
  IF NOT EXISTS (
    SELECT 1 FROM public.codices
    WHERE id = p_codex_id AND user_id = auth.uid() AND deleted_at IS NULL
  ) THEN
    RAISE EXCEPTION 'codex not found or not owned by caller';
  END IF;

  RETURN QUERY
  SELECT
    c.id,
    c.page,
    c.content,
    1 - (c.embedding <=> p_query_embedding) AS similarity
  FROM public.chunks c
  WHERE c.codex_id = p_codex_id
    AND 1 - (c.embedding <=> p_query_embedding) >= p_min_similarity
  ORDER BY c.embedding <=> p_query_embedding
  LIMIT p_top_k;
END;
$$;

-- ============================================================================
-- 10. FUNÇÃO RPC: reset diário de consultations_today
-- ============================================================================
-- Rodar via cron Supabase ou Vercel Cron diariamente às 00:01 BRT

CREATE OR REPLACE FUNCTION public.reset_daily_consultations()
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  affected INT;
BEGIN
  UPDATE public.user_profiles
  SET consultations_today = 0,
      consultations_today_reset_at = date_trunc('day', now() AT TIME ZONE 'America/Sao_Paulo')
  WHERE consultations_today_reset_at < date_trunc('day', now() AT TIME ZONE 'America/Sao_Paulo');

  GET DIAGNOSTICS affected = ROW_COUNT;
  RETURN affected;
END;
$$;

-- ============================================================================
-- 11. CAPS POR TIER (lookup helper)
-- ============================================================================
-- Função auxiliar usada nas API routes pra checar limites. Pode virar table se quiser config dinâmica.

CREATE OR REPLACE FUNCTION public.tier_caps(p_tier user_tier)
RETURNS TABLE (
  max_codices         INT,
  max_consultations_day INT,
  allow_sonnet        BOOLEAN
)
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT * FROM (VALUES
    ('estagiario'::user_tier, 2,    50,   false),
    ('residente'::user_tier,  15,   300,  false),
    ('clinico'::user_tier,    99999, 1000, true),
    ('mestre'::user_tier,     99999, 1500, true)
  ) AS t(tier, max_codices, max_consultations_day, allow_sonnet)
  WHERE t.tier = p_tier;
$$;

-- ============================================================================
-- 12. SOFT DELETE → HARD DELETE (cron 30d)
-- ============================================================================

CREATE OR REPLACE FUNCTION public.hard_delete_old_soft_deleted()
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  affected INT;
BEGIN
  -- Hard delete codices soft-deletados há > 30d (chunks são CASCADE)
  DELETE FROM public.codices
  WHERE deleted_at IS NOT NULL AND deleted_at < now() - interval '30 days';

  GET DIAGNOSTICS affected = ROW_COUNT;
  RETURN affected;
END;
$$;

-- ============================================================================
-- 13. STORAGE BUCKET (executar no Supabase Dashboard ou via API)
-- ============================================================================
-- Bucket: "codices"
-- Public: false
-- File size limit: 80MB
-- Allowed MIME: application/pdf
-- Policies: auth.uid() must own the path (path = "{user_id}/{codex_id}.pdf")
--
-- INSERT/SELECT policy:
-- (bucket_id = 'codices') AND (auth.uid()::text = (storage.foldername(name))[1])

-- ============================================================================
-- FIM DO SCHEMA
-- ============================================================================
