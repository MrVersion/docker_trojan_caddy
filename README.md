# docker_trojan_caddy

### 使用步骤
环境要求：ubuntu 18.04+
1. 下载代码库 `git clone https://github.com/MrVersion/docker_v2ray_caddy.git`
2. 进入目录 `cd docker_v2ray_caddy/`
3. 构建容器如 `docker build -t docker_v2ray:1.1.1 .`
4. 启动容器 
```
# 创建目录
mkdir -p /ssl/caddy
# 设置参数启动
docker run -d -v /ssl/caddy:/etc/caddy -p 80:80 -p 443:443 -e YOUR_DOMAIN_COM="www.xxxx.com" -e V2RAY_UUID="D7779A1D-CE9D-FB99-1A5F-0DCDB9D1DA58" -e VMESS_WSPATH="/ray" docker_v2ray:1.1.1
```



