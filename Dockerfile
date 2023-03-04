FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y wget gnupg2 && \
    wget -qO - https://apt.vyatta.io/vyatta-keyring.key | apt-key add - && \
    echo "deb http://apt.vyatta.io/ubuntu bionic main" | tee /etc/apt/sources.list.d/vyatta.list && \
    apt-get update && \
    apt-get install -y trojan caddy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# 开启 BBR
RUN echo 'net.core.default_qdisc=fq' >> /etc/sysctl.conf \
    && echo 'net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf \
    && sysctl -p
    
COPY Caddyfile /etc/caddy/Caddyfile

# 暴露 caddy 端口
EXPOSE 80 443

CMD ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
