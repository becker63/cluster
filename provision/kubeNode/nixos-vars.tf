resource "local_file" "nixos_vars" {
  content         = jsonencode(local.kube_nodes)
  filename        = "nixos-vars.json"
  file_permission = "600"

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "git add -f '${local_file.nixos_vars.filename}'"
  }
}
