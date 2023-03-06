FROM ubuntu:20.04

ENV YOUR_DOMAIN_COM www.example.com
ENV V2RAY_UUID 7E5E37F6-8E7F-D6C5-7DDE-E90C587CD185
ENV VMESS_WSPATH /ray

RUN apt-get update && \
    apt upgrade && \
    apt-get install -y curl wget unzip

RUN wget https://github.com/v2fly/v2ray-core/releases/download/v5.3.0/v2ray-linux-64.zip \
    && unzip v2ray-linux-64.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/v2ray \
    && mkdir /etc/v2ray \
    && mkdir /var/log/v2ray \
    && touch /var/log/v2ray/access.log \
    && touch /var/log/v2ray/error.log
    

RUN apt install -y debian-keyring debian-archive-keyring apt-transport-https \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt update \
    && apt install caddy \
    && mkdir -p /etc/caddy/sites \
    && mkdir -p /etc/caddy/ssl

# 复制 v2ray 和Caddy的配置文件
COPY ./v2ray/config.json /etc/v2ray/config.json
COPY ./caddy/Caddyfile /etc/caddy/Caddyfile

# 将 v2ray 和Caddy添加到PATH
ENV PATH="/usr/local/bin:${PATH}"

RUN sed -i "s/\${V2RAY_UUID}/$V2RAY_UUID/g" /etc/v2ray/config.json && sed -i "s#\${VMESS_WSPATH}#$VMESS_WSPATH#g" /etc/v2ray/config.json



# 开启 BBR
#RUN echo 'net.core.default_qdisc=fq' >> /etc/sysctl.conf \
#    && echo 'net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf \
#    && sysctl -p


# 暴露 caddy 端口
EXPOSE 80 443

# RUN nohup /usr/local/bin/v2ray run -config /etc/v2ray/config.json > /dev/null 2>&1 &

# ENTRYPOINT ["nohup","/usr/local/bin/v2ray","run","-config /etc/v2ray/config.json > /dev/null 2>&1 &"]

CMD ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"] 

VOLUME /etc/caddy
