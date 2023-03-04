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

3. 执行  `docker-compose up`，或者执行`docker-compose up -d`以常驻进程模式运行容器。

如果每个容器都构建完成并没有产生异常退出，那么你的 Trojan + caddy 服务应该已经是正常运转状态了。如果 Trojan 暂时没有启动起来，可能是因为正在进行证书的申请，请多等待一段时间， Trojan 容器会尝试重启。
