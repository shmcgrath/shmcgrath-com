#!/usr/bin/env bash

printf "\n%s" "starting build-error-pages.sh"

DEFAULT_BUILD_DIR="$(pwd)/public"
BUILD_DIR="${1:-$DEFAULT_BUILD_DIR}"
ERROR_BUILD_DIR=$BUILD_DIR/error

: "${M4_SITE_URL:?M4_SITE_URL not set}"

mkdir -p "$ERROR_BUILD_DIR"

TMP_DIR="$(pwd)/tmp"
mkdir -p "$TMP_DIR"

# List of error pages
# TITLE|BODY|URL
ERROR_PAGES=(
	"401 Authorization Required|ERROR 401: AUTHORIZATION REQUIRED|401"
	"403 Forbidden|ERROR 403: FORBIDDEN|403"
	"404 Not Found|ERROR 404: NOT FOUND|404"
	"500 Internal Service Error|ERROR 500: INTERNAL SERVER ERROR|500"
	"502 Bad Gateway|ERROR 502: BAD GATEWAY|502"
	"503 Service Unavailable|ERROR 503: SERVICE UNAVAILABLE|503"
)

m4 -DM4_SITE_URL="${M4_SITE_URL}" "$(pwd)/templates/page.html" > "$TMP_DIR/error.html"

for page in "${ERROR_PAGES[@]}"; do
	IFS="|" read -r TITLE BODY URL <<< "$page"

	pandoc --output="$ERROR_BUILD_DIR/$URL.html" \
		--template="$TMP_DIR/error.html" \
		--variable title="$TITLE" \
		--variable slug="$URL" \
		--variable body="<p class=\"error-body\">$BODY</p>" \
		< /dev/null
done

printf "\n%s" "build-error-pages.sh complete"
