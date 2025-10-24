ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install Smokeping and its dependencies
RUN apk update \
    && apk install -y \
        smokeping \
        fping \
        rrdtool \
        nginx \
        fcgiwrap

# Create necessary directories and copy addon files
COPY rootfs/ /

# Make run script executable
RUN chmod a+x /run.sh

# Set entrypoint
CMD [ "/run.sh" ]