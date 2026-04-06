-- UTILISATEURS
CREATE TABLE
    users (
        id BIGSERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        username VARCHAR(100) NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        role VARCHAR(20) NOT NULL DEFAULT 'USER',
        is_premium BOOLEAN NOT NULL DEFAULT FALSE,
        age INTEGER,
        gender VARCHAR(10),
        weight_kg DECIMAL(5, 2),
        height_cm DECIMAL(5, 1),
        objective VARCHAR(100),
        created_at TIMESTAMP NOT NULL DEFAULT NOW (),
        last_activity TIMESTAMP
    );

-- CATALOGUE D'EXERCICES
CREATE TABLE
    exercises (
        id BIGSERIAL PRIMARY KEY,
        external_id VARCHAR(100) UNIQUE NOT NULL,
        name VARCHAR(255) NOT NULL,
        body_parts TEXT ARRAY,
        target_muscles TEXT ARRAY,
        secondary_muscles TEXT ARRAY,
        equipments TEXT ARRAY,
        instructions TEXT,
        gif_url VARCHAR(500),
        source VARCHAR(50) NOT NULL DEFAULT 'EXERCISEDB',
        created_at TIMESTAMP NOT NULL DEFAULT NOW ()
    );

-- ENTRÉES NUTRITIONNELLES
CREATE TABLE
    nutrition_entries (
        id BIGSERIAL PRIMARY KEY,
        user_id BIGINT REFERENCES users (id) ON DELETE SET NULL,
        food_name VARCHAR(255) NOT NULL,
        category VARCHAR(100),
        meal_type VARCHAR(20),
        calories DECIMAL(8, 2),
        cholesterol_mg DECIMAL(8, 2),
        protein_g DECIMAL(8, 2),
        carbs_g DECIMAL(8, 2),
        fat_g DECIMAL(8, 2),
        fiber_g DECIMAL(8, 2),
        sugars_g DECIMAL(8, 2),
        sodium_mg DECIMAL(8, 2),
        water_ml DECIMAL(8, 2),
        source VARCHAR(50) NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'BRUT',
        created_at TIMESTAMP NOT NULL DEFAULT NOW ()
    );

-- SÉANCES D'EXERCICE
CREATE TABLE
    exercise_entries (
        id BIGSERIAL PRIMARY KEY,
        user_id BIGINT REFERENCES users (id) ON DELETE SET NULL,
        workout_type VARCHAR(100),
        duration_min DECIMAL(8, 2),
        calories_burned DECIMAL(8, 2),
        steps INTEGER,
        heart_rate_avg INTEGER,
        heart_rate_max INTEGER,
        source VARCHAR(50) NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'BRUT',
        created_at TIMESTAMP NOT NULL DEFAULT NOW ()
    );

-- DONNÉES BIOMÉTRIQUES
CREATE TABLE
    biometric_entries (
        id BIGSERIAL PRIMARY KEY,
        user_id BIGINT REFERENCES users (id) ON DELETE SET NULL,
        weight_kg DECIMAL(5, 2),
        height_cm DECIMAL(5, 1),
        bmi DECIMAL(5, 2),
        fat_percentage DECIMAL(5, 2),
        heart_rate_rest INTEGER,
        heart_rate_avg INTEGER,
        heart_rate_max INTEGER,
        blood_pressure VARCHAR(20),
        source VARCHAR(50) NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'BRUT',
        created_at TIMESTAMP NOT NULL DEFAULT NOW ()
    );

-- JOURNAL ETL
CREATE TABLE
    etl_logs (
        id BIGSERIAL PRIMARY KEY,
        source_name VARCHAR(100) NOT NULL,
        started_at TIMESTAMP NOT NULL,
        finished_at TIMESTAMP,
        rows_read INTEGER NOT NULL DEFAULT 0,
        rows_inserted INTEGER NOT NULL DEFAULT 0,
        rows_rejected INTEGER NOT NULL DEFAULT 0,
        error_count INTEGER NOT NULL DEFAULT 0,
        status VARCHAR(20) NOT NULL,
        details TEXT
    );

-- INDEXES
-- Recherche d'exercices par muscle ou partie du corps
CREATE INDEX idx_exercises_body_parts ON exercises USING GIN (body_parts);

CREATE INDEX idx_exercises_target_muscl ON exercises USING GIN (target_muscles);

CREATE INDEX idx_exercises_equipments ON exercises USING GIN (equipments);

-- Filtrage par utilisateur
CREATE INDEX idx_nutrition_user_id ON nutrition_entries (user_id);

CREATE INDEX idx_exercise_entry_user_id ON exercise_entries (user_id);

CREATE INDEX idx_biometric_user_id ON biometric_entries (user_id);

-- Filtrage par statut
CREATE INDEX idx_nutrition_status ON nutrition_entries (status);

CREATE INDEX idx_exercise_entry_status ON exercise_entries (status);

CREATE INDEX idx_biometric_status ON biometric_entries (status);

-- Monitoring ETL par source et par date
CREATE INDEX idx_etl_logs_source ON etl_logs (source_name);

CREATE INDEX idx_etl_logs_started ON etl_logs (started_at DESC);