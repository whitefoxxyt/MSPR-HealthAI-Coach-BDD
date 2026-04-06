-- Contraintes d'unicité pour l'idempotence des loaders ETL
ALTER TABLE nutrition_entries ADD CONSTRAINT uq_nutrition_entry UNIQUE NULLS NOT DISTINCT (food_name, category, meal_type, source);

ALTER TABLE exercise_entries ADD CONSTRAINT uq_exercise_entry UNIQUE NULLS NOT DISTINCT (
    workout_type,
    duration_min,
    calories_burned,
    heart_rate_avg,
    heart_rate_max,
    source
);

ALTER TABLE biometric_entries ADD CONSTRAINT uq_biometric_entry UNIQUE NULLS NOT DISTINCT (
    weight_kg,
    height_cm,
    bmi,
    fat_percentage,
    heart_rate_rest,
    heart_rate_avg,
    heart_rate_max,
    source
);