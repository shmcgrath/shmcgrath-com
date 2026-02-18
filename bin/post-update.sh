#!/usr/bin/env sh

# Check for fzf
if ! command -v fzf >/dev/null 2>&1; then
    printf "Error: fzf not installed.\n" >&2
    exit 1
fi

# Check for file argument
if [ $# -lt 1 ]; then
    FILE=$(find content/posts -type f -name '*.md' | sort | fzf --prompt="Select post to publish/edit: ")
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

# Generate timestamp
date_rfc3339=$(date "+%Y-%m-%dT%H:%M:%S%z" | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/')
date_rfc5322=$(date +"%a, %d %b %Y %H:%M:%S %z")

# Temp file
TMP_FILE="${FILE}.tmp"

awk \
  -v updated="$date_rfc3339" \
  -v updated5322="$date_rfc5322" '
BEGIN {
    seen_updated = 0
    seen_updated5322 = 0
}
{
    if ($0 ~ /^date_updated:/) {
        print "date_updated: " updated
        seen_updated = 1
        next
    }

    if ($0 ~ /^date_updated_rfc5322:/) {
        print "date_updated_rfc5322: " updated5322
        seen_updated5322 = 1
        next
    }

    print
}
END {
    if (!seen_updated)
        printf "Warning: date_updated not found\n" > "/dev/stderr"
    if (!seen_updated5322)
        printf "Warning: date_updated_rfc5322 not found\n" > "/dev/stderr"
}
' "$FILE" > "$TMP_FILE"

if mv "$TMP_FILE" "$FILE"; then
    printf "Updated updated-dates in: %s\n" "$FILE"
else
    printf "Error: failed to update %s\n" "$FILE" >&2
    rm -f "$TMP_FILE"
    exit 1
fi

# Append the Edit/Update/Post Publication section
{
    printf "\n"
    printf "## Edit/Update/Post Publication Note:\n\n"
} >> "$FILE"

printf "Updated 'updated' field and added post-publication note: %s\n" "$FILE"

# Open for editing
if [ -n "$VISUAL" ]; then
    "$VISUAL" "$FILE"
else
    vi "$FILE"
fi
