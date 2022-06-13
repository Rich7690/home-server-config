provider "kubernetes" {
  config_path    = "./kubeconfig"
  config_context = "default"
}

variable "domain_name" {
  type        = string
  description = "Domain used for services running within the cluster (example.com)"
  sensitive   = true
}

locals {
  // Common linux ids used for various applications
  system_uid  = "998"
  system_gid  = "997"
  combined_id = "${local.system_uid}:${local.system_gid}"
}
