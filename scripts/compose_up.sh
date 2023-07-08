#!/bin/bash

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