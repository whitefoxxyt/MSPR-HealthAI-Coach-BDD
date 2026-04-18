-- Conversion de etl_logs.details de TEXT vers JSONB.
-- Permet de stocker des métriques structurées (stats par table, qualité par colonne,
-- raisons de rejet, durée) au lieu d'un message texte libre.
-- Les valeurs TEXT existantes sont encapsulées en JSON string valide.

ALTER TABLE etl_logs
    ALTER COLUMN details TYPE JSONB
    USING CASE WHEN details IS NULL THEN NULL ELSE to_jsonb(details) END;
