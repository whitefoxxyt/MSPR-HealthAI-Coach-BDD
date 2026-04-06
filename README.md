# MSPR HealthAI Coach - BDD

Microservice base de donnees PostgreSQL 16 pour la plateforme HealthAI Coach.

Ce depot est autonome et agnostique : il ne depend d'aucun autre microservice.
Il cree le reseau Docker `mspr_data_network` que les autres services (ETL, API, AUTH) peuvent rejoindre en tant que reseau externe.

## Demarrage

```bash
cp .env.example .env
# Editer .env avec vos valeurs
docker compose up -d
```

Le service est pret quand le healthcheck passe (`healthy`).

## Variables d'environnement

| Variable | Defaut | Description |
|----------|--------|-------------|
| `DB_NAME` | `healthai` | Nom de la base |
| `DB_USER` | `healthai_user` | Utilisateur PostgreSQL |
| `DB_PASSWORD` | `password` | Mot de passe (a changer) |
| `DB_PORT` | `5432` | Port expose sur l'hote |

## Migrations

Les migrations SQL sont dans `migrations/` et sont executees automatiquement au premier demarrage via `docker-entrypoint-initdb.d`.

| Fichier | Contenu |
|---------|---------|
| `V1__init_schema.sql` | Schema principal : users, exercises, nutrition_entries, exercise_entries, biometric_entries, etl_logs |
| `V2__diet_recommendations.sql` | Table diet_recommendations |
| `V3__add_unique_constraints.sql` | Contraintes d'unicite pour les ON CONFLICT |

## Reseau Docker

Ce compose cree le reseau `mspr_data_network`.
Pour connecter un autre microservice :

```yaml
networks:
  mspr_data_network:
    external: true
```

## Connexion directe

```
host: localhost
port: 5432 (configurable via DB_PORT)
database: healthai
```

## Schema de la base de donnees

```mermaid
erDiagram
    users {
        bigserial id PK
        varchar email
        varchar username
        varchar password_hash
        varchar role
        boolean is_premium
        integer age
        varchar gender
        decimal weight_kg
        decimal height_cm
        varchar objective
        timestamp created_at
        timestamp last_activity
    }
    exercises {
        bigserial id PK
        varchar external_id
        varchar name
        text[] body_parts
        text[] target_muscles
        text[] secondary_muscles
        text[] equipments
        text instructions
        varchar gif_url
        varchar source
        timestamp created_at
    }
    nutrition_entries {
        bigserial id PK
        bigint user_id FK
        varchar food_name
        varchar category
        varchar meal_type
        decimal calories
        decimal protein_g
        decimal carbs_g
        decimal fat_g
        decimal fiber_g
        decimal sugars_g
        decimal sodium_mg
        decimal water_ml
        varchar source
        varchar status
        timestamp created_at
    }
    exercise_entries {
        bigserial id PK
        bigint user_id FK
        varchar workout_type
        decimal duration_min
        decimal calories_burned
        integer steps
        integer heart_rate_avg
        integer heart_rate_max
        varchar source
        varchar status
        timestamp created_at
    }
    biometric_entries {
        bigserial id PK
        bigint user_id FK
        decimal weight_kg
        decimal height_cm
        decimal bmi
        decimal fat_percentage
        integer heart_rate_rest
        integer heart_rate_avg
        integer heart_rate_max
        varchar blood_pressure
        varchar source
        varchar status
        timestamp created_at
    }
    diet_recommendations {
        bigserial id PK
        varchar external_patient_id
        integer age
        varchar gender
        decimal weight_kg
        decimal height_cm
        decimal bmi
        varchar disease_type
        varchar severity
        varchar physical_activity_level
        decimal daily_caloric_intake
        decimal cholesterol_mg_dl
        decimal blood_pressure_mmhg
        decimal glucose_mg_dl
        varchar dietary_restrictions
        varchar allergies
        varchar preferred_cuisine
        decimal weekly_exercise_hours
        decimal adherence_to_diet_plan
        decimal nutrient_imbalance_score
        varchar diet_recommendation
        varchar source
        timestamp created_at
    }
    etl_logs {
        bigserial id PK
        varchar source_name
        timestamp started_at
        timestamp finished_at
        integer rows_read
        integer rows_inserted
        integer rows_rejected
        integer error_count
        varchar status
        text details
    }

    users ||--o{ nutrition_entries : "user_id"
    users ||--o{ exercise_entries : "user_id"
    users ||--o{ biometric_entries : "user_id"
```

Tables independantes (pas de FK) : `exercises`, `diet_recommendations`, `etl_logs`.
