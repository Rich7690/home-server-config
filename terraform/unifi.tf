resource "kubernetes_ingress_v1" "unifi" {
  metadata {
    name = "unifi"
    labels = {
      "app" = "unifi"
    }
    annotations = {
      "ingress.kubernetes.io/protocol"               = "https"
      "ingress.kubernetes.io/secure-backends"        = "true"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
      "nginx.ingress.kubernetes.io/rewrite-target"   = "/"
    }
  }
  spec {
    ingress_class_name = "nginx" //TODO: install nginx ingress controller
    rule {
      host = "unifi.${var.domain_name}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "unifi"
              port {
                name = "http"
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [var.domain_name, "*.${var.domain_name}"]
      secret_name = "prod-cert" //TOD: create secret with TLS certs
    }
  }

}
