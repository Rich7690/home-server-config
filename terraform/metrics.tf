resource "helm_release" "vm" {
  name        = "vm"
  chart       = "victoria-metrics-single"
  repository  = "https://victoriametrics.github.io/helm-charts/"
  version     = "0.8.31"
  max_history = 3

  set {
    name  = "server.scrape.enabled"
    value = "true"
  }

  values = [templatefile("./prometheus.yml", { external_domain = var.external_domain, ping_id = var.ping_id })]
}


resource "kubernetes_ingress_v1" "vm" {
  metadata {
    name = "vm-ingress"
    labels = {
      "app" = "vm"
    }
    annotations = {
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "0"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "600"
    }
  }
  spec {
    ingress_class_name = "nginx" //TODO: install nginx ingress controller
    rule {
      host = "vm.${var.domain_name}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "vm-victoria-metrics-single-server"
              port {
                number = 8428
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
