#!/usr/bin/env bash
# Export des tables nettoyees vers des fichiers CSV
# Usage : ./scripts/export_clean_data.sh [repertoire_de_sortie]
#
# Prerequis : le container mspr-healthai-db doit etre running
# Les donnees exportees sont celles inserees par l'ETL (status = BRUT ou VALIDE)

set -euo pipefail

OUTPUT_DIR="${1:-./exports}"
mkdir -p "$OUTPUT_DIR"

DB_USER="${DB_USER:-healthai_user}"
DB_NAME="${DB_NAME:-healthai}"
CONTAINER="mspr-healthai-db"

echo "Export vers $OUTPUT_DIR ..."

tables=(
    "users"
    "exercises"
    "nutrition_entries"
    "exercise_entries"
    "biometric_entries"
    "diet_recommendations"
)

for table in "${tables[@]}"; do
    echo "  -> $table"
    docker exec "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" \
        -c "\COPY $table TO STDOUT WITH CSV HEADER" \
        > "$OUTPUT_DIR/${table}.csv"
done

echo "Export termine : $(ls "$OUTPUT_DIR"/*.csv | wc -l) fichiers dans $OUTPUT_DIR"
