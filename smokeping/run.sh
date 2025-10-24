#!/usr/bin/with-contenv bashio

set -x

bashio::log.info "Starting Smokeping addon..."

CONFIG_DIR="/config/smokeping"
DATA_DIR="/data/smokeping"
DEFAULTS_DIR="/etc/smokeping/defaults"

bashio::log.info "Listing contents of /etc/smokeping/defaults..."
ls -la /etc/smokeping/defaults

# 1. Create persistent directories if they don't exist
mkdir -p "${CONFIG_DIR}"
mkdir -p "${DATA_DIR}"
chown -R smokeping:smokeping "${DATA_DIR}"

# 2. Copy default configuration if user config doesn't exist
for file in config; do
    if [ ! -f "${CONFIG_DIR}/${file}" ]; then
        bashio::log.info "No user ${file} found, creating default."
        cp "${DEFAULTS_DIR}/${file}" "${CONFIG_DIR}/${file}"
    fi
done

bashio::log.info "Contents of /config/smokeping/config before modification:"
cat "${CONFIG_DIR}/config"

# 3. Create symlinks for Smokeping to find its config
rm -rf /etc/smokeping
ln -s "${CONFIG_DIR}" /etc/smokeping

# 4. Parse and apply addon options from UI
OWNER=$(bashio::config 'owner')
CONTACT=$(bashio::config 'contact')

sed -i "s/owner = Your Name Here/owner = ${OWNER}/g" "${CONFIG_DIR}/config"
sed -i "s/contact = your.email@host.bla/contact = ${CONTACT}/g" "${CONFIG_DIR}/config"
sed -i "s|datadir = /var/lib/smokeping|datadir = ${DATA_DIR}|g" "${CONFIG_DIR}/config"

bashio::log.info "Contents of /config/smokeping/config after modification:"
cat "${CONFIG_DIR}/config"

# Create nginx log directory
mkdir -p /var/log/nginx

bashio::log.info "Checking for binaries..."
which smokeping
which nginx
which fping
which fcgiwrap

bashio::log.info "Configuration complete. Starting services..."

# 5. Start services using S6-Overlay
# This assumes service definitions are placed in /etc/services.d/
exec s6-svscan /etc/services.d