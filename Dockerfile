# 基于 Ubuntu 18.04
FROM ubuntu:18.04

# 安装 curl 和 gnupg
RUN apt-get update && apt-get install -y curl gnupg

# 添加 V2Ray 的 APT 源
RUN echo "deb [trusted=yes] https://apt.fury.io/v2ray/ /" > /etc/apt/sources.list.d/v2ray.list && \
    curl https://apt.fury.io/v2ray/apt.key | apt-key add -

# 安装 V2Ray 和 Caddy
RUN apt-get update && \
    apt-get install -y v2ray caddy

# 复制 V2Ray 和 Caddy 的配置文件
COPY v2ray.json /etc/v2ray/config.json
COPY Caddyfile /etc/caddy/Caddyfile

# Caddy 的端口
EXPOSE 80 443

# 运行 V2Ray 和 Caddy
CMD service v2ray start && caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
