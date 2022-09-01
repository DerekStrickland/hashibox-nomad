region     = "west"
datacenter = "dc2"
log_level  = "TRACE"
data_dir   = "/opt/nomad/data"

bind_addr = "192.168.60.20"

server {
  enabled          = true
  bootstrap_expect = 1
}

consul {
  address = "192.168.60.20:8500"
}

vault {
  enabled = true
  address = "http://192.168.60.20:8200"
}

ui {
  enabled = true

  consul {
    ui_url = "http://192.168.60.20:8500/ui"
  }

  vault {
    ui_url = "http://192.168.60.20:8200/ui"
  }
}
