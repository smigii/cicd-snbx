#!/bin/bash

echo "GitLab Hostname: Local IP address of your machine, 10.0.0.x or something.
GitLab SSH port: which port the GitLab instance container will map to port 22
GitLab Home Dir: Where on your local machine the GitLab instance and runner persistent files will live
GitLab PAC
"

read -p '[1/4] GitLab Hostname: ' gitlab_hostname
read -p '[2/4] GitLab SSH Port: ' gitlab_ssh_port
read -p '[3/4] GitLab Home Dir: ' gitlab_home_dir
read -p '[4/4] GitLab PAC Token: ' gitlab_token

cat <<EOT > terraform.env
export TF_VAR_root_pac_token="$gitlab_token"
export TF_VAR_gitlab_hostname="$gitlab_hostname"
export TF_VAR_gitlab_home="$gitlab_home_dir"
export TF_VAR_gitlab_ssh_port="$gitlab_ssh_port"
EOT

source terraform.env
echo "Created and sourced 'terraform.env', your TF_VAR environment variables are set"

cat <<EOT > docker.env
GITLAB_HOME=$HOME/gitlab
GITLAB_HOSTNAME="10.0.0.88"
GITLAB_SSH_PORT=6022
EOT

echo "Created 'docker.env', your docker compose environment variables file is ready"
