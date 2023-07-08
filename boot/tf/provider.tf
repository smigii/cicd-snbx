terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "16.1.0"
    }
  }
}

provider "gitlab" {
  base_url = "http://127.0.0.1"
  token = var.root_pac_token
}