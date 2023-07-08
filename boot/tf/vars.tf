variable "gitlab_home" {
  type = string
  description = "Directory where docker volumes will live. Something like $HOME/gitlab"
}

variable "gitlab_hostname" {
  type = string
  description = "GitLab IP addy (10.0.0.X probably)"
}

variable "gitlab_ssh_port" {
  type = string
  description = "GitLab SSH port"
}

variable "root_pac_token" {
  type = string
  description = "Root account personal access token"
}

variable "runner_default_image" {
  type = string
  default = "smigii/runner-img:1.0"
  description = "Default docker image to use for the GitLab Runner"
}