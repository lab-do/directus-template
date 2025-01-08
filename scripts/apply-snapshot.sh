#!/bin/sh

# Script: apply-snapshot.sh
# Description: Applies a schema snapshot to a running Directus container
# Usage: sudo ./apply-snapshot.sh [snapshot_name]

# Exit on error, unset variable, and pipe failures
set -e

# Source utility functions
. "$(dirname "$0")/utils.sh"

# Default values
SNAPSHOT_DIR="/directus/snapshots/"
SNAPSHOT_NAME="${1:-snapshot-latest.yaml}"
SNAPSHOT_FILE="$SNAPSHOT_DIR/$SNAPSHOT_NAME"

# Get container name
CONTAINER=$(directus_container)

if [ -z "$CONTAINER" ]; then
  error "No Directus container found"
fi

# Check if snapshot file exists
if ! docker exec "$CONTAINER" test -f "$SNAPSHOT_FILE"; then
  error "Schema snapshot file not found: $SNAPSHOT_FILE"
fi

# Apply schema changes
echo "Applying schema changes from $SNAPSHOT_FILE..."
if ! docker exec -i "$CONTAINER" npx directus schema apply "$SNAPSHOT_FILE" -y; then
  error "Failed to apply schema changes"
fi

# Restart container
info "Restarting Directus container..."
if ! docker restart "$CONTAINER"; then
  error "Failed to restart container"
fi

success "Schema changes applied successfully"
