#!/usr/bin/env bash

# Exit on error
set -e

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

printf "Using content directory: $CONTENT_DIR"
printf "Using build directory: $BUILD_DIR"

# Process blog posts
find "$CONTENT_DIR/blog" -type f -name '*.md' | while read -r file; do
  base=$(basename "${file%.*}")
  output="${BUILD_DIR}/blog/${base}.html"

  printf "Processing blog: $file -> $output"
  mkdir -p "$(dirname "$output")"

  pandoc "$file" --output="$output" --to=html --template=./templates/base.html
done

printf "Processing complete."
