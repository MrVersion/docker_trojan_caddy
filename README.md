# docker_trojan_caddy

### 手工启动

1. 编辑 `./caddy/Caddyfile`:

    ```
    www.yourdomain.com:80 {
        root * /usr/src/trojan
        log {
            output file /usr/src/caddy.log
        }
        file_server
    }
    www.yourdomain.com:443 {
        root * /usr/src/trojan
        log {
            output file /usr/src/caddy.log
        }
        file_server
    }
    ```

   将`www.yourdomain.com`替换成你自己的域名。

2. 编辑 `./trojan/config/config.json`:
   在`config:json:8`位置，将`your_password`替换成你要设置的密码，这是你客户端连接需要用的密码，妥善保管。

   在`config:json:12-13`位置将`your_domain_name` 替换成你自己的域名, 这个路径是 Caddy 自动调用 Let's encrypt 生成的证书路径。

3. 执行  `docker run -d -p 80:80 -p 443:443`运行容器。


