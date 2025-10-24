ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install Smokeping and its dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        smokeping \
        fping \
        rrdtool \
        nginx \
        fcgiwrap \
        # Add any other required perl modules or utilities here
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories and copy addon files
COPY rootfs/ /

# Make run script executable
RUN chmod a+x /run.sh

# Set entrypoint
CMD [ "/run.sh" ]