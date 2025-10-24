ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install Smokeping and its dependencies
RUN apk update && \
    apk add --no-cache \
        smokeping \
        fping \
        rrdtool \
        nginx \
        fcgiwrap && \
    rm -rf /var/cache/apk/*

# Create necessary directories and copy addon files
COPY rootfs/ /

# Copy run script
COPY run.sh /run.sh

# Make run script executable
RUN chmod a+x /run.sh

# Set entrypoint
CMD [ "/run.sh" ]