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
date_rfc3339=$(date "+%Y-%m-%dT%H:%M:%S%z" | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/')
date_rfc5322=$(date +"%a, %d %b %Y %H:%M:%S %z")

# Filepath
DIR="$(pwd)/content/posts"
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

# Create file with YAML frontmatter
{
    printf "%s\n" "---"
    printf "%s\n" "title: ${TITLE}"
    printf "%s\n" "subtitle:"
    printf "%s\n" "author: Sarah H. McGrath"
    printf "%s\n" "description:"
    printf "%s\n" "keywords:"
    printf "%s\n" "date: ${date_rfc3339}"
    printf "%s\n" "date_updated:"
    printf "%s\n" "date_updated_rfc5322:"
    printf "%s\n" "date_published:"
    printf "%s\n" "date_published_rfc5322:"
    printf "%s\n" "slug: $(date +"%Y-%m-%d")-${TITLE_SLUG}"
    printf "%s\n" "in_search_index: true"
    printf "%s\n" "draft: true"
    printf "%s\n\n" "---"
} > "$FILE"

printf "New post created: %s\n" "$FILE"

# Open it in $VISUAL if set, else fallback to vi
if [ -n "$VISUAL" ]; then
    "$VISUAL" "$FILE"
else
    vi "$FILE"
fi
