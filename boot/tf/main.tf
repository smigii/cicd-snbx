resource "gitlab_application_settings" "this" {
  signup_enabled = false
  default_branch_protection = 0
}

data "gitlab_user" "user_root" {
  username = "root"
}

resource "gitlab_group" "group_flavortown" {
  name        = "flavortown"
  path        = "flavortown"
  description = "ALL ABOARD"
}

resource "gitlab_project" "project_flavortown" {
  name         = "flavortown"
  description  = "The Flavortown Project"
  namespace_id = gitlab_group.group_flavortown.id
}

resource "gitlab_project_variable" "var_tf_user" {
  project   = gitlab_project.project_flavortown.id
  key       = "TF_USERNAME"
  value     = data.gitlab_user.user_root.username
  protected = false
}

resource "gitlab_project_variable" "var_tf_pass" {
  project   = gitlab_project.project_flavortown.id
  key       = "TF_PASSWORD"
  value     = var.root_pac_token
  protected = false
}

resource "gitlab_project_variable" "var_tf_addr" {
  project   = gitlab_project.project_flavortown.id
  key       = "TF_ADDRESS"
  value     = "http://10.0.0.88/api/v4/projects/${gitlab_project.project_flavortown.id}/terraform/state/the_state"
  protected = false
}

resource "local_file" "test_repo_seed" {
  filename = "test-src/seed.sh"
  content  = <<CONTENT
  #!/bin/bash

  rm -rf .git
  git init
  git config --add --local core.sshCommand 'ssh -i key -p 6022'
  git config user.name "${data.gitlab_user.user_root.name}"
  git config user.email "${data.gitlab_user.user_root.email}"
  git checkout -b main
  git remote add origin ${gitlab_project.project_flavortown.ssh_url_to_repo}
  git add .
  git commit -m "Initial commit"
  git push -f origin main

  CONTENT

  provisioner "local-exec" {
    command = "cd test-src; ./seed.sh"
  }
}

