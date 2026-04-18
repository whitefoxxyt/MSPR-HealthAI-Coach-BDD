-- Suppression des contraintes FK sur user_id dans les tables ETL.
-- Les datasets Kaggle sont des sources hétérogènes sans identifiant utilisateur commun.
-- La colonne user_id est conservée (nullable, sans référence) pour usage côté API.

ALTER TABLE nutrition_entries DROP CONSTRAINT IF EXISTS nutrition_entries_user_id_fkey;
ALTER TABLE exercise_entries DROP CONSTRAINT IF EXISTS exercise_entries_user_id_fkey;
ALTER TABLE biometric_entries DROP CONSTRAINT IF EXISTS biometric_entries_user_id_fkey;
