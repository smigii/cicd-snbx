resource "gitlab_project" "proj0" {
  name         = "project0"
  description  = "A Very Basic Project"
  namespace_id = gitlab_group.group0.id
}

resource "gitlab_project_variable" "var_tf_user" {
  project   = gitlab_project.proj0.id
  key       = "TF_USERNAME"
  value     = data.gitlab_user.root.username
  protected = false
}

resource "gitlab_project_variable" "var_tf_pass" {
  project   = gitlab_project.proj0.id
  key       = "TF_PASSWORD"
  value     = var.root_pac_token
  protected = false
}

resource "gitlab_project_variable" "var_tf_addr" {
  project   = gitlab_project.proj0.id
  key       = "TF_ADDRESS"
  value     = "http://${var.gitlab_hostname}/api/v4/projects/${gitlab_project.proj0.id}/terraform/state/state.tfstate"
  protected = false
}

resource "local_file" "test_repo_seed" {
  filename = "test-src/seed.sh"
  content  = <<CONTENT
  #!/bin/bash

  rm -rf .git
  git init
  git config --add --local core.sshCommand 'ssh -i key -p ${var.gitlab_ssh_port}'
  git config user.name "${data.gitlab_user.root.name}"
  git config user.email "${data.gitlab_user.root.email}"
  git checkout -b main
  git remote add origin ${gitlab_project.proj0.ssh_url_to_repo}
  git add .
  git commit -m "Initial commit"
  git push -f origin main

  CONTENT

  provisioner "local-exec" {
    command = "cd test-src; ./seed.sh"
  }
}