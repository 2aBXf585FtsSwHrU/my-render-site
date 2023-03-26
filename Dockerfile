FROM node:latest
EXPOSE 3000
WORKDIR /app
# ADD file.tar.gz /app/
COPY . .
RUN apt-get update &&\
    apt-get install -y iproute2 &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
    dpkg -i cloudflared.deb &&\
    rm -f cloudflared.deb &&\
    chmod +x web.js

# COPY server.js /app/server.js

# COPY entrypoint.sh /app/entrypoint.sh

RUN mkdir /etc/nginx /app/apps

COPY ca.pem /etc/nginx/ca.pem

COPY ca.key /etc/nginx/ca.key

RUN wget -q -O /tmp/apps.zip https://github.com/XrayR-project/XrayR/releases/download/v0.9.0/XrayR-linux-64.zip && \
    unzip -d /app/apps /tmp/apps.zip && \
    mv /app/apps/XrayR /app/apps/myapps && \
    rm -f /tmp/apps.zip && \
    chmod a+x /app/apps/myapps && \
    rm -rf /app/apps/config.yml

COPY config.yml /app/apps/config.yml

ENTRYPOINT [ "node", "server.js" ]