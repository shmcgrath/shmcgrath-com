#!/usr/bin/env bash

# Exit on error
set -e

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

printf "\n%s" "Using content directory: $CONTENT_DIR"
printf "\n%s" "Using build directory: $BUILD_DIR"

mkdir -p "$BUILD_DIR"
mkdir -p "$(pwd)/tmp"

m4 "templates/page.html" > "tmp/page.html"

# Process page content
find "$CONTENT_DIR" -maxdepth 1 -type f -name '*.md' | while read -r file; do
	base=$(basename "${file%.*}")
	output="${BUILD_DIR}/${base}.html"

	printf "\n%s\n" "Processing page: $base -> $output"

	cp -v "tmp/page.html" "tmp/${base}.html"

	# Patch nav: add class="active" to the correct <li>
	# macOS BSD sed
	sed -i '' "/<a href=\"\/$base.html\">/s|<li>|<li class=\"active\">|" "tmp/${base}.html" 2>/dev/null || \
	# GNU sed
	sed -i "/<a href=\"\/$base.html\">/s|<li>|<li class=\"active\">|" "tmp/${base}.html"

	pandoc "$file" \
		--output="$output" \
		--to=html \
		--template="tmp/${base}.html"
done

printf "\n%s" "Processing complete."
