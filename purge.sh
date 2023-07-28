#!/bin/bash

docker compose down -v

rm -rf terraform.env
rm -rf tf/.terraform
rm -rf tf/.terraform.lock.hcl
rm -rf tf/.terraform.tfstate
rm -rf tf/.terraform.tfstate.backup
rm -rf tf/test-src/key

if test -f "docker.env"; then
  source docker.env
  sudo rm -rf $GITLAB_HOME/config
  sudo rm -rf $GITLAB_HOME/data
  sudo rm -rf $GITLAB_HOME/logs
  sudo rm -rf $GITLAB_HOME/runner
  rm docker.env
fi