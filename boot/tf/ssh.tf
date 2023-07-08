resource "tls_private_key" "tls_key" {
  algorithm = "ED25519"
}

resource "gitlab_user_sshkey" "gitlab_root_ssh_key" {
  user_id    = data.gitlab_user.user_root.id
  title      = "Terraform Generated Root SSH Key"
  key        = tls_private_key.tls_key.public_key_openssh
}

resource "local_file" "local_ssh_key" {
  filename = "test-src/key"
  content  = tls_private_key.tls_key.private_key_openssh
  file_permission = "0700"
}