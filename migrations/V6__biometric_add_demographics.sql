-- Compléter biometric_entries pour le pipeline gym_tracking
ALTER TABLE biometric_entries
    ADD COLUMN IF NOT EXISTS gender VARCHAR(10),
    ADD COLUMN IF NOT EXISTS experience_level INTEGER;
