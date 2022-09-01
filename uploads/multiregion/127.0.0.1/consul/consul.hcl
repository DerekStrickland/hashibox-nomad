bootstrap_expect           = 1
enable_local_script_checks = true

// server = true

// retry_join = [
//   "127.0.0.1",
// ]

ui_config {
  enabled = true
}

service {
  name = "consul-client"
}

acl {
  enabled                  = false
  default_policy           = "allow"
  enable_token_persistence = true
}

connect {
  enabled = true
}
