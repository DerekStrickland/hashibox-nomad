plan server::build_nomad (TargetSpec $targets) {

  # Build packages.
  run_task('nomad::build', $targets)

  # Restart `systemctl` so we can start the agents.
  run_task('server::reload', $targets)

  # So far so good.
  return run_command('echo "==> Nomad successfully built!"', $targets)
}
