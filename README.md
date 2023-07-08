# Bootstrap

This gets the GitLab instance and a GitLab Runner setup.

## Steps

### Initialize Environment Variables

Run...

```shell
./init.sh
```

which will set up a Docker Compose environment variables file and a sourceable Terraform environment variables file.

### Docker compose

Run...

```shell
docker compose up -d
```

to get the GitLab Instance and the GitLab Runner going. Takes ~5 minutes for the instance to finish. Wait until `docker ps` shows
healthy status for the instance before proceeding.

### ClickOps

Run...

```shell
sudo docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

To grab the initial password and login, using `root` as username. Reset the password after logging in to something shorter :)

Create a god-mode personal token for root, this token will be used in the following Terraform.

1. Click your avatar in top left corner
2. Click `edit profile`
3. Click `access tokens`
4. select all the scopes, give it a name, hit create, then copy the token.

### GitLab Initialization

Update the environment variables in `variables.env`, then run `source variables.env`.

Go to the `tf` and run...

```shell
terraform apply -auto-approve
```

This will set up a GitLab runner, a group and project with a test repository and pipeline, fully configured. The pipeline
***should*** work out of the box.
