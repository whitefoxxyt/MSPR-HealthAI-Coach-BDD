-- Cache PostgreSQL des recommandations LLM (issue NUT-11).
--
-- Cle de cache : SHA256 de (top_food_label, health_goal, imbalances_hash). Quand
-- une analyse precedente partage la meme cle et qu'elle est recente (< 30 jours),
-- on reutilise ses recommandations sans rappeler le LLM.

ALTER TABLE meal_analyses
    ADD COLUMN IF NOT EXISTS recommendations_hash VARCHAR(64);

CREATE INDEX IF NOT EXISTS idx_meal_analyses_recommendations_hash
    ON meal_analyses (recommendations_hash);
