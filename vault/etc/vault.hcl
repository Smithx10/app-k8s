backend "consul" {
  address = "$$IP_ADDRESS:8500"
  path = "vault"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
  #tls_client_ca_file = /certs/bob 
  #tls_cert_file = /certs/bob
  #tls_key_file = /certs/bob
}

disable_mlock = true
