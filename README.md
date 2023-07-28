# GitLab CICD Sandbox

This gets a GitLab instance and a GitLab Runner running in docker containers, with some basic projects setup for testing pipeline stuff.

## Steps

Just run `./all.sh` and everything should be up and running within ~5 minutes.

It will prompt you to enter the following

* Hostname, (which should be your local IP addy, NOT localhost or 127.0.0.1)
* GITLAB_HOME, which is the path to a local diretory on your machine where GitLab configuration/log files will be stored
* SSH port, which will map to port 22 on the docker instance.

If the setup gives an error somewhere you can just run `./all.sh` again and the script should start from where it failed last time.
Sometimes you'll have to remove an entry from `.ssh/known_hosts` on when you setup after tearing down.

Run `./purge.sh` to clean up everything.

This project has no regards for security whatsoever and only works on HTTP, not HTTPS, so do not connect it to ANY real world stuff.
It should only be used for POC stuff and quick tests. 
