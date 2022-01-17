#!/bin/bash

if ! [ -x "$(command -v pgcli)" ]; then
	cat <<EOF
Error: pgcli is not installed.
EOF
	exit 1
fi

if [ -z "$DATABASE_URL" ]; then
	echo "DATABASE_URL is not set"
	exit 1
fi

pgcli "$DATABASE_URL"
