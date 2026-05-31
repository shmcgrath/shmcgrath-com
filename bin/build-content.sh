#!/usr/bin/env bash

# Exit on error
set -e

: "${M4_SITE_URL:?M4_SITE_URL not set}"

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"
TMP_DIR="$(pwd)/tmp"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

process_m4() {
	local page="$1"
	m4 -DM4_SITE_URL="${M4_SITE_URL}" \
	"$(pwd)/templates/${page}.html" > \
	"$TMP_DIR/${page}.html"
}

printf "\n%s" "Building content..."

mkdir -p "$BUILD_DIR/blog"
mkdir -p "$TMP_DIR"

process_m4 "page"
process_m4 "article"

# Process page content
while IFS= read -r file; do
	base=$(basename "${file%.*}")
	template="${base}"
	nav_var="nav_${base}=true"
	output="${BUILD_DIR}/${base}.html"
	draft=$(pandoc "${file}" --template=<(echo '$draft$') --to=plain)
	slug=$(pandoc "${file}" --template=<(echo '$slug$') --to=plain).html

	if [ "${draft}" = "false" ]; then
		if [ "$base" = "search" ]; then
			process_m4 "search"

		elif [ "$base" = "blog" ]; then
			
		mapfile -t blog_articles < <(
			find "$CONTENT_DIR/blog" -maxdepth 1 -type f -name '*.md' | while read -r article; do
				article_draft=$(pandoc "${article}" --template=<(echo '$draft$') --to=plain)
				# If article is a draft, skip
				[ "${article_draft}" = "true" ] && continue
				date_published=$(pandoc "$article" --template=<(printf "%s" '$date_published$') --to=plain)
				[ -z "$date_published" ] && continue

				printf "%s|%s\n" "$date_published" "$article"

			done | sort -r
		)

		for entry in "${blog_articles[@]}"; do
			IFS='|' read -r date_published article <<< "$entry"
			m4_chronological_archive_article="$(pandoc "$article" \
				--to=html \
				--template="$(pwd)/templates/_chronological_archive_article.html" \
				--wrap=none \
				--standalone=false)"
		done
			printf "%s" "$m4_chronological_archive_article" > "$TMP_DIR/chronological_archive.html"

			process_m4 "blog"
			m4 -DM4_SITE_URL="${M4_SITE_URL}" \
				"$(pwd)/templates/blog.html" > \
				"$TMP_DIR/blog.html"

		 elif [[ "$file" == "$CONTENT_DIR/blog/"* ]]; then
			template="article"
			# set blog nav class as "active" when showing a blog post with nav_var
			nav_var="nav_blog=true"
			full_slug="blog/${slug}"
			output="${BUILD_DIR}/blog/${base}.html"

		elif [ "$base" = "index" ]; then
			cp "tmp/page.html" "tmp/${base}.html"
			# make the h1 visually-hidden so it is there for accessibility
			awk '{gsub(/<h1>\$title\$<\/h1>/,"<h1 class=\"visually-hidden\">\$title\$</h1>"); print}' "tmp/${base}.html" > "tmp/${base}.html.tmp" && mv "tmp/${base}.html.tmp" "tmp/${base}.html"

		else
			cp "tmp/page.html" "tmp/${base}.html"
		fi
		pandoc "$file" --output="$output" --variable slug="${full_slug}" --variable "${nav_var}" --to=html --template="tmp/${template}.html" --lua-filter="bin/sourceCode-number-lines.lua" --wrap=none
	else
		printf "\n%s" "Not building content: ${base}; draft status = ${draft}"
	fi
done < <(find "$CONTENT_DIR" -type f -name '*.md')

printf "\n%s\n" "Content built."
