#!/usr/bin/env bash

# Exit on error
set -e

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"
TMP_DIR="$(pwd)/tmp"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

printf "\n%s" "Building sitemap..."

mkdir -p "$BUILD_DIR"
mkdir -p "$TMP_DIR"

: "${M4_SITE_URL:?M4_SITE_URL not set}"
SITE_URL=${M4_SITE_URL}

while IFS= read -r file; do
	base=$(basename "${file%.*}")
	draft=$(pandoc "${file}" --template=<(echo '$draft$') --to=plain)
	if [[ "${draft}" == "false" ]]; then
		slug=$(pandoc "$file" --template=<(echo '$slug$') --to=plain | tr -d '\n')
		if [ -z "$slug" ]; then
			slug="$(basename "$file" .md)"
		fi
		if [[ "$file" == "$CONTENT_DIR/blog/"* ]]; then
			section="/blog"
		else
			section=""
		fi
		url="${section}/${slug}.html"
		# XML Dates and URLs
		date_updated=$(pandoc "$file" --template=<(echo '$date_updated$') --to=plain | tr -d '\n')
		date_edited=$(pandoc "$file" --template=<(echo '$date_edited$') --to=plain | tr -d '\n')
		date_published=$(pandoc "$file" --template=<(echo '$date_published$') --to=plain | tr -d '\n')

		lastmod="$date_updated"

		if [ -z "$lastmod" ]; then
			lastmod="$date_edited"
		fi

		if [ -z "$lastmod" ]; then
			lastmod="$date_published"
		fi
		if [ -z "$lastmod" ]; then
			lastmod=$(date -u "+%Y-%m-%dT%H:%M:%SZ")
		fi

		# normalize index.html → /
		if [ "$url" = "/index.html" ] || [ "$url" = "index.html" ]; then
		  url="/"
		fi
		sitemap_urls+=("$(printf '  <url><loc>%s%s</loc><lastmod>%s</lastmod></url>' "$SITE_URL" "$url" "$lastmod")")
	else
		printf "\n%s" "Not adding ${base} to sitemap. || Draft: ${draft}"
	fi
done < <(find "$CONTENT_DIR" -type f -name '*.md')

# Write sitemap
SITEMAP_FILE="$BUILD_DIR/sitemap.xml"

cat > "$SITEMAP_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
EOF

for u in "${sitemap_urls[@]}"; do
	printf "%s\n" "$u" >> "$SITEMAP_FILE"
done

printf "%s\n" "</urlset>" >> "$SITEMAP_FILE"

printf "\nSitemap written to %s\n" "$SITEMAP_FILE"
