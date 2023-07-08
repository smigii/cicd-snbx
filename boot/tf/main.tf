resource "gitlab_application_settings" "this" {
  signup_enabled = false
  default_branch_protection = 0
}

data "gitlab_user" "root" {
  username = "root"
}

resource "gitlab_group" "group0" {
  name        = "flavortown"
  path        = "flavortown"
  description = "ALL ABOARD"
}

