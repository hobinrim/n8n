FROM docker.n8n.io/n8nio/n8n

USER root

# Install Chrome dependencies and Chrome
RUN apk add --no-cache \
    chromium \
    chromium-chromedriver \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev \
    ttf-liberation \
    font-noto \
    font-noto-cjk \
    font-noto-emoji \
    libx11 \
    libxcomposite \
    libxdamage \
    libxrandr \
    libatk \
    libatk-bridge \
    libcups \
    libasound \
    libgbm \
    gtk+3.0 \
    nspr

# Tell Puppeteer to use installed Chrome instead of downloading it
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium_browser \ 
    NODE_PATH=/opt/n8n-custom-nodes/node_modules

# Install n8n-nodes-puppeteer in a permanent location
RUN mkdir -p /opt/n8n-custom-nodes && \
    cd /opt/n8n-custom-nodes && \
    npm init -y && \
    npm install puppeteer n8n-nodes-puppeteer && \
    chown -R node:node /opt/n8n-custom-nodes

# Copy our custom entrypoint
COPY docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh && \
    chown node:node /docker-custom-entrypoint.sh

# ===== Puppeteer 실행 안정화 옵션 =====
#  - --no-sandbox: Render 같은 제한 환경에서 필수
#  - --disable-dev-shm-usage: /dev/shm 메모리 부족 방지
ENV PUPPETEER_ARGS="--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage"


USER node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
