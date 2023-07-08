resource "gitlab_application_settings" "this" {
  signup_enabled = false
}

resource "gitlab_user" "user_bot" {
  name             = "john gitlab"
  username         = "gitlab_bot"
  password         = "pa55w0rd!"
  email            = "gitlab_bot@fuck.you"
  is_admin         = true
  projects_limit   = 99999
  can_create_group = true
  reset_password   = false
  skip_confirmation = true
}

resource "gitlab_personal_access_token" "gitlab_bot_token" {
  user_id    = gitlab_user.user_bot.id
  name       = "${gitlab_user.user_bot.name} personal access token"
  expires_at = "2024-07-06"

  scopes = ["api", "read_user", "read_api", "read_repository", "write_repository", "sudo", "admin_mode"]
}

output "gitlab_bot_token" {
  value = gitlab_personal_access_token.gitlab_bot_token.token
  sensitive = true
}

resource "gitlab_group" "group_flavortown" {
  name        = "flavortown"
  path        = "flavortown"
  description = "ALL ABOARD"
}

resource "gitlab_runner" "runner_flavortown" {
  registration_token = gitlab_group.group_flavortown.runners_token
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
    token = "${gitlab_runner.runner_flavortown.authentication_token}"
    executor = "docker"
    [runners.cache]
      MaxUploadedArchiveSize = 0
    [runners.docker]
      tls_verify = false
      image = "smigii/runner-img:1.0"
      privileged = false
      disable_entrypoint_overwrite = false
      oom_kill_disable = false
      disable_cache = false
      volumes = ["/cache"]
      shm_size = 0

  CONTENT
}