-- Suppression de la table users et des FK associees.
-- Les datasets sources (Kaggle) sont heterogenes et anonymises, sans
-- identifiant utilisateur commun. La table users heritée du schema
-- initial n'a plus de justification dans le modele ETL : les lignes
-- inserees par les pipelines ont toutes user_id NULL.
-- Le toilettage de l'API (entite User, UserController, references dans
-- les entites metier) sera traite dans une iteration ulterieure.

ALTER TABLE nutrition_entries DROP CONSTRAINT IF EXISTS nutrition_entries_user_id_fkey;
ALTER TABLE exercise_entries DROP CONSTRAINT IF EXISTS exercise_entries_user_id_fkey;
ALTER TABLE biometric_entries DROP CONSTRAINT IF EXISTS biometric_entries_user_id_fkey;

ALTER TABLE nutrition_entries DROP COLUMN IF EXISTS user_id;
ALTER TABLE exercise_entries DROP COLUMN IF EXISTS user_id;
ALTER TABLE biometric_entries DROP COLUMN IF EXISTS user_id;

DROP TABLE IF EXISTS users;
