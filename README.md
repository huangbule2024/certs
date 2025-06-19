1. 首先服务器需要安装openssl，可以使用 openssl version 命令查看， 如果没有安装，执行 apt install -y openssl libssl-dev
2. 使用 chmod +x generate_ssl_cert.sh 命令，给generate_ssl_cert.sh执行权限
3. 修改 openssl.cnf 中 IP.1 对应的ip （如果不需要导入自签的CA证书来消除https错误，可以不用修改）
3. 执行 ./generate_ssl_cert.sh
4. 当前目录下生成的 itcCA.cer 即为CA证书，信任该证书可以消除https错误提示，server.cer 和 server.key 为nginx配置中需要用到的ssl证书和key
5. nginx 配置示例如下：
server {
    listen 80;
    listen [::]:80;
    server_name _;
    # enforce https
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name _;

    ssl_certificate /etc/nginx/conf.d/server.cer;
    ssl_certificate_key /etc/nginx/conf.d/server.key;

	#其他配置
}
