#!/usr/bin/env bash

# Exit on error
set -e

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

printf "\nUsing content directory: $CONTENT_DIR"
printf "\nUsing build directory: $BUILD_DIR"

mkdir -p "$BUILD_DIR"

# Process page content
find "$CONTENT_DIR" -maxdepth 1 -type f -name '*.md' | while read -r file; do
	base=$(basename "${file%.*}")
	output="${BUILD_DIR}/${base}.html"

	tab="$(printf '\t')"
	nl=$'\n'
	tabs="${tab}${tab}${tab}${tab}${tab}"

	nav_links=""

	if [ "${base}" = "blog" ]; then
		nav_links+="${nl}${tabs}<li class=\"active\"><a href=\"/blog.html\">Blog</a></li>"
	else
		nav_links+="${nl}${tabs}<li><a href=\"/blog.html\">Blog</a></li>"
	fi

	for nav_file in ${CONTENT_DIR}/*.md; do
		nav_base="$(basename "${nav_file}" .md)"
		#nav_title="${nav_base^}"
		nav_title=pandoc ${nav_file} --template=<(echo '$title$') --to=plain

		if [ "${base}" = "${nav_base}" ]; then
			nav_links+="${nl}${tabs}<li class=\"active\"><a href=\"/${nav_base}.html\">${nav_title}</a></li>"
		else
			nav_links+="${nl}${tabs}<li><a href=\"/${nav_base}.html\">${nav_title}</a></li>"
		fi

	done

	mkdir -p "$(pwd)/tmp"
	m4 --define=M4_NAV_MENU="${nav_links}" templates/base.html > "tmp/${base}.html"

	printf "\nProcessing page: $base -> $output"

	#pandoc "$file" --output="$output" --to=html --template=./tmp/${base}.html
done



printf "\nProcessing complete."
