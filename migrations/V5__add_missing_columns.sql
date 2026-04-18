-- Fix additional schema issues
-- Ajouter la colonne age à biometric_entries si elle n'existe pas
ALTER TABLE biometric_entries
ADD COLUMN IF NOT EXISTS age INTEGER;

