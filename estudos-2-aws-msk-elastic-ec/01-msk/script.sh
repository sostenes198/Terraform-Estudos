#!/usr/bin/env bash
set -euo pipefail

export_environment_vars() {
  # Bootstrap brokers TLS do MSK
  BOOT="$(terraform output -raw msk_bootstrap_brokers_tls)"
  export BOOT
  echo "BOOT=$BOOT"
}

produce_messages() {
  # Produz mensagens via SSL/TLS
  docker run --rm -i \
    --network host \
    edenhill/kcat:1.7.1 \
      -b "$BOOT" \
      -m 1000 \
      -t logs-app \
      -X security.protocol=ssl \
      -X ssl.ca.location=/etc/ssl/certs/ca-certificates.crt \
      -P <<'EOF'
{"app":"api","msg":"hello","ts":"2025-09-01T20:10:00Z"}
{"app":"api","msg":"world","ts":"2025-09-01T20:10:05Z"}
EOF
}

consume_message(){
  # Consume mensagens vis SSL/TLS
  docker run --rm -i edenhill/kcat:1.7.1 \
  -b "$BOOT" -t logs-app -X security.protocol=ssl -C -o beginning -e -q -c 2
}

list_metadata() {
  # (Opcional) Lista metadados para testar conectividade
  docker run --rm -i --network host edenhill/kcat:1.7.1 \
  -b "$BOOT" \
  -X security.protocol=ssl \
  -X ssl.ca.location=/etc/ssl/certs/ca-certificates.crt \
  -d broker,security \
  -L
}

usage() {
  echo "Uso: $0 --produce | --metadata"
  exit 1
}

[[ $# -gt 0 ]] || usage

while [[ $# -gt 0 ]]; do
  case "$1" in
    --produce)
      export_environment_vars
      produce_messages
      shift
      ;;
    --produce)
      export_environment_vars
      consume_message
      shift
      ;;
    --metadata)
      export_environment_vars
      list_metadata
      shift
      ;;
    *)
      echo "Flag desconhecida: $1"
      usage
      ;;
  esac
done
