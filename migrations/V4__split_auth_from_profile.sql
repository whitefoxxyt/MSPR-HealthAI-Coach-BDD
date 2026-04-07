-- Étape 1 : ajouter auth_user_id nullable
ALTER TABLE users ADD COLUMN auth_user_id VARCHAR(255);

-- Étape 2 : remplir les lignes existantes avec un placeholder unique
UPDATE users SET auth_user_id = 'legacy_' || id::text;

-- Étape 3 : appliquer les contraintes
ALTER TABLE users ALTER COLUMN auth_user_id SET NOT NULL;
ALTER TABLE users ADD CONSTRAINT users_auth_user_id_unique UNIQUE (auth_user_id);

-- Étape 4 : supprimer les colonnes d'authentification
ALTER TABLE users
    DROP COLUMN password_hash,
    DROP COLUMN email,
    DROP COLUMN role,
    DROP COLUMN is_premium;
