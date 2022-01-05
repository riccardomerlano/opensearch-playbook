#!/bin/sh
# Root CA
openssl genrsa -out {{ localhost_certs_dir }}/root-ca-key.pem 2048
openssl req -new -x509 -sha256 -key {{ localhost_certs_dir }}/root-ca-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN=ROOT" -out {{ localhost_certs_dir }}/root-ca.pem -days 730
# Admin cert
openssl genrsa -out {{ localhost_certs_dir }}/admin-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in {{ localhost_certs_dir }}/admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out {{ localhost_certs_dir }}/admin-key.pem
openssl req -new -key {{ localhost_certs_dir }}/admin-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN=ADMIN" -out {{ localhost_certs_dir }}/admin.csr
openssl x509 -req -in {{ localhost_certs_dir }}/admin.csr -CA {{ localhost_certs_dir }}/root-ca.pem -CAkey {{ localhost_certs_dir }}/root-ca-key.pem -CAcreateserial -sha256 -out {{ localhost_certs_dir }}/admin.pem -days 730
rm {{ localhost_certs_dir }}/admin-key-temp.pem
rm {{ localhost_certs_dir }}/admin.csr
# Nodes certificates
{% for hostname in groups['os-cluster'] %}
openssl genrsa -out {{ localhost_certs_dir }}/{{ hostname }}-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in {{ localhost_certs_dir }}/{{ hostname }}-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out {{ localhost_certs_dir }}/{{ hostname }}-key.pem
openssl req -new -key {{ localhost_certs_dir }}/{{ hostname }}-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN={{ hostname }}.{{ domain_name }}" -out {{ localhost_certs_dir }}/{{ hostname }}.csr
openssl x509 -req -in {{ localhost_certs_dir }}/{{ hostname }}.csr -CA {{ localhost_certs_dir }}/root-ca.pem -CAkey {{ localhost_certs_dir }}/root-ca-key.pem -CAcreateserial -sha256 -out {{ localhost_certs_dir }}/{{ hostname }}.pem -days 730
rm {{ localhost_certs_dir }}/{{ hostname }}-key-temp.pem
rm {{ localhost_certs_dir }}/{{ hostname }}.csr
{% endfor %}
# Dashboard cert
{% if proprietary_dashboard_cert == "no_cert" %}
openssl genrsa -out {{ localhost_certs_dir }}/dashboard-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in {{ localhost_certs_dir }}/dashboard-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out {{ localhost_certs_dir }}/dashboard-key.pem
openssl req -new -key {{ localhost_certs_dir }}/dashboard-key.pem -subj "/C=IT/ST=LOMBARDIA/L=MILANO/O=ORG/OU=UNIT/CN=DASHBOARD" -out {{ localhost_certs_dir }}/dashboard.csr
openssl x509 -req -in {{ localhost_certs_dir }}/dashboard.csr -CA {{ localhost_certs_dir }}/root-ca.pem -CAkey {{ localhost_certs_dir }}/root-ca-key.pem -CAcreateserial -sha256 -out {{ localhost_certs_dir }}/dashboard.pem -days 730
rm {{ localhost_certs_dir }}/dashboard-key-temp.pem
rm {{ localhost_certs_dir }}/dashboard.csr
{% endif %}