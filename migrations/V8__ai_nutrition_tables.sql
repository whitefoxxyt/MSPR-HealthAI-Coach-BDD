-- Tables pour le micro-service MSPR-AI-Nutrition (MSPR2).
-- meal_analyses  : resultats d'analyse photo de repas (HuggingFace + LLM)
-- meal_plans     : plans nutritionnels generes par LLM (Ollama / Gemma3:4b)
-- nutrition_goals: profil nutritionnel par utilisateur (1 ligne par user)
--
-- user_id est un BIGINT opaque venant du JWT (pas de FK car la table users
-- a ete droppee en V7). Le decode JWT est fait localement par AI-Nutrition
-- avec BETTER_AUTH_SECRET partage.

CREATE TABLE meal_analyses (
    id                BIGSERIAL PRIMARY KEY,
    user_id           BIGINT NOT NULL,
    photo_url         VARCHAR(500),
    detected_foods    JSONB NOT NULL DEFAULT '[]',
    macros            JSONB NOT NULL DEFAULT '{}',
    confidence_scores JSONB NOT NULL DEFAULT '{}',
    created_at        TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE meal_plans (
    id           BIGSERIAL PRIMARY KEY,
    user_id      BIGINT NOT NULL,
    plan         JSONB NOT NULL DEFAULT '{}',
    objective    VARCHAR(100),
    constraints  JSONB NOT NULL DEFAULT '{}',
    generated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE nutrition_goals (
    user_id         BIGINT PRIMARY KEY,
    calories_target INTEGER,
    protein_g       DECIMAL(8, 2),
    carbs_g         DECIMAL(8, 2),
    fat_g           DECIMAL(8, 2),
    allergies       TEXT[],
    diet_type       VARCHAR(50)
);

CREATE INDEX idx_meal_analyses_user_id    ON meal_analyses (user_id);
CREATE INDEX idx_meal_analyses_created_at ON meal_analyses (created_at DESC);
CREATE INDEX idx_meal_plans_user_id       ON meal_plans (user_id);
CREATE INDEX idx_meal_plans_generated_at  ON meal_plans (generated_at DESC);
