locals {
}

module "deploy" {
  for_each = local.kube_nodes

  source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"

  nixos_system_attr      = "../../#nixosConfigurations.${each.key}.config.system.build.toplevel"
  nixos_partitioner_attr = "../../#nixosConfigurations.${each.key}.config.system.build.diskoScript"

  target_host   = each.value.ip
  instance_id   = each.key
  debug_logging = true

  extra_files_script = "${path.module}/decrypt-ssh-secrets.sh"

  disk_encryption_key_scripts = [{
    path   = "/tmp/secret.key"
    script = "${path.module}/decrypt-zfs-key.sh"
  }]
}

locals {
  kube_nodes = {
    "kube-0" = {
      ip     = "192.168.1.10"
      hostid = "9d754565"
    }
    "kube-1" = {
      ip     = "192.168.1.11"
      hostid = "01cad479"
    }
    "kube-2" = {
      ip     = "192.168.1.12"
      hostid = "29c00c05"
    }
  }
}
