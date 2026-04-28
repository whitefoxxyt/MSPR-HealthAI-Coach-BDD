-- Enrichissement des tables AI-Nutrition (creees en V8) pour MSPR2.
--
-- nutrition_goals.health_goal : objectif sante de l'utilisateur. NULL = comportement
--   par defaut "balance" (utilise quand le profil n'est pas configure).
-- meal_plans.inputs_hash      : empreinte SHA256 des inputs canonicalises (objectif,
--   allergies triees, budget, regime, duree). Utilisee pour le cache PostgreSQL des
--   plans repas generes par LLM (Ollama / Gemma3:4b).
-- meal_analyses.recommendations : recommandations textuelles (LLM ou fallback matrice).

ALTER TABLE nutrition_goals
    ADD COLUMN IF NOT EXISTS health_goal VARCHAR(30);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'nutrition_goals_health_goal_check'
    ) THEN
        ALTER TABLE nutrition_goals
            ADD CONSTRAINT nutrition_goals_health_goal_check
            CHECK (health_goal IN ('weight_loss', 'muscle_gain', 'balance', 'sport_performance'));
    END IF;
END $$;

ALTER TABLE meal_plans
    ADD COLUMN IF NOT EXISTS inputs_hash VARCHAR(64);

CREATE INDEX IF NOT EXISTS idx_meal_plans_inputs_hash
    ON meal_plans (inputs_hash);

ALTER TABLE meal_analyses
    ADD COLUMN IF NOT EXISTS recommendations JSONB NOT NULL DEFAULT '[]';
