-- RECOMMANDATIONS DIETETIQUES
CREATE TABLE
    diet_recommendations (
        id BIGSERIAL PRIMARY KEY,
        external_patient_id VARCHAR(20) UNIQUE NOT NULL,
        age INTEGER,
        gender VARCHAR(10),
        weight_kg DECIMAL(5, 2),
        height_cm DECIMAL(5, 1),
        bmi DECIMAL(5, 2),
        disease_type VARCHAR(100),
        severity VARCHAR(20),
        physical_activity_level VARCHAR(50),
        daily_caloric_intake DECIMAL(8, 2),
        cholesterol_mg_dl DECIMAL(8, 2),
        blood_pressure_mmhg DECIMAL(6, 1),
        glucose_mg_dl DECIMAL(8, 2),
        dietary_restrictions VARCHAR(255),
        allergies VARCHAR(255),
        preferred_cuisine VARCHAR(100),
        weekly_exercise_hours DECIMAL(5, 2),
        adherence_to_diet_plan DECIMAL(5, 2),
        nutrient_imbalance_score DECIMAL(5, 2),
        diet_recommendation VARCHAR(100),
        source VARCHAR(50) NOT NULL DEFAULT 'DIET_RECOMMENDATIONS',
        created_at TIMESTAMP NOT NULL DEFAULT NOW ()
    );

-- INDEXES
-- Filtrage par pathologie, régime recommandé et niveau d'activité
CREATE INDEX idx_diet_rec_disease ON diet_recommendations (disease_type);

CREATE INDEX idx_diet_rec_diet ON diet_recommendations (diet_recommendation);

CREATE INDEX idx_diet_rec_activity ON diet_recommendations (physical_activity_level);