resource "kubernetes_ingress_v1" "loki" {
  metadata {
    name = "loki"
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts       = ["*.${var.domain_name}", "${var.domain_name}"]
      secret_name = "prod-cert"
    }
    rule {
      host = "loki.${var.domain_name}"
      http {

        path {
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "loki"
              port {
                name = "http-metrics"
              }
            }
          }
          path = "/"
        }
      }
    }
  }

}


resource "kubernetes_ingress_v1" "scrutiny" {
  metadata {
    name = "scrutiny"
    labels = {
      "app" = "scrutiny"
    }
    annotations = {
      "nginx.ingress.kubernetes.io/auth-signin"            = "https://${var.domain_name}/oauth2/sign_in"
      "nginx.ingress.kubernetes.io/auth-url"               = "https://${var.domain_name}/oauth2/auth"
      "nginx.ingress.kubernetes.io/whitelist-source-range" = "192.168.0.0/16,10.0.0.0/8"
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts       = ["${var.domain_name}", "*.${var.domain_name}"]
      secret_name = "prod-cert"
    }
    rule {

      host = "scrutiny.${var.domain_name}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "scrutiny"
              port {
                name = "http"
              }
            }

          }
        }
      }
    }
  }
}
