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
DATE_RAW=$(date +"%Y-%m-%dT%H:%M:%S%z")
DATE_FORMATTED=$(printf "%s:%s" "${DATE_RAW%??}" "${DATE_RAW#????????????}")

# Temp file
TMP_FILE="${FILE}.tmp"

# Update only the 'updated =' field
awk -v newdate="$DATE_FORMATTED" '
    {
        if ($0 ~ /^updated = /) {
            print "updated = \"" newdate "\""
            next
        }
        print
    }
' "$FILE" > "$TMP_FILE"

# Move temp file back to original
mv "$TMP_FILE" "$FILE"

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
