#!/usr/bin/env sh
#
# Minify all CSS files in static/ that are not already minified, only if needed

set -e

if ! command -v minify >/dev/null 2>&1; then
  printf "Error: 'minify' binary not found.\n"
  exit 2
fi

CSS_FILES=$(find static/ -type f -name '*.css' ! -name '*.min.css')

if [ -z "$CSS_FILES" ]; then
  printf "No CSS files found to minify.\n"
  exit 0
fi

MINIFIED=0
SKIPPED=0

for css in $CSS_FILES; do
  OUT="${css%.css}.min.css"

  if [ ! -f "$OUT" ] || [ "$css" -nt "$OUT" ]; then
    printf "Minifying %s...\n" "$css"
    minify --mime text/css "$css" > "$OUT"

    ORIG_SIZE=$(wc -c < "$css" | awk '{$1/=1024; printf "%.1f", $1}')
    MIN_SIZE=$(wc -c < "$OUT" | awk '{$1/=1024; printf "%.1f", $1}')
    SAVINGS=$(awk "BEGIN {printf \"%.1f\", 100 - ($MIN_SIZE / $ORIG_SIZE * 100)}")

    printf "Done: %s → %s (Saved: %s%%)\n\n" "$css" "$OUT" "$SAVINGS"
    MINIFIED=$((MINIFIED + 1))
  else
    printf "Skipping %s (already up-to-date)\n" "$css"
    SKIPPED=$((SKIPPED + 1))
  fi
done

printf "\nSummary: %s file(s) minified, %s file(s) skipped.\n" "$MINIFIED" "$SKIPPED"
printf "All CSS files processed.\n"

