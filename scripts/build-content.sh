#!/usr/bin/env bash

echo "BASH VERSION: $BASH_VERSION"
echo "BASH PATH: $BASH"
which bash

# Exit on error
set -e

: "${M4_SITE_URL:?M4_SITE_URL not set}"

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

make_nav_item_active() {
	local page="$1"
	# Patch nav: add class="active" to the correct <li>
	# macOS BSD sed
	sed -i '' "/<a href=\"\/${page}.html\">/s|<li>|<li class=\"active\">|" "tmp/${page}.html" 2>/dev/null || \
	# GNU sed
	sed -i "/<a href=\"\/${page}.html\">/s|<li>|<li class=\"active\">|" "tmp/${page}.html"
}

process_m4() {
	local page="$1"
	printf "\n%s" "DEBUG: process_m4 page=$page M4_SITE_URL=${M4_SITE_URL}"
	m4 -DM4_SITE_URL="${M4_SITE_URL}" \
	"$(pwd)/templates/${page}.html" > \
	"$(pwd)/tmp/${page}.html"
}

blog_objects=()
m4_chronological_archive=""

printf "\n%s" "Using content directory: $CONTENT_DIR"
printf "\n%s" "Using build directory: $BUILD_DIR"

mkdir -p "$BUILD_DIR/blog"
mkdir -p "$(pwd)/tmp"

process_m4 "page"
process_m4 "article"

# Process page content
while IFS= read -r file; do
	base=$(basename "${file%.*}")
	template="${base}"
	output="${BUILD_DIR}/${base}.html"
	draft=$(pandoc "${file}" --template=<(echo '$draft$') --to=plain)
	url=$(pandoc "${file}" --template=<(echo '$slug$') --to=plain).html

	if [ "${draft}" = "false" ]; then
		printf "\n%s" "Processing page: $base"

		if [ "$base" = "search" ]; then
			process_m4 "search"

		elif [ "$base" = "blog" ]; then
			
		mapfile -t blog_articles < <(
			find "$CONTENT_DIR/blog" -maxdepth 1 -type f -name '*.md' | while read -r article; do
				date_published=$(pandoc "$article" --template=<(printf "%s" '$date_published$') --to=plain)
				[ -z "$date_published" ] && continue

				printf "%s|%s\n" "$date_published" "$article"

			done | sort -r
		)

		for entry in "${blog_articles[@]}"; do
			IFS='|' read -r date_published article <<< "$entry"
			m4_chronological_archive+="$(pandoc "$article" \
				--to=html \
				--standalone=false)"
		done

			process_m4 "blog"
			m4 -DM4_SITE_URL="${M4_SITE_URL}" \
				-DM4_CHRONOLOGICAL_ARCHIVE="${m4_chronological_archive}" \
				"$(pwd)/templates/blog.html" > \
				"$(pwd)/tmp/blog.html"
			make_nav_item_active "${base}"

		 elif [[ "$file" == "$CONTENT_DIR/blog/"* ]]; then
			template="article"
			url="blog/${url}"
			output="${BUILD_DIR}/blog/${base}.html"
			printf "\n%s" "this is a blog page: ${base}"

		elif [ "$base" = "index" ]; then
			cp "tmp/page.html" "tmp/${base}.html"
			# make the h1 visually-hidden so it is there for accessibility
			awk '{gsub(/<h1>\$title\$<\/h1>/,"<h1 class=\"visually-hidden\">\$title\$</h1>"); print}' "tmp/${base}.html" > "tmp/${base}.html.tmp" && mv "tmp/${base}.html.tmp" "tmp/${base}.html"
			make_nav_item_active "${base}"

		else
			cp "tmp/page.html" "tmp/${base}.html"
			make_nav_item_active "${base}"
		fi
		pandoc "$file" --output="$output" --variable url="${url}" --to=html --template="tmp/${template}.html"
	else
		printf "\n%s" "Not processing: ${base}; draft status = true"
	fi
done < <(find "$CONTENT_DIR" -type f -name '*.md')

printf "\n%s" "Processing complete."
