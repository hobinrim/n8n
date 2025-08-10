FROM docker.n8n.io/n8nio/n8n

USER root

# Install Chromium + required runtime dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev \
    ttf-liberation \
    font-noto \
    font-noto-emoji \
    libx11 \
    libxcomposite \
    libxdamage \
    libxrandr \
    atk \
    at-spi2-atk \
    cups-libs \
    alsa-lib \
    mesa-libgbm \
    gtk+3.0 \
    nspr

# Environment variables for Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    NODE_PATH=/opt/n8n-custom-nodes/node_modules \
    PUPPETEER_ARGS="--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage"

# Install Puppeteer + n8n-nodes-puppeteer in a persistent location
RUN mkdir -p /opt/n8n-custom-nodes && \
    cd /opt/n8n-custom-nodes && \
    npm init -y && \
    npm install --omit=dev puppeteer n8n-nodes-puppeteer && \
    chown -R node:node /opt/n8n-custom-nodes

# Copy custom entrypoint script
COPY docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh && \
    chown node:node /docker-custom-entrypoint.sh

USER node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
