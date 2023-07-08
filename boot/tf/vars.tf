variable "gitlab_home" {
  type = string
  default = "/home/smigii/gitlab"
  description = "Directory where docker volumes will live. Something like $HOME/gitlab"
}

variable "gitlab_token" {
  type = string
  default = "glpat-WDnH7A-TpspoWMzn2atR" # PASTE ROOT TOKEN HERE
  description = "Root account personal access token"
}