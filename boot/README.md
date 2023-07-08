# Bootstrap

This gets the GitLab instance and a GitLab Runner setup.

## Steps

### Docker compose

Run...

```docker compose up -d```

to get the instance and the runner going. Takes ~5 minutes for the instance to finish. Wait until `docker ps` shows healthy status for the instance.

### ClickOps

Create a god-mode personal token for root, this token will be used in the terraform

### GitLab initializing

Go to the `tf` directory and update the variables in vars.tf, then...

```
terraform init
terraform plan
terraform apply
```

to apply some basic settings, create a god user and create a default group. You will need to apply twice (for some reason)
to get the application settings to go through.
