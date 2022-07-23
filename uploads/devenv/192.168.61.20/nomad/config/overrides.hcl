datacenter = "dc1"
log_level  = "TRACE"
data_dir   = "/opt/nomad/data"

bind_addr = "192.168.61.20"

client {
  template {
    error_mode       = "noop"
    max_stale        = "0s"
    block_query_wait = "10s"

    wait {
      min = "2s"
      max = "5s"
    }

    wait_bounds {
      min = "2s"
      max = "5s"
    }

    consul_retry {
      attempts    = 0
      backoff     = "2s"
      max_backoff = "5s"
    }

    vault_retry {
      attempts    = 0
      backoff     = "2s"
      max_backoff = "5s"
    }

    nomad_retry {
      attempts    = 0
      backoff     = "2s"
      max_backoff = "5s"
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
  address = "192.168.61.20:8500"
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
