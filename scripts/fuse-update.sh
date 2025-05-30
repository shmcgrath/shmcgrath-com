#!/usr/bin/env bash
set -euo pipefail

# Accept project root as first argument
PROJECT_ROOT="${1:?Usage: $0 <project_root_path>}"

STATIC_DIR="$PROJECT_ROOT/static/plugins"
CONFIG_FILE="$PROJECT_ROOT/config.toml"

# Extract Fuse.js version from config.toml
FUSE_VERSION=$(awk -F' *= *' '/^fusejs_version/ {gsub(/"/, "", $2); print $2}' "$CONFIG_FILE")
printf "%s\n" "$FUSE_VERSION"

# URLs
CDN_LATEST="https://cdn.jsdelivr.net/npm/fuse.js/dist"
CDN_VERSION="https://cdn.jsdelivr.net/npm/fuse.js@${FUSE_VERSION}"

# Target filenames
VERSION_PREFIX="v${FUSE_VERSION}"

# Create directory if needed
mkdir -p "$STATIC_DIR"

# Detect hash command
if command -v sha256sum >/dev/null 2>&1; then
    HASH_CMD="sha256sum"
elif command -v shasum >/dev/null 2>&1; then
    HASH_CMD="shasum -a 256"
else
    printf "%s\n" "Error: No sha256sum or shasum available."
    exit 1
fi

# Download latest fuse.js
printf "%s\n" "Fetching latest fuse.js..."
curl -sSL "${CDN_LATEST}/fuse.js" -o "${STATIC_DIR}/fuse.js"
printf "%s\n" "Saved latest fuse.js to ${STATIC_DIR}/fuse.js"

# Download latest fuse.min.js
printf "%s\n" "Fetching latest fuse.min.js..."
curl -sSL "${CDN_LATEST}/fuse.min.js" -o "${STATIC_DIR}/fuse.min.js"
printf "%s\n" "Saved latest fuse.min.js to ${STATIC_DIR}/fuse.min.js"

# Download pinned version (no /dist/ anymore!)
printf "%s\n" "Fetching pinned version ${FUSE_VERSION} fuse.js..."
curl -sSL "${CDN_VERSION}" -o "${STATIC_DIR}/${VERSION_PREFIX}-fuse.js"
printf "%s\n" "Saved pinned fuse.js to ${STATIC_DIR}/${VERSION_PREFIX}-fuse.js"

# Compare hashes to see if latest fuse.js differs from pinned
LATEST_HASH=$($HASH_CMD "${STATIC_DIR}/fuse.js" | awk '{print $1}')
PINNED_HASH=$($HASH_CMD "${STATIC_DIR}/${VERSION_PREFIX}-fuse.js" | awk '{print $1}')

if [ "$LATEST_HASH" != "$PINNED_HASH" ]; then
    printf "%s\n" "Warning: Latest fuse.js differs from pinned v${FUSE_VERSION}."
    printf "%s\n" "Consider updating fusejs_version in config.toml."
else
    printf "%s\n" "Latest fuse.js matches pinned version."
fi
