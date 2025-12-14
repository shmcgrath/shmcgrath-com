#!/usr/bin/env bash

# Exit on error
set -e

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

printf "\n%s" "Using content directory: $CONTENT_DIR"
printf "\n%s" "Using build directory: $BUILD_DIR"

mkdir -pv "$BUILD_DIR"
mkdir -pv "$(pwd)/tmp"

# array to hold json objects as they are built
json_objects=()
rss_items=()
SITE_URL="https://shmcgrath.com"

while IFS= read -r file; do
	base=$(basename "${file%.*}")
	in_search_index=$(pandoc "${file}" --template=<(echo '$in_search_index$') --to=plain)
	draft=$(pandoc "${file}" --template=<(echo '$draft$') --to=plain)

	if [[ "${in_search_index}" == "true" && "${draft}" == "false" ]]; then

		printf "\n%s" "Processing page: $base"

		title=$(pandoc "${file}" --template=<(echo '$title$') --to=plain)
		title=${title:-""}

		author=$(pandoc "${file}" --template=<(echo '$author$') --to=plain)
		author=${author:-""}

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

		body=$(pandoc "${file}" --template=<(echo '$body$') --to=plain 2>/dev/null \
			| tr '\n' ' ' \
			| sed 's/  */ /g; s/^ *//; s/ *$//' \
			| jq --raw-input --slurp . | sed 's/^"//; s/"$//')
		body=${body:-""}

		file_json=$(jq --null-input \
						--arg title "${title}" \
						--arg author "${author}" \
						--arg description "${description}" \
						--argjson keywords "${keywords_array}" \
						--arg slug "${slug}" \
						--arg url "${url}" \
						--arg body "${body}" \
						'{title: $title, author: $author, description: $description, keywords: $keywords, slug: $slug, url: $url, body: $body}')

		json_objects+=("$file_json")
		sitemap_urls+=("  <url><loc>$SITE_URL$url</loc></url>")

		 if [[ "$file" == "$CONTENT_DIR/blog/"* ]]; then
			date_published=$(pandoc "${file}" --template=<(echo '$date_published$') --to=plain)
			if [ -z "${date_published}" ]; then
				date_published=$(date -R)
			fi

            rss_items+=("  <item>
			    <title><![CDATA[$title]]></title>
				<link>$SITE_URL$url</link>
				<description><![CDATA[$description]]></description>
				<pubDate>${date_published}</pubDate>
			</item>")
		fi

	else
		printf "\n%s" "Not processing: ${base} check in_search_index or draft status"
	fi

done < <(find "$CONTENT_DIR" -type f -name '*.md')

printf '%s\n' "${json_objects[@]}" | jq --slurp '.' > "$BUILD_DIR/search_index.en.json"

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
