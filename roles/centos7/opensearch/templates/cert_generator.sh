#!/bin/sh
# Root CA
openssl genrsa -out {{ localhost_certs_dir }}/root-ca-key.pem 2048
openssl req -new -x509 -sha256 -key {{ localhost_certs_dir }}/root-ca-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN=ROOT" -out {{ localhost_certs_dir }}/root-ca.pem -days 730
# Admin cert
openssl genrsa -out {{ localhost_certs_dir }}/admin-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in {{ localhost_certs_dir }}/admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out {{ localhost_certs_dir }}/admin-key.pem
openssl req -new -key {{ localhost_certs_dir }}/admin-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN=ADMIN" -out {{ localhost_certs_dir }}/admin.csr
openssl x509 -req -in {{ localhost_certs_dir }}/admin.csr -CA {{ localhost_certs_dir }}/root-ca.pem -CAkey {{ localhost_certs_dir }}/root-ca-key.pem -CAcreateserial -sha256 -out {{ localhost_certs_dir }}/admin.pem -days 730
# Node cert 1
openssl genrsa -out {{ localhost_certs_dir }}/{{ inventory_hostname }}-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in {{ localhost_certs_dir }}/{{ inventory_hostname }}-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out {{ localhost_certs_dir }}/{{ inventory_hostname }}-key.pem
openssl req -new -key {{ localhost_certs_dir }}/{{ inventory_hostname }}-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN={{ inventory_hostname }}.{{ domain_name }}" -out {{ localhost_certs_dir }}/{{ inventory_hostname }}.csr
openssl x509 -req -in {{ localhost_certs_dir }}/{{ inventory_hostname }}.csr -CA {{ localhost_certs_dir }}/root-ca.pem -CAkey {{ localhost_certs_dir }}/root-ca-key.pem -CAcreateserial -sha256 -out {{ localhost_certs_dir }}/{{ inventory_hostname }}.pem -days 730
# Dashboard cert
openssl genrsa -out {{ localhost_certs_dir }}/dashboard-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in {{ localhost_certs_dir }}/dashboard-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out {{ localhost_certs_dir }}/dashboard-key.pem
openssl req -new -key {{ localhost_certs_dir }}/dashboard-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN=DASHBOARD" -out {{ localhost_certs_dir }}/dashboard.csr
openssl x509 -req -in {{ localhost_certs_dir }}/dashboard.csr -CA {{ localhost_certs_dir }}/root-ca.pem -CAkey {{ localhost_certs_dir }}/root-ca-key.pem -CAcreateserial -sha256 -out {{ localhost_certs_dir }}/dashboard.pem -days 730
# Cleanup
rm {{ localhost_certs_dir }}/admin-key-temp.pem
rm {{ localhost_certs_dir }}/admin.csr
rm {{ localhost_certs_dir }}/{{ inventory_hostname }}-key-temp.pem
rm {{ localhost_certs_dir }}/{{ inventory_hostname }}.csr
rm {{ localhost_certs_dir }}/dashboard-key-temp.pem
rm {{ localhost_certs_dir }}/dashboard.csr