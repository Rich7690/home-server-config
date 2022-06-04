provider "kubernetes" {
  config_path    = "./kubeconfig"
  config_context = "default"
}

variable "domain_name" {
  type        = string
  description = "Domain used for services running within the cluster (example.com)"
  sensitive   = true
}
