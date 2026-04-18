-- Ajout des données démographiques dans biometric_entries.
-- Ces colonnes proviennent du dataset Gym Members (Age, Gender, Experience_Level)
-- et répondent à l'exigence du PDF (section III.3) : "métriques utilisateurs
-- (répartition par âge, objectifs)".

ALTER TABLE biometric_entries
    ADD COLUMN age INTEGER,
    ADD COLUMN gender VARCHAR(10),
    ADD COLUMN experience_level INTEGER;
