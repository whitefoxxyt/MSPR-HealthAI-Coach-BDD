-- Slice 1 PRD #45 (MSPR2) : persistance des nouveaux champs metier AI-Nutrition.
--
-- meal_analyses :
--   imbalances     : tags structures {nutrient, status, delta_pct, target_value,
--                    actual_value, unit}. Liste vide quand le profil utilisateur est
--                    incomplet (pas de TDEE calculable).
--   serving_sizes  : 3 portions (small / medium / large) par item detecte avec
--                    macros recalculees. Reperes PNNS via le mapping Food-101 -> PNNS.
--   meal_type      : breakfast / lunch / dinner / snack. NULL = fallback TDEE/4.
--
-- meal_plans :
--   compliance_status   : full / partial_budget / static_fallback. Sortie de la boucle
--                         DeCRIM-light. Default 'full' pour la retro-compatibilite des
--                         lignes pre-V11.
--   compliance_warnings : strings explicitant les relachements de contraintes (par ex.
--                         budget depasse de X EUR). NULL ou tableau vide quand full.

ALTER TABLE meal_analyses
    ADD COLUMN IF NOT EXISTS imbalances JSONB,
    ADD COLUMN IF NOT EXISTS serving_sizes JSONB,
    ADD COLUMN IF NOT EXISTS meal_type TEXT;

ALTER TABLE meal_plans
    ADD COLUMN IF NOT EXISTS compliance_status TEXT NOT NULL DEFAULT 'full',
    ADD COLUMN IF NOT EXISTS compliance_warnings TEXT[];
