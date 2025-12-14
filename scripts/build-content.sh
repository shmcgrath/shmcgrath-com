#!/usr/bin/env bash

# Exit on error
set -e

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

blog_objects=()
M4_BLOG=""

printf "\n%s" "Using content directory: $CONTENT_DIR"
printf "\n%s" "Using build directory: $BUILD_DIR"

mkdir -p "$BUILD_DIR"
mkdir -p "$(pwd)/tmp"

m4 "templates/page.html" > "tmp/page.html"

# Process page content
while IFS= read -r file; do
	base=$(basename "${file%.*}")
	output="${BUILD_DIR}/${base}.html"
	draft=$(pandoc "${file}" --template=<(echo '$draft$') --to=plain)

	if [ "${draft}" = "false" ]; then
		printf "\n%s" "Processing page: $base -> $output"

		if [ "$base" = "search-results" ]; then
			m4 "templates/search-results.html" > "tmp/search-results.html"

		elif [ "$base" = "blog" ]; then
			find "$CONTENT_DIR/blog" -maxdepth 1 -type f -name '*.md' | while read -r article; do
				title=$(pandoc "${file}" --template=<(echo '$title$') --to=plain)
				title=${title:-""}

				author=$(pandoc "${file}" --template=<(echo '$author$') --to=plain)
				author=${author:-""}

				description=$(pandoc "${file}" --template=<(echo '$description$') --to=plain)
				description=${description:-""}

				keywords=$(pandoc "${file}" --template=<(echo '$keywords$') --to=plain)
				keywords=${keywords:-""}

				printf "\n%s" "blog page: ${article}"
			done
			m4 "templates/blog.html" > "tmp/blog.html"
			make_nav_item_active "${base}"

		else
			cp -v "tmp/page.html" "tmp/${base}.html"
			make_nav_item_active "${base}"
		fi
	else
		printf "\n%s" "Not processing: ${base} draft status = true"
	fi

	pandoc "$file" \
		--output="$output" \
		--to=html \
		--template="tmp/${base}.html"
done < <(find "$CONTENT_DIR" -maxdepth 1 -type f -name '*.md')

printf "\n%s" "Processing complete."

