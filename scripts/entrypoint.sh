#!/bin/sh

# Start Directus normally in the background
node cli.js bootstrap &
directus_pid=$!

# Wait for Directus to finish bootstrapping
wait $directus_pid

# Comment out the following line if you want to sync the snapshot
# npx directus schema apply --yes ./snapshots/snapshot-latest.yaml

# Now apply Directus schema snapshot if needed
# if [ "$APPLY_SNAPSHOT" = "true" ]; then
#   echo "Applying schema snapshot..."
#   # wget -O snapshot-latest.yaml https://storage.googleapis.com/bnn-directus-snapshots/snapshot-latest.yaml
#   npx directus schema apply --yes ./snapshots/snapshot.yaml
# fi

# Continue to run Directus in the foreground
exec pm2-runtime start ecosystem.config.cjs
