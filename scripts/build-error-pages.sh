#!/usr/bin/env bash

DEFAULT_BUILD_DIR="$(pwd)/public"
BUILD_DIR="${1:-$DEFAULT_BUILD_DIR}"
ERROR_BUILD_DIR=$BUILD_DIR/error

mkdir -p "$ERROR_BUILD_DIR"

# List of error pages
# TITLE BODY URL

ERROR_PAGES=(
	"401 Authorization Required|ERROR 401: AUTHORIZATION REQUIRED|401"
	"403 Forbidden|ERROR 403: FORBIDDEN|403"
	"404 Not Found|ERROR 404: NOT FOUND|404"
	"500 Internal Service Error|ERROR 500: INTERNAL SERVER ERROR|500"
	"502 Bad Gateway|ERROR 502: BAD GATEWAY|502"
	"503 Service Unavailable|ERROR 503: SERVICE UNAVAILABLE|503"
)

mkdir -p "$(pwd)/tmp"
m4 templates/error.html > tmp/error.html

for page in "${ERROR_PAGES[@]}"; do
	IFS="|" read -r TITLE BODY URL <<< "$page"

	pandoc --output="$ERROR_BUILD_DIR/$URL.html" \
		--template="$(pwd)/tmp/error.html" \
		--variable title="$TITLE" \
		--variable body="$BODY" \
		< /dev/null
done
