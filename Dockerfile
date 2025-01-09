FROM litestream/litestream:0.3.13 AS bin

FROM directus/directus:11.3.5

COPY --from=bin /usr/local/bin/litestream /usr/local/bin/litestream

# Copy the litestream config
COPY litestream.yml /etc/litestream.yml

# Copy the files from the host machine
COPY ./database /directus/database
COPY ./uploads /directus/uploads
COPY ./extensions /directus/extensions
COPY ./snapshots /directus/snapshots

# Railway config file
COPY ./config.cjs /directus/config.cjs

# Expose the port
EXPOSE 8055

# Custom entrypoint script to run Directus
COPY ./scripts/entrypoint.sh /directus/entrypoint.sh
WORKDIR /directus
USER root
RUN chmod +x ./entrypoint.sh
USER node
ENTRYPOINT ["./entrypoint.sh"]

