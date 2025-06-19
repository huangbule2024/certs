#/bin/bash
openssl genrsa -out itcCA.key 2048

openssl req -utf8 -config openssl.cnf -new -x509 -key itcCA.key -out itcCA.cer -days 36500 -subj "/C=CN/ST=ZheJiang/L=HangZhou/O=ITC/OU=ITC/CN=ITC/emailAddress=zjruiting@163.com"

openssl genrsa -out server.key 2048

openssl req -utf8 -config openssl.cnf -new -out server.req -key server.key -subj "/C=CN/ST=ZheJiang/L=HangZhou/O=ITC/OU=ITC/CN=ITC/emailAddress=zjruiting@163.com"

openssl x509 -req -extfile openssl.cnf -extensions v3_req -in server.req -out server.cer -CAkey itcCA.key -CA itcCA.cer -sha384 -days 36500 -CAcreateserial -CAserial serial

