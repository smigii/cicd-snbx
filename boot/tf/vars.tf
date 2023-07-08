variable "gitlab_home" {
  type = string
  default = "/Users/LL77291/gitlab"
  description = "Directory where docker volumes will live. Something like $HOME/gitlab"
}

variable "gitlab_token" {
  type = string
  default = "glpat-3GDusgsPD1y88syyJ39K" # PASTE ROOT TOKEN HERE
  description = "Root account personal access token"
}