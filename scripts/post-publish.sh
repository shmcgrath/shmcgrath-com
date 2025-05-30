#!/usr/bin/env sh

#!/bin/sh

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
DATE_RAW=$(date +"%Y-%m-%dT%H:%M:%S%z")
DATE_FORMATTED=$(printf "%s:%s" "${DATE_RAW%??}" "${DATE_RAW#????????????}")
DATE_ONLY=$(date +"%Y-%m-%d")

# Temp file
TMP_FILE="${FILE}.tmp"

# Process file
awk -v newdate="$DATE_FORMATTED" -v newdateonly="$DATE_ONLY" '
    BEGIN { changed_draft = 0 }
    {
        if ($0 ~ /^date = /) {
            print "date = \"" newdate "\""
            next
        }
        if ($0 ~ /^updated = /) {
            print "updated = \"" newdate "\""
            next
        }
        if ($0 ~ /^draft = false/) {
            print "draft = true"
            changed_draft = 1
            next
        }
        if ($0 ~ /^slug = /) {
            match($0, /slug = \"([0-9]{4}-[0-9]{2}-[0-9]{2})-(.*)\"/, parts)
            if (parts[2] != "") {
                print "slug = \"" newdateonly "-" parts[2] "\""
                next
            }
        }
        print
    }
    END {
        if (changed_draft == 0) {
            printf "Warning: no draft = false found.\n" > "/dev/stderr"
        }
    }
' "$FILE" > "$TMP_FILE"

# Overwrite original
mv "$TMP_FILE" "$FILE"

printf "Updated post: %s\n" "$FILE"
