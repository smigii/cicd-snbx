#!/bin/bash

# Generates a Personal Access Token with NO regard for security

echo $1

# Get the root password
echo "Grabbing root password"
password=$(docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password | awk '{print $2}' | tr -d '\r')
echo Root Password: $password

echo "Fetching sketchy token"
sketchy_curl=$(curl --silent --request POST --url "http://$GITLAB_HOSTNAME/oauth/token" \
    --header 'Content-Type: application/json' \
    --data "{ \"grant_type\": \"password\", \"username\": \"root\", \"password\": \"$password\" }")

echo $sketchy_curl
sketchy_token=$(echo $sketchy_curl | jq -r '.access_token')

echo "Fetching GitLab PAC"
pat_curl=$(curl --silent --request POST --url "http://$GITLAB_HOSTNAME/api/v4/users/1/personal_access_tokens" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $sketchy_token" \
  --data '{
    "name": "Automated Personal Access Token",
    "scopes": ["api", "read_api", "read_user", "read_repository", "write_repository", "sudo", "admin_mode"],
    "expires_at": "2024-01-01"
  }')

echo $pat_curl
pat_token=$(echo $pat_curl | jq -r '.token')

if [ -z "$pat_token" ]; then
  exit 1
fi

cat <<EOT > terraform.env
export TF_VAR_root_pac_token="$pat_token"
export TF_VAR_gitlab_hostname="$GITLAB_HOSTNAME"
export TF_VAR_gitlab_home="$GITLAB_HOME"
export TF_VAR_gitlab_ssh_port="$GITLAB_SSH_PORT"
EOT

echo "Created 'terraform.env', your TF_VAR environment variables are ready to set"

