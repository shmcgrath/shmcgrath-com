#!/usr/bin/env bash

# Exit on error
set -e

# Defaults
DEFAULT_CONTENT_DIR="$(pwd)/content"
DEFAULT_BUILD_DIR="$(pwd)/public"

# Read in arguments
CONTENT_DIR="${1:-$DEFAULT_CONTENT_DIR}"
BUILD_DIR="${2:-$DEFAULT_BUILD_DIR}"

make_nav_item_active() {
	local page="$1"
	# Patch nav: add class="active" to the correct <li>
	# macOS BSD sed
	sed -i '' "/<a href=\"\/${page}.html\">/s|<li>|<li class=\"active\">|" "tmp/${page}.html" 2>/dev/null || \
	# GNU sed
	sed -i "/<a href=\"\/${page}.html\">/s|<li>|<li class=\"active\">|" "tmp/${page}.html"
}

blog_objects=()
m4_blog_archive_list=""

printf "\n%s" "Using content directory: $CONTENT_DIR"
printf "\n%s" "Using build directory: $BUILD_DIR"

mkdir -p "$BUILD_DIR"
mkdir -p "$(pwd)/tmp"

m4 "templates/page.html" > "tmp/page.html"
m4 "templates/article.html" > "tmp/article.html"

# Process page content
while IFS= read -r file; do
	base=$(basename "${file%.*}")
	template="${base}"
	output="${BUILD_DIR}/${base}.html"
	draft=$(pandoc "${file}" --template=<(echo '$draft$') --to=plain)

	if [ "${draft}" = "false" ]; then
		printf "\n%s" "Processing page: $base"

		if [ "$base" = "search" ]; then
			m4 "templates/search.html" > "tmp/search.html"

		elif [ "$base" = "blog" ]; then
			find "$CONTENT_DIR/blog" -maxdepth 1 -type f -name '*.md' | while read -r article; do
				article_draft=$(pandoc "${article}" --template=<(echo '$draft$') --to=plain)

				article_title=$(pandoc "${article}" --template=<(echo '$title$') --to=plain)
				article_title=${article_title:-""}

				article_author=$(pandoc "${article}" --template=<(echo '$author$') --to=plain)
				article_author=${article_author:-""}

				article_description=$(pandoc "${article}" --template=<(echo '$description$') --to=plain)
				article_description=${article_description:-""}

				article_keywords=$(pandoc "${article}" --template=<(echo '$keywords$') --to=plain)
				article_keywords=${article_keywords:-""}

				article_date_published=$(pandoc "${article}" --template=<(echo '$date_published$') --to=plain)
				if [ -z "${article_date_published}" ]; then
					article_date_published=$(date "+%Y-%m-%dT%H:%M:%S%z" | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/')
				fi
				article_year_published=$(echo "$article_date_published" | cut -d'-' -f1)
				printf "\n%s" "blog page: ${article}"
				printf "\n%s" "blog date: ${article_date_published}"
				printf "\n%s" "blog year published: ${article_year_published}"
			done

			m4 "templates/blog.html" > "tmp/blog.html"
			make_nav_item_active "${base}"

		 elif [[ "$file" == "$CONTENT_DIR/blog/"* ]]; then
			template="article"
			printf "\n%s" "this is a blog page: ${base}"

		elif [ "$base" = "index" ]; then
			cp "tmp/page.html" "tmp/${base}.html"
			awk '{gsub(/<h1>\$title\$<\/h1>/,"<h1 class=\"visually-hidden\">\$title\$</h1>"); print}' "tmp/${base}.html" > "tmp/${base}.html.tmp" && mv "tmp/${base}.html.tmp" "tmp/${base}.html"
			make_nav_item_active "${base}"

		else
			cp "tmp/page.html" "tmp/${base}.html"
			make_nav_item_active "${base}"
		fi
		pandoc "$file" --output="$output" --to=html --template="tmp/${template}.html"
	else
		printf "\n%s" "Not processing: ${base}; draft status = true"
	fi
done < <(find "$CONTENT_DIR" -type f -name '*.md')

printf "\n%s" "Processing complete."

#  HTML for blog list
#<li><article><a class="archive-article-title" href="/blog/$slug$.html">$title$</a>
	#<dl class="archive-article-detail">
		#$if(subtitle)$<dt>Subtitle:</dt><dd>$subtitle$</dd>$endif$
		#$if(author)$<dt>Author:</dt><dd>$author$</li>$endif$
		#$if(description)$<dt>Summary:</dt><dd>$description$</dd>$endif$
		#$if(keywords)$<dt>Keywords/Tags:</dt><dd>$keywords$</dd>$endif$
		#<dt>Published:</dt>
		#<dd><time class="published" datetime="$date_published$">$date_published$</time></dd>
		#<dt>Updated:</dt>
		#<dd><time class="published" datetime="$date_updated$">$date_updated$</time></dd>
	#</dl>
#</article></li>
