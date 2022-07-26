resource "kubernetes_ingress_v1" "loki" {
  metadata {
    name = "loki"
    annotations = {
      "nginx.ingress.kubernetes.io/service-upstream" = "true"
    }
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
      "nginx.ingress.kubernetes.io/service-upstream"       = "true"
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


resource "kubernetes_ingress_v1" "argo_CD" {
  metadata {
    name = "argo-cd"
    labels = {
      "app" = "argo-cd"
    }
    annotations = {
      "nginx.ingress.kubernetes.io/service-upstream"       = "true"
      "nginx.ingress.kubernetes.io/whitelist-source-range" = "192.168.0.0/16,10.0.0.0/8"
      "ingress.kubernetes.io/protocol"                     = "https"
      "ingress.kubernetes.io/secure-backends"              = "true"
      "nginx.ingress.kubernetes.io/backend-protocol"       = "HTTPS"
      "nginx.ingress.kubernetes.io/rewrite-target"         = "/"
      "nginx.ingress.kubernetes.io/cors-allow-methods"     = "PUT, GET, POST, DELETE, PATCH, OPTIONS"
    }
    namespace = "argocd"
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts       = ["${var.domain_name}", "*.${var.domain_name}"]
      secret_name = "prod-cert"
    }
    rule {

      host = "argocd.${var.domain_name}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "argocd-server"
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


resource "kubernetes_ingress_v1" "iotawatt" {
  metadata {
    name = "iotawatt"
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts       = ["*.${var.domain_name}", "${var.domain_name}"]
      secret_name = "prod-cert"
    }
    rule {
      host = "iotawatt.${var.domain_name}"
      http {

        path {
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "iotawatt"
              port {
                name = "http"
              }
            }
          }
          path = "/"
        }
      }
    }
  }

}

resource "kubernetes_ingress_v1" "theila" {
  metadata {
    name = "theila"
    annotations = {
      "nginx.ingress.kubernetes.io/auth-signin"            = "https://${var.domain_name}/oauth2/sign_in"
      "nginx.ingress.kubernetes.io/auth-url"               = "https://${var.domain_name}/oauth2/auth"
      "nginx.ingress.kubernetes.io/whitelist-source-range" = "192.168.0.0/16,10.0.0.0/8"
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts       = ["*.${var.domain_name}", "${var.domain_name}"]
      secret_name = "prod-cert"
    }
    rule {
      host = "theila.${var.domain_name}"
      http {

        path {
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "theila"
              port {
                name = "http"
              }
            }
          }
          path = "/"
        }
      }
    }
  }

}
