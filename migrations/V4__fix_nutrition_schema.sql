-- Fix nutrition_entries schema
-- Ajouter la colonne carbsg si elle n'existe pas (ou renommer carbs_g)
ALTER TABLE nutrition_entries
ADD COLUMN IF NOT EXISTS carbsg DECIMAL(8, 2);

-- Copier les données si carbs_g existe et carbsg est vide
UPDATE nutrition_entries
SET carbsg = carbs_g
WHERE carbsg IS NULL AND carbs_g IS NOT NULL;

