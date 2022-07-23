api_addr     = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"

storage "consul" {
  address = "127.0.0.1:8500"
}

listener "tcp" {
  tls_disable     = true
  address         = "127.0.0.1:8200"
  cluster_address = "127.0.0.1:8201"
}
