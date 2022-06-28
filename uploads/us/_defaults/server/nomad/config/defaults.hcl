data_dir = "/opt/nomad"

server {
  enabled          = true
  bootstrap_expect = 3

  server_join {
    retry_join = [
      "192.168.60.10",
      "192.168.60.20",
      "192.168.60.30"
    ]
  }
}

client {
  enabled = false
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}

consul {
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}

acl {
  enabled = false
}
