#!/usr/bin/env bash

# Exit on error
set -e

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

printf "\n%s" "[GSI] Content directory: $CONTENT_DIR"
printf "\n%s" "[GSI] Build directory: $BUILD_DIR"

mkdir -pv "$BUILD_DIR"
mkdir -pv "$(pwd)/tmp"

# array to hold json objects as they are built
json_objects=()
rss_items=()
SITE_URL="https://shmcgrath.com"

process_words () {
	local input="$1"
	local split_char="${2:-$'\n'}"

	echo "$input" \
		| tr "$split_char" ' ' \
		| tr '[:upper:]' '[:lower:]' \
		| tr -d '[:punct:]' \
		| tr '\r\n' ' ' \
		| awk '{for(i=1;i<=NF;i++) print $i}' \
		| sort -u \
		| paste -sd ' ' /dev/stdin
}

words_to_json_array () {
	local words="$1"

	jq --null-input \
		--arg words "$words" \
		'$words | split(" ") | map(select(length > 0))'
}

while IFS= read -r file; do
	base=$(basename "${file%.*}")
	in_search_index=$(pandoc "${file}" --template=<(echo '$in_search_index$') --to=plain)
	draft=$(pandoc "${file}" --template=<(echo '$draft$') --to=plain)

	if [[ "${in_search_index}" == "true" && "${draft}" == "false" ]]; then

		printf "\n%s" "Generating search index for: $base"

		title=$(pandoc "${file}" --template=<(echo '$title$') --to=plain)
		title=${title:-""}

		author=$(pandoc "${file}" --template=<(echo '$author$') --to=plain)
		author=${author:-""}

		# tr: replaces newline with space
		# sed: removes leading and trailing spaces and makes multiple spaces one
		description=$(pandoc "${file}" --template=<(echo '$description$') --to=plain 2>/dev/null \
			| tr '\n' ' ' \
			| sed 's/  */ /g; s/^ *//; s/ *$//')
		description=${description:-""}

		keywords=$(pandoc "${file}" --template=<(echo '$keywords$') --to=plain)
		keywords=${keywords:-""}
		if [[ -z "$keywords" ]]; then
			keywords_array='[]'
		else
			keywords_array=$(jq --null-input --arg k "$keywords" '$k | split(" ")')
		fi

		slug=$(pandoc "${file}" --template=<(echo '$slug$') --to=plain)
		slug=${slug:-""}

		url="/${file#$CONTENT_DIR/}"; url="${url%.md}"
		url=${url:-""}

		# tr: replaces newline with space
		# sed: removes leading and trailing spaces and makes multiple spaces one
		# sed after jq: sed removed the surrounding doublequotes
		body=$(pandoc "${file}" --template=<(echo '$body$') --to=plain 2>/dev/null \
			| tr '\n' ' ' \
			| sed 's/  */ /g; s/^ *//; s/ *$//' \
			| jq --raw-input --slurp . | sed 's/^"//; s/"$//')
		body=${body:-""}

# Pre-tokenize and normalize (lowercase + remove empty tokens)
		title_words=$(process_words "$title")
		title_words_array=$(words_to_json_array "$title_words")
		author_words=$(process_words "$author")
		author_words_array=$(words_to_json_array "$author_words")
		description_words=$(process_words "$description")
		description_words_array=$(words_to_json_array "$description_words")
		body_words=$(process_words "$body")
		body_words_array=$(words_to_json_array "$body_words")
		slug_words=$(process_words "$slug" "-")
		slug_words_array=$(words_to_json_array "$slug_words")

		file_json=$(jq --null-input \
						--arg title "${title}" \
						--arg author "${author}" \
						--arg summary "${description}" \
						--arg slug "${slug}" \
						--arg url "${url}" \
						--arg body "${body}" \
						--argjson keywords "${keywords_array}" \
						--argjson titleWords "${title_words_array}" \
						--argjson authorWords "${author_words_array}" \
						--argjson summaryWords "${description_words_array}" \
						--argjson slugWords "${slug_words_array}" \
						--argjson bodyWords "${body_words_array}" \
            '{title: $title, author: $author, summary: $summary, keywords: $keywords, slug: $slug, url: $url, body: $body, titleWords: $titleWords, slugWords: $slugWords, authorWords: $authorWords, summaryWords: $summaryWords, bodyWords: $bodyWords}')

		json_objects+=("$file_json")
		sitemap_urls+=("  <url><loc>$SITE_URL$url</loc></url>")

		 if [[ "$file" == "$CONTENT_DIR/blog/"* ]]; then
			date_published=$(pandoc "${file}" --template=<(echo '$date_published$') --to=plain)
			if [ -z "${date_published}" ]; then
				date_published=$(date "+%Y-%m-%dT%H:%M:%S%z" | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/')
			fi

            rss_items+=("  <item>
			    <title><![CDATA[$title]]></title>
				<link>$SITE_URL$url</link>
				<description><![CDATA[$description]]></description>
				<pubDate>${date_published}</pubDate>
			</item>")
		fi

	else
		printf "\n%s" "Not generating search index for: ${base} || Search Index: ${in_search_index} || Draft: ${draft}"
	fi

done < <(find "$CONTENT_DIR" -type f -name '*.md')

printf '%s\n' "${json_objects[@]}" | jq --slurp --compact-output '.' > "$BUILD_DIR/search_index.en.json"

printf "\n%s\n" "Search index written to $BUILD_DIR/search_index.en.json"

# Write RSS feed
RSS_FILE="$BUILD_DIR/rss.xml"
cat > "$RSS_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
	<title>Sarah H. McGrath's Blog</title>
	<link>$SITE_URL</link>
  <description>A collection of sporadic writings</description>
EOF

for item in "${rss_items[@]}"; do
    echo "$item" >> "$RSS_FILE"
done

echo "</channel></rss>" >> "$RSS_FILE"
printf "RSS feed written to %s\n" "$RSS_FILE"

# Write sitemap
SITEMAP_FILE="$BUILD_DIR/sitemap.xml"

cat > "$SITEMAP_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
EOF

for u in "${sitemap_urls[@]}"; do
	echo "$u" >> "$SITEMAP_FILE"
done


echo "</urlset>" >> "$SITEMAP_FILE"
printf "Sitemap written to %s\n" "$SITEMAP_FILE"
