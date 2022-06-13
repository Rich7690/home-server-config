provider "helm" {
  kubernetes {
    config_path    = "./kubeconfig"
    config_context = "default"
  }
}


resource "helm_release" "vault" {
  name        = "vault"
  chart       = "vault"
  repository  = "https://kubernetes-charts.banzaicloud.com"
  max_history = 3

  set {
    name  = "image.tag"
    value = "1.10.3"
  }

  set {
    name  = "persistence.enabled"
    value = "false"
  }

  set {
    name  = "persistence.hostPath"
    value = "/work/storage/configs/vault"
  }

}

resource "helm_release" "vault-secrets-webhook" {
  name        = "vault-secrets-webhook"
  chart       = "vault-secrets-webhook"
  repository  = "https://kubernetes-charts.banzaicloud.com"
  max_history = 3

  set {
    name  = "env.VAULT_IMAGE"
    value = "vault:1.10.3"
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
