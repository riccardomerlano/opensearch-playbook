#!/bin/sh
# Root CA
openssl genrsa -out root-ca-key.pem 2048
openssl req -new -x509 -sha256 -key root-ca-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN=ROOT" -out root-ca.pem -days 730
# Admin cert
openssl genrsa -out admin-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin-key.pem
openssl req -new -key admin-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN=ADMIN" -out admin.csr
openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out admin.pem -days 730
# Node cert 1
openssl genrsa -out {{ inventory_hostname }}-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in {{ inventory_hostname }}-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out {{ inventory_hostname }}-key.pem
openssl req -new -key {{ inventory_hostname }}-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN={{ inventory_hostname }}.{{ domain_name }}" -out {{ inventory_hostname }}.csr
openssl x509 -req -in {{ inventory_hostname }}.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out {{ inventory_hostname }}.pem -days 730
# Dashboard cert
openssl genrsa -out dashboard-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in dashboard-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out dashboard-key.pem
openssl req -new -key dashboard-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN=DASHBOARD" -out dashboard.csr
openssl x509 -req -in dashboard.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out dashboard.pem -days 730
# Cleanup
rm admin-key-temp.pem
rm admin.csr
rm {{ inventory_hostname }}-key-temp.pem
rm {{ inventory_hostname }}.csr
rm dashboard-key-temp.pem
rm dashboard.csr