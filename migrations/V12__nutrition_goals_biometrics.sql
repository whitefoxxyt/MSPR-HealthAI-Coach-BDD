-- Slice 2 PRD #45 (MSPR2) : champs biometriques pour nutrition_engine.
--
-- Ajout des champs necessaires au calcul du TDEE via Mifflin-St Jeor :
--   gender, age, weight_kg, height_cm, activity_level.
--
-- Ces colonnes sont optionnelles : un profil sans biometrie reste valide
-- (nutrition_goals expose les cibles caloriques manuelles), mais l'endpoint
-- GET /me/macros renvoie alors profile_completion_required=true avec la
-- liste des champs manquants.
--
-- gender         : 'male' | 'female' (texte libre, valide cote application).
-- activity_level : sedentary / light / moderate / active / very_active.
-- weight_kg      : NUMERIC(5,2), couvre 0.00 a 999.99 kg.
-- height_cm      : NUMERIC(5,2), couvre 0.00 a 999.99 cm.

ALTER TABLE nutrition_goals
    ADD COLUMN IF NOT EXISTS gender VARCHAR(10),
    ADD COLUMN IF NOT EXISTS age INTEGER,
    ADD COLUMN IF NOT EXISTS weight_kg NUMERIC(5, 2),
    ADD COLUMN IF NOT EXISTS height_cm NUMERIC(5, 2),
    ADD COLUMN IF NOT EXISTS activity_level VARCHAR(20);
