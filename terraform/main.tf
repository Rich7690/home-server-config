provider "kubernetes" {
  config_path    = "./kubeconfig"
  config_context = "admin@home-cluster"
}

variable "domain_name" {
  type        = string
  description = "Domain used for services running within the cluster (example.com)"
  sensitive   = true
}

variable "external_domain" {
  type        = string
  description = "Domain used for services running within the cluster, but exposed publically (example.com)"
  sensitive   = true
}

variable "ping_id" {
  type        = string
  description = "ping id used for scraping health checks"
  sensitive   = true
}

locals {
  // Common linux ids used for various applications
  system_uid  = "998"
  system_gid  = "997"
  combined_id = "${local.system_uid}:${local.system_gid}"
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      "app" = "argocd"
    }
  }

}
