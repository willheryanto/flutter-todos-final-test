#!/bin/bash

#set -x
set -eo pipefail

if ! [ -x "$(command -v psql)" ]; then
	cat <<EOF
Error: psql is not installed.
EOF
	exit 1
fi

DB_USER=${POSTGRES_USER:=postgres}
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
DB_NAME="${POSTGRES_DB:=api}"
DB_PORT="${POSTGRES_PORT:=5433}"

docker run \
	-e POSTGRES_USER=${DB_USER} \
	-e POSTGRES_PASSWORD=${DB_PASSWORD} \
	-e POSTGRES_DB=${DB_NAME} \
	-p "${DB_PORT}":5432 \
	-d postgres \
	postgres -N 1000

sleep 2
export PGPASSWORD="${DB_PASSWORD}"
until psql -h localhost -p "${DB_PORT}" -U "${DB_USER}" -d "postgres" -c '\q'; do
	echo >&2 "Postgres is still unavailable - sleeping"
	sleep 1
done

echo >&2 "Postgres is up and running on port ${DB_PORT}"
