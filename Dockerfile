FROM postgres:17-alpine

COPY migrations/*.sql /docker-entrypoint-initdb.d/
