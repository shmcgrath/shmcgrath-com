#!/usr/bin/env bash
set -euo pipefail

# Accept project root as first argument
PROJECT_ROOT="${1:?Usage: $0 <project_root_path>}"
PINNED_FUSE_VERSION="${2:-${FUSE_VERSION_ENV:-}}"

PLUGIN_DIR="$PROJECT_ROOT/static/plugins"

if [ -z "$PINNED_FUSE_VERSION" ]; then
    printf "\n%s" "Error: Fuse.js version not specified."
    exit 1
fi

printf "\n%s" "Pinned fuse.js version: $PINNED_FUSE_VERSION"

# URLs
CDN_LATEST="https://cdn.jsdelivr.net/npm/fuse.js/dist"
CDN_VERSION="https://cdn.jsdelivr.net/npm/fuse.js@${PINNED_FUSE_VERSION}"

# Create directory if needed
mkdir -pv "${PLUGIN_DIR}"

# Check to see if latest fuse.js differs from pinned version
latest_fuse=$(
	curl -fsSL "${CDN_LATEST}/fuse.js" |
	sed -n '1,5p' |
	awk '/Fuse\.js v/ {
		sub(/^.*v/, "", $0)
		sub(/ .*/, "", $0)
		print
	}'
)

printf "\n%s" "Latest fuse.js version: ${latest_fuse}"

if [ "${PINNED_FUSE_VERSION}" != "${latest_fuse}" ]; then
    printf "\n%s" "Latest fuse.js differs from pinned v${PINNED_FUSE_VERSION}."
    printf "\n%s" "Consider updating pinned fusejs_version in Makefile."
	# Download latest fuse.min.js
    printf "\n%s" "fuse.min.js is what is used in the header."
	read -p "Do you want to download the latest fuse.min.js? [y/N] " answer
	case "${answer}" in
		[Yy]* )
			printf "\n%s" "Fetching latest fuse.min.js..."
			curl -fsSL "${CDN_LATEST}/fuse.min.js" -o "${PLUGIN_DIR}/fuse.min.js"
			printf "\n%s" "Saved latest fuse.min.js to ${PLUGIN_DIR}/fuse.min.js"
			;;
		* )
			printf "\n%s" "Skipped downloading latest fuse.min.js."
            ;;
	esac
fi

# Download pinned version (no /dist/ anymore!)
PINNED_FILE="${PLUGIN_DIR}/fuse-v${PINNED_FUSE_VERSION}.js"
if [ -f "${PINNED_FILE}" ]; then
	printf "\n%s" "Pinned Fuse.js v${PINNED_FUSE_VERSION} already exists at ${PINNED_FILE}, skipping download."
else
	printf "\n%s" "Fetching pinned version ${PINNED_FUSE_VERSION} fuse.js..."
	curl -sSL "${CDN_VERSION}" -o "$PINNED_FILE"
	printf "\n%s" "Saved pinned fuse.js to ${PINNED_FILE}"
fi
