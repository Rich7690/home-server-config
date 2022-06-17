provider "helm" {
  kubernetes {
    config_path    = "./kubeconfig"
    config_context = "default"
  }
}

resource "kubernetes_ingress_v1" "vault_ingress" {
  metadata {
    name = "vault-ingress"
    labels = {
      "app" = "vault"
    }
    annotations = {
      "ingress.kubernetes.io/protocol"                 = "https"
      "ingress.kubernetes.io/secure-backends"          = "true"
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTPS"
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/"
      "nginx.ingress.kubernetes.io/cors-allow-methods" = "PUT, GET, POST, DELETE, PATCH, OPTIONS"
    }
  }
  spec {
    ingress_class_name = "nginx" //TODO: install nginx ingress controller
    rule {
      host = "vault.${var.domain_name}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "vault"
              port {
                number = 8200
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [var.domain_name, "*.${var.domain_name}"]
      secret_name = "prod-cert" //TODO: create secret with TLS certs
    }
  }

}
