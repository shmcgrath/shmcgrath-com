#!/usr/bin/env bash

# Exit on error
set -e

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"
TMP_DIR="$(pwd)/tmp"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

printf "\n%s" "Generating RSS feed..."

mkdir -pv "$BUILD_DIR"
mkdir -p "$TMP_DIR"

: "${M4_SITE_URL:?M4_SITE_URL not set}"
SITE_URL=${M4_SITE_URL}

RSS_ITEMS_FILE="$TMP_DIR/rss-items.xml"
: > "$RSS_ITEMS_FILE"

while IFS= read -r file; do
	draft=$(pandoc "${file}" --template=<(echo '$draft$') --to=plain)

	if [[ "${draft}" == "false" ]]; then

		title=$(pandoc "${file}" --template=<(echo '$title$') --to=plain)
		title=${title:-""}
		title=${title//]]>/]]&gt;}
		title=$(printf '%s' "$title" | tr -d '\n')

		# tr: replaces newline with space
		# sed: removes leading and trailing spaces and makes multiple spaces one
		description=$(pandoc "${file}" --template=<(echo '$description$') --to=plain 2>/dev/null \
			| tr '\n' ' ' \
			| sed 's/  */ /g; s/^ *//; s/ *$//')
		description=${description:-""}
		description=${description//]]>/]]&gt;}
		description=$(printf '%s' "$description" | tr -d '\n')

		slug=$(pandoc "$file" --template=<(echo '$slug$') --to=plain | tr -d '\n')
		if [ -z "$slug" ]; then
			slug="$(basename "$file" .md)"
		fi
		if [[ "$file" == "$CONTENT_DIR/blog/"* ]]; then
			section="/blog"
		else
			section=""
		fi
		url="${section}/${slug}.html"

		rss_date_published=$(pandoc "${file}" --template=<(echo '$date_published_rfc5322$') --to=plain)
		rss_date_published=$(printf "%s" "$rss_date_published" | tr -d '\n')
		if [ -z "${rss_date_published}" ]; then
			rss_date_published=$(date "+%a, %d %b %Y %H:%M:%S %z")
		fi

		rss_feed_item=$(
			m4 \
				-DM4_TITLE="$title" \
				-DM4_URL="${SITE_URL}${url}" \
				-DM4_DESCRIPTION="$description" \
				-DM4_PUBDATE="$rss_date_published" \
				-DM4_SITE_LAST_UPDATED="${SITE_LAST_UPDATED}" \
				"$(pwd)/templates/_rss-item.xml"
		)

		printf "%s\n" "$rss_feed_item" >> "$RSS_ITEMS_FILE"

	fi
done < <(find "$CONTENT_DIR/blog" -type f -name '*.md' | sort --reverse)
# Note the sort --reverse above sorts by filename
# Will need to implement a different sort for RSS
# if I stop using dates at the start of filenames

# Write RSS feed
RSS_FILE="$BUILD_DIR/feed.xml"
rss_items=$(cat "$RSS_ITEMS_FILE")
last_build_date=$(date +"%a, %d %b %Y %H:%M:%S %z")

m4 \
	-DM4_SITE_URL="$SITE_URL" \
	-DM4_RSS_BUILD_DATE="$last_build_date" \
	-DM4_RSS_ITEMS="$rss_items" \
	-DM4_SITE_LAST_UPDATED="${SITE_LAST_UPDATED}" \
	"$(pwd)/templates/rss-feed.xml" \
	> "$RSS_FILE"

printf "\nRSS feed written to %s\n" "$RSS_FILE"
