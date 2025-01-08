#!/bin/sh

# Script: save-snapshot.sh
# Description: Creates and saves a schema snapshot from a running Directus container
# Usage: sudo ./snapshot.sh [container_name]

# Exit on error, undefined variables
set -eu

# Source utility functions
. "$(dirname "$0")/utils.sh"

# Default values
SNAPSHOT_DIR="/directus/snapshots/"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DEFAULT_OUTPUT="${SNAPSHOT_DIR}/snapshot_${TIMESTAMP}.yaml"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
  error "Docker is not running or inaccessible"
fi

# Get container name from argument or running container
CONTAINER=""
if [ $# -ge 1 ]; then
  CONTAINER="$1"
  docker ps --format '{{.Names}}' | grep -qx "$CONTAINER" || error "Container '$CONTAINER' is not running"
else
  CONTAINER=$(directus_container)
fi

if [ -z "$CONTAINER" ]; then
  error "No Directus container found"
fi

# Set output path
OUTPUT_PATH="${2:-$DEFAULT_OUTPUT}"

# Generate and copy snapshot
info "Generating schema snapshot from container: $CONTAINER"

if docker exec "$CONTAINER" npx directus schema snapshot --yes "$OUTPUT_PATH"; then
  # Prompt the user for confirmation before proceeding latest snapshot update
  printf "Do you want to update the latest schema snapshot? (y/n)" >&2
  read -r confirmation

  if [ "$confirmation" = "y" ] || [ "$confirmation" = "Y" ]; then
    # create latest file
    cp "$OUTPUT_PATH" "${SNAPSHOT_DIR}/snapshot-latest.yaml"
  fi

  success "Snapshot created successfully at: $OUTPUT_PATH"
else
  error "Failed to generate schema snapshot"
fi
