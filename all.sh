#!/bin/bash

# ======================================================================================================
# USER INPUT ===========================================================================================

echo "
=== GitLab Sandbox Setup ===
GitLab Hostname: Local IP address of your machine, 10.0.0.x or something.
GitLab SSH port: which port the GitLab instance container will map to port 22
GitLab Home Dir: Where on your local machine the GitLab instance and runner persistent files will live

"

# Get user input
read -p '[1/4] GitLab Hostname: ' gitlab_hostname
read -p '[2/4] GitLab SSH Port: ' gitlab_ssh_port
read -p '[3/4] GitLab Home Dir: ' gitlab_home_dir
read -p '[4/4] GitLab PAC Token: ' gitlab_token

echo "Creating $gitlab_home_dir if needed"
mkdir -p $gitlab_home_dir

cat <<EOT > docker.env
GITLAB_HOME=$HOME/gitlab
GITLAB_HOSTNAME="10.0.0.88"
GITLAB_SSH_PORT=6022
EOT

echo "Created 'docker.env', your docker compose environment variables file is ready"

# ======================================================================================================
# DOCKER COMPOSE =======================================================================================

# Let there be light
docker compose up -d

# Wait for healthy status
echo "Waiting for GitLab instance to be healthy..."
is_healthy=""
while [ -z "$is_healthy" ]
do
  is_healthy=$(docker ps | grep "gitlab/gitlab-ce:latest" | grep "healthy")
  sleep 10s
done
echo "GitLab instance healthy"

# Get the root password
echo "Grabbing root password"
password=$(docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password)
echo Root Password: $password

sketchy_token=$(curl --silent --request POST --url 'http://10.0.0.88/oauth/token' \
    --header 'Content-Type: application/json' \
    --data '{
    "grant_type": "password",
    "username": "root",
    "password": "'$password'"
    }' | jq -r '.access_token')

pac=$(curl --request POST --url 'http://10.0.0.88/api/v4/users/1/personal_access_tokens' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $sketchy_token" \
  --data '{
    "name": "Automated Personal Access Token",
    "scopes": ["api", "read_api", "read_user", "read_repository", "write_repository", "sudo", "admin_mode"],
    "expires_at": "2024-01-01"
  }' | jq -r '.token')

cat <<EOT > terraform.env
export TF_VAR_root_pac_token="$gitlab_token"
export TF_VAR_gitlab_hostname="$gitlab_hostname"
export TF_VAR_gitlab_home="$gitlab_home_dir"
export TF_VAR_gitlab_ssh_port="$gitlab_ssh_port"
EOT

source terraform.env
echo "Created and sourced 'terraform.env', your TF_VAR environment variables are set"

# ======================================================================================================
# TERRAFORM ============================================================================================

cd tf

terraform init
terraform apply -auto-approve
