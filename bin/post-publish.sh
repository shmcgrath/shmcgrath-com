#!/usr/bin/env sh

# Check for fzf availability
if ! command -v fzf >/dev/null 2>&1; then
    printf "Error: fzf not installed.\n" >&2
    exit 1
fi

# Check for file argument
if [ $# -lt 1 ]; then
    FILE=$(find content/posts -type f -name '*.md' | sort | fzf --prompt="Select post to update: ")
else
    FILE="$1"
fi

# Exit if still empty
if [ -z "$FILE" ]; then
    printf "Error: No post file provided.\n" >&2
    exit 1
fi

# Check if file exists
if [ ! -f "$FILE" ]; then
    printf "Error: File '%s' does not exist.\n" "$FILE" >&2
    exit 1
fi

# Generate new timestamp
date_rfc3339=$(date "+%Y-%m-%dT%H:%M:%S%z" | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/')
date_rfc5322=$(date +"%a, %d %b %Y %H:%M:%S %z")

# Temp file
TMP_FILE="${FILE}.tmp"

awk \
  -v published="$date_rfc3339" \
  -v published5322="$date_rfc5322" '
BEGIN {
    seen_published = 0
    seen_published5322 = 0
    seen_draft = 0
}
{
    if ($0 ~ /^date_published:/) {
        print "date_published: " published
        seen_published = 1
        next
    }

    if ($0 ~ /^date_published_rfc5322:/) {
        print "date_published_rfc5322: " published5322
        seen_published5322 = 1
        next
    }

    if ($0 ~ /^draft:[[:space:]]*true/) {
        print "draft: false"
        seen_draft = 1
        next
    }

    print
}
END {
    if (!seen_published)
        printf "Warning: date_published not found\n" > "/dev/stderr"
    if (!seen_published5322)
        printf "Warning: date_published_rfc5322 not found\n" > "/dev/stderr"
    if (!seen_draft)
        printf "Warning: draft:true not found\n" > "/dev/stderr"
}
' "$FILE" > "$TMP_FILE"

if mv "$TMP_FILE" "$FILE"; then
    printf "Updated post: %s\n" "$FILE"
else
    printf "Error: failed to update %s\n" "$FILE" >&2
    rm -f "$TMP_FILE"
    exit 1
fi
