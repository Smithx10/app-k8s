#!/bin/bash
export CONSUL=localhost
export VAULT_ADDR=http://127.0.0.1:$(docker inspect k8s_vault_1 | jq -r '.[] | .NetworkSettings.Ports."8200/tcp"[0].HostPort')
export VAULT_TOKEN=$(curl -k https://localhost:8081/my-vault_keys | grep Initial | awk -F\\': ' '{print $2}')
vault operator unseal $(curl -k https://localhost:8081/my-vault_keys | grep Unseal | awk -F\\': ' '{print $2}')
vault secrets enable pki
vault write pki/root/generate/internal \\n    common_name=tritonhost.com \\n    ttl=8760h
vault write pki/roles/vaultserver  allow_bare_domains=true \\n    allowed_domains=vault \\n    allow_subdomains=false \\n    max_ttl=72h
vault write pki/config/urls \\n    issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" \\n    crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"
vault token create -ttl=10m

