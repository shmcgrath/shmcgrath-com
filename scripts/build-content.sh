#!/usr/bin/env bash

# Exit on error
set -e

: "${M4_SITE_URL:?M4_SITE_URL not set}"

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"
TMP_DIR="$(pwd)/tmp"
m4_chronological_archive=""

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

process_m4() {
	local page="$1"
	m4 -DM4_SITE_URL="${M4_SITE_URL}" \
	"$(pwd)/templates/${page}.html" > \
	"$TMP_DIR/${page}.html"
}

printf "\n%s" "[BC] Content directory: $CONTENT_DIR"
printf "\n%s" "[BC] Build directory: $BUILD_DIR"

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
	url=$(pandoc "${file}" --template=<(echo '$slug$') --to=plain).html

	if [ "${draft}" = "false" ]; then
		printf "\n%s" "Building content: $base"

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
			m4_chronological_archive+="$(pandoc "$article" \
				--to=html \
				--template="$(pwd)/templates/_chronological_article_archive.html" \
				--standalone=false)"
		done

			process_m4 "blog"
			m4 -DM4_SITE_URL="${M4_SITE_URL}" \
				-DM4_CHRONOLOGICAL_ARCHIVE="${m4_chronological_archive}" \
				"$(pwd)/templates/blog.html" > \
				"$TMP_DIR/blog.html"

		 elif [[ "$file" == "$CONTENT_DIR/blog/"* ]]; then
			template="article"
			# set blog nav class as "active" when showing a blog post with nav_var
			nav_var="nav_blog=true"
			url="blog/${url}"
			output="${BUILD_DIR}/blog/${base}.html"

		elif [ "$base" = "index" ]; then
			cp "tmp/page.html" "tmp/${base}.html"
			# make the h1 visually-hidden so it is there for accessibility
			awk '{gsub(/<h1>\$title\$<\/h1>/,"<h1 class=\"visually-hidden\">\$title\$</h1>"); print}' "tmp/${base}.html" > "tmp/${base}.html.tmp" && mv "tmp/${base}.html.tmp" "tmp/${base}.html"

		else
			cp "tmp/page.html" "tmp/${base}.html"
		fi
		pandoc "$file" --output="$output" --variable url="${url}" --variable "${nav_var}" --to=html --template="tmp/${template}.html"
	else
		printf "\n%s" "Not building content: ${base}; draft status = ${draft}"
	fi
done < <(find "$CONTENT_DIR" -type f -name '*.md')

printf "\n%s" "build-content.sh complete."
