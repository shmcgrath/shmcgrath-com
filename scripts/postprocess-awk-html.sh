#!/usr/bin/env bash

# Check for input
if [ $# -ne 1 ]; then
  printf "Usage: %s input_file\n" "$0"
  exit 1
fi

input_file="$1"
tmp_file="$(mktemp)"

# Process the file with awk so it works on macOS and Linux
awk '
BEGIN { tag = "" }
/post_process="awk"/ {

	sub(/ post_process="awk"/, "", $0)

	line = $0
	sub(/.*</, "", line)
	  tag = line
	  sub(/ .*/, "", tag)
	  sub(/>.*/, "", tag)
	  print
	  next
}
tag != "" && $0 ~ "^<" tag "[ >]" {
	tag = ""
	next
}
{ print }
' "$input_file" > "$tmp_file"

mv "$tmp_file" "$input_file"

printf "Post-processed: %s\n" "$input_file"
