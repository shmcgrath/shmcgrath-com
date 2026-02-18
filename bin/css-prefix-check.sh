#!/usr/bin/env sh
#!/bin/sh
# Smart CSS Prefix Checker

if ! command -v fzf >/dev/null 2>&1; then
  printf "Error: 'fzf' is required but not installed.\n"
  exit 3
fi

SRC="$1"

if [ -z "$SRC" ]; then
  printf "No CSS file given. Searching...\n\n"
  CSS_FILES=$(find . -type f -name '*.css' ! -name '*.min.css')

  FILE_COUNT=$(printf "%s" "$CSS_FILES" | grep -c '^')

  if [ "$FILE_COUNT" -eq 0 ]; then
    printf "No CSS files found.\n"
    exit 1
  elif [ "$FILE_COUNT" -eq 1 ]; then
    SRC="$CSS_FILES"
    printf "Auto-selected %s\n" "$SRC"
  else
    SRC=$(printf "%s" "$CSS_FILES" | fzf --prompt='Select a CSS file to check: ')
  fi
fi

if [ -z "$SRC" ]; then
  printf "No file selected.\n"
  exit 1
fi

if [ ! -f "$SRC" ]; then
  printf "Selected file does not exist: %s\n" "$SRC"
  exit 1
fi

printf "Checking %s for missing vendor prefixes...\n\n" "$SRC"

# Define the properties and expected prefixes
check_prefix() {
  local property="$1"
  shift
  local prefixes="$@"

  for prefix in $prefixes; do
    if ! grep --quiet "$prefix" "$SRC"; then
      printf "Missing expected prefix: '%s' for property '%s'\n" "$prefix" "$property"
    fi
  done
}

# Now call checks
check_prefix "user-select" "-webkit-user-select" "-moz-user-select"
check_prefix "backdrop-filter" "-webkit-backdrop-filter"
check_prefix "appearance" "-webkit-appearance" "-moz-appearance"
check_prefix "hyphens" "-webkit-hyphens" "-ms-hyphens"
check_prefix "text-size-adjust" "-webkit-text-size-adjust" "-ms-text-size-adjust"
check_prefix "display:flex" "display: -webkit-box" "display: -ms-flexbox"
check_prefix "transform" "-webkit-transform"
check_prefix "transition" "-webkit-transition"
check_prefix "animation" "-webkit-animation"
check_prefix "position:sticky" "position: -webkit-sticky"

printf "\nDone checking.\n"

