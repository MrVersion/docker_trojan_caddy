# docker_trojan_caddy

### 手工启动

1. 编辑 `./caddy/Caddyfile`:

    ```
    ${YOUR_DOMAIN_COM} {
        reverse_proxy /ray http://127.0.0.1:10001 {
            websocket
            header_upstream -Origin
        }
        log {
            output file /usr/src/caddy.log
        }
    }
    ```

   将`${YOUR_DOMAIN_COM}`替换成你自己的域名。`/ray`是伪装路径
  
2.编辑 `./v2ray/config.json`
```
{
  "inbounds": [
    {
      "port": 10001, // 服务器监听端口
      "protocol": "vmess",    // 主传入协议
      "settings": {
        "clients": [
          {
            "id": "${V2RAY_UUID}",  // 用户 ID，客户端与服务器必须相同
            "alterId": 64
          }
        ]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",  // 主传出协议
      "settings": {}
    }
  ]
}
```
    将 `${V2RAY_UUID}` 改为自己的UUID
    
3. 执行 `docker volume create my-ssl` 创建持久化volume
4. 执行 `docker run -d -v my-ssl:/etc/caddy -p 80:80 -p 443:443 -e YOUR_DOMAIN_COM=xxx.com -e V2RAY_UUID=xxxxxxxxxxxxxxxxxxxx docker_v2ray:x.x.x
`运行容器。


