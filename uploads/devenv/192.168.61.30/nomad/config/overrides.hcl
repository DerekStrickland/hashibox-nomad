datacenter = "dc1"
log_level  = "TRACE"
data_dir   = "/opt/nomad/data"

bind_addr = "192.168.61.30"

client {
  template {
    error_mode       = "noop"
    max_stale        = "5s"
    block_query_wait = "90s"

    wait {
      min = "2s"
      max = "60s"
    }

    wait_bounds {
      min = "2s"
      max = "60s"
    }

    consul_retry {
      attempts    = 1
      backoff     = "5s"
      max_backoff = "10s"
    }

    vault_retry {
      attempts    = 1
      backoff     = "15s"
      max_backoff = "20s"
    }
  }

  cni_path = "/opt/cni/bin"
}

plugin "docker" {
  config {
    extra_labels = ["job_name", "job_id", "task_group_name", "task_name", "namespace", "node_name", "node_id"]
    volumes {
      enabled = true
    }
  }
}

telemetry {
  collection_interval = "5s"
  disable_hostname    = false
}

consul {
  address = "192.168.61.30:8500"
}

vault {
  enabled = true
  address = "http://192.168.60.30:8200"
}

ui {
  enabled = true

  consul {
    ui_url = "http://192.168.60.30:8500/ui"
  }

  vault {
    ui_url = "http://192.168.60.30:8200/ui"
  }
}
