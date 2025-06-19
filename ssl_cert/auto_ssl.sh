#/bin/bash
SSL_CONFIG=${SSL_CONFIG:-$PWD/openssl.cnf}
# 生成openssl配置
cat > ${SSL_CONFIG} <<EOM
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = @alt_names
# 这里是重点，需要将里面配置为最终服务端需要的域名或者IP
# 这里可以写多个，可以自行添加DNS.X = XXXXXX 或者 IP.X = XXXXXX
[alt_names]
#DNS.1 = www.test.com
#IP.1 = 10.10.20.240
EOM
# 获取服务器ip
ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | awk '{printf "IP.%d = %s\n", NR, $1}' >> ${SSL_CONFIG}
# 生成相关证书
openssl genrsa -out itcCA.key 2048
openssl req -utf8 -config ${SSL_CONFIG} -new -x509 -key itcCA.key -out itcCA.cer -days 36500 -subj "/C=CN/ST=ZheJiang/L=HangZhou/O=ITC/OU=ITC/CN=ITC/emailAddress=zjruiting@163.com"
openssl genrsa -out server.key 2048
openssl req -utf8 -config ${SSL_CONFIG} -new -out server.req -key server.key -subj "/C=CN/ST=ZheJiang/L=HangZhou/O=ITC/OU=ITC/CN=ITC/emailAddress=zjruiting@163.com"
openssl x509 -req -extfile ${SSL_CONFIG} -extensions v3_req -in server.req -out server.cer -CAkey itcCA.key -CA itcCA.cer -sha384 -days 36500 -CAcreateserial -CAserial serial
