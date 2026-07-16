#!/usr/bin/env bash

mkdir -p certs
# chown -R 100:100 certs/

openssl req -x509 -newkey rsa:4096 -sha256 -days 365 \
      -nodes -keyout certs/vault.key -out certs/vault.crt \
      -subj '/CN=vault' \
      -addext 'subjectAltName=DNS:vault,IP:127.0.0.1,IP:100.80.0.1'

