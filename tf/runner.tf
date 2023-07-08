resource "gitlab_runner" "runner0" {
  registration_token = gitlab_group.group0.runners_token
  description        = "terraform created runner"
  run_untagged       = true
}

resource "local_file" "runner_config" {
  filename = "${var.gitlab_home}/runner/config.toml"
  content  = <<CONTENT
  concurrent = 1

  [[runners]]
    name = "Terraform Runner"
    url = "http://host.docker.internal/"
    token = "${gitlab_runner.runner0.authentication_token}"
    executor = "docker"
    [runners.cache]
      MaxUploadedArchiveSize = 0
    [runners.docker]
      tls_verify = false
      image = "${var.runner_default_image}"
      privileged = false
      disable_entrypoint_overwrite = false
      oom_kill_disable = false
      disable_cache = false
      volumes = ["/cache"]
      shm_size = 0

  CONTENT
}