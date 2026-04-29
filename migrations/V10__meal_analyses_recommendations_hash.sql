-- Cache des recommandations LLM dans meal_analyses (MSPR2 / NUT-11).
--
-- recommendations_hash : empreinte SHA256 hex (64 chars) du tuple
--   (top_food_label, health_goal, imbalances triees). Cle de cache pour
--   eviter de relancer le LLM sur des contextes identiques. TTL applicatif
--   30 jours, filtre sur created_at lors du SELECT.
--
-- Mirroir de V9 qui a ajoute meal_plans.inputs_hash : meme largeur (64),
-- meme nullable (NULL = recommandation issue du fallback matrice, non cachee).

ALTER TABLE meal_analyses
    ADD COLUMN IF NOT EXISTS recommendations_hash VARCHAR(64);

CREATE INDEX IF NOT EXISTS idx_meal_analyses_recommendations_hash
    ON meal_analyses (recommendations_hash);
