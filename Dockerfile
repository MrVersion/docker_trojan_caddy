FROM ubuntu:20.04

RUN apt-get update && \
    apt upgrade && \
    apt update && \
    apt-get install -y curl wget unzip

RUN wget https://github.com/v2fly/v2ray-core/releases/download/v5.4.0/v2ray-linux-64.zip \
    && unzip v2ray-linux-64.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/v2ray \
    && mkdir /etc/v2ray

RUN apt install -y debian-keyring debian-archive-keyring apt-transport-https \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt update \
    && apt install caddy \
    && mkdir /etc/caddy
    
# 开启 BBR
RUN echo 'net.core.default_qdisc=fq' >> /etc/sysctl.conf \
    && echo 'net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf \
    && sysctl -p

# 复制 v2ray 和Caddy的配置文件
COPY ./v2ray/config.json /etc/v2ray/config.json
COPY ./caddy/Caddyfile /etc/caddy/Caddyfile
COPY ./www /usr/src

# 将 v2ray 和Caddy添加到PATH
ENV PATH="/usr/local/bin:${PATH}"

# 暴露 caddy 端口
EXPOSE 80 443

CMD ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"] && \
    v2ray -config /etc/v2ray/config.json
