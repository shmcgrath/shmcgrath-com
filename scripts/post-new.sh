#!/usr/bin/env sh

# Check for title argument
if [ $# -lt 1 ]; then
    printf "Enter post title: "
    IFS= read -r TITLE
else
    TITLE="$1"
fi

# Exit if still empty
if [ -z "$TITLE" ]; then
    printf "Error: No title provided.\n" >&2
    exit 1
fi

# Slugify title: lowercase, replace spaces with dashes, remove non-alphanum
TITLE_SLUG=$(printf "%s" "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

# Generate timestamps
DATE_RAW=$(date +"%Y-%m-%dT%H:%M:%S%z")  # ex: 2025-04-25T21:25:00-0400
DATE_FORMATTED=$(printf "%s:%s" "${DATE_RAW%??}" "${DATE_RAW#????????????}")

# Filepath
DIR="content/posts"
FILE="${DIR}/$(date +"%Y-%m-%d")-${TITLE_SLUG}.md"

# Create directory if needed
if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
fi

# Check if file exists
if [ -e "$FILE" ]; then
    printf "Error: File '%s' already exists.\n" "$FILE" >&2
    exit 1
fi

# Create file with TOML frontmatter
{
    printf "+++\n"
    printf "title = \"%s\"\n" "$TITLE"
    printf "slug = \"%s\"\n" "$(date +"%Y-%m-%d")-${TITLE_SLUG}"
    printf "authors = [\"Sarah H. McGrath\"]\n"
    printf "date = \"%s\"\n" "$DATE_FORMATTED"
    printf "updated = \"%s\"\n" "$DATE_FORMATTED"
    printf "in_search_index = true\n"
    printf "template = \"page.html\"\n"
    printf "draft = true\n"
    printf "[taxonomies]\n"
    printf "tags = []\n"
    printf "category = \"blog\"\n"
    printf "[extra]\n"
    printf "+++\n\n"
} > "$FILE"

printf "New post created: %s\n" "$FILE"

# Open it in $VISUAL if set, else fallback to vi
if [ -n "$VISUAL" ]; then
    "$VISUAL" "$FILE"
else
    vi "$FILE"
fi

