#!/bin/bash

# Exit if anything fails
set -e

# ======================================================================================================
# USER INPUT ===========================================================================================

if test -f "docker.env"; then
  echo "docker.env exists, skipping user_input.sh"
else
  ./scripts/user_input.sh
fi

source docker.env
echo "Sourced 'docker.env', your docker compose environment variables are set"

# ======================================================================================================
# DOCKER COMPOSE =======================================================================================

set +e
inst_health=$(docker ps | grep gitlab/gitlab-ce:latest | grep healthy)
runner_health=$(docker ps | grep gitlab/gitlab-runner:latest | grep Up)
set -e

if [ -z "$inst_health" ] && [ -z "$runner_health" ]; then
  ./scripts/compose_up.sh
else
  echo "GitLab instance healthy, GitLab runner up, skipping Docker Compose"
fi

# Check if we've already generated the PAT
if test -f "terraform.env"; then
  echo "terraform.env exists, skipping gen_pat.sh"
else
  ./scripts/gen_pat.sh
fi

source terraform.env
echo "Sourced 'terraform.env', your TF_VAR environment variables are set"

# ======================================================================================================
# TERRAFORM ============================================================================================

cd tf

terraform init
terraform apply -auto-approve
