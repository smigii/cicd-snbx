#!/bin/bash

echo "
GitLab Hostname: Local IP address of your machine, 10.0.0.x or something.
GitLab SSH port: which port the GitLab instance container will map to port 22
GitLab Home Dir: Where on your local machine the GitLab instance and runner persistent files will live

"

# Get user input
read -p '[1/3] GitLab Hostname: ' gitlab_hostname
read -p '[2/3] GitLab SSH Port: ' gitlab_ssh_port
read -p '[3/3] GitLab Home Dir: ' gitlab_home_dir

echo "Creating $gitlab_home_dir if needed"
mkdir -p $gitlab_home_dir

cat <<EOT > docker.env
export GITLAB_HOME=$gitlab_home_dir
export GITLAB_HOSTNAME="$gitlab_hostname"
export GITLAB_SSH_PORT=$gitlab_ssh_port
EOT

echo "Created 'docker.env', your docker compose environment variables file is ready"