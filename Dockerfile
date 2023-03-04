FROM caddy

RUN wget https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip \
    && unzip v2ray-linux-64.zip -d /usr/local/bin/ \
    && rm v2ray-linux-64.zip \
    && chmod +x /usr/local/bin/v2ray
    
# 开启 BBR
RUN echo 'net.core.default_qdisc=fq' >> /etc/sysctl.conf \
    && echo 'net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf \
    && sysctl -p
    
RUN mkdir /etc/caddy

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
