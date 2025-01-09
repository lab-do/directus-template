#!/bin/sh

# Strip quotes from DB_FILENAME if present
DB_FILENAME=${DB_FILENAME#\"}
DB_FILENAME=${DB_FILENAME%\"}

# Restore the database if it does not already exist.
if [ -f "$DB_FILENAME" ]; then
  echo "Database already exists, skipping restore"
else
  echo "No database found, restoring from replica if exists"
  /usr/local/bin/litestream restore -if-replica-exists "${DB_FILENAME}"
fi

node cli.js bootstrap

# Set default value for snapshot path if not provided
SNAPSHOT_PATH="${SNAPSHOT_PATH:-/directus/snapshots/snapshot-latest.yaml}"

# Apply Directus schema snapshot
if [ "${APPLY_SNAPSHOT}" = "true" ]; then
  echo "Applying schema snapshot from ${SNAPSHOT_PATH} ..."
  # wget -O snapshot-latest.yaml <your-snapshot-url>
  npx directus schema apply --yes "${SNAPSHOT_PATH}"
fi

# Run Directus and Litestream
exec /usr/local/bin/litestream replicate -exec "pm2-runtime start ecosystem.config.cjs"
