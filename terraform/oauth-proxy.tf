resource "kubernetes_secret_v1" "oauth_proxy" {
  metadata {
    name = "oauth-proxy"
    labels = {
      "app" = "oauth-proxy"
    }
    annotations = {
      "vault.security.banzaicloud.io/vault-role"       = "oauth-proxy"
      "vault.security.banzaicloud.io/vault-tls-secret" = "vault-tls"
    }
  }

  data = {
    "OAUTH2_PROXY_COOKIE_DOMAINS"    = "${var.domain_name},.${var.domain_name}"
    "OAUTH2_PROXY_WHITELIST_DOMAINS" = "${var.domain_name},.${var.domain_name}"
    "OAUTH2_PROXY_CLIENT_ID"         = "oauth2-proxy"
    "OAUTH2_PROXY_CLIENT_SECRET"     = "vault:secret/data/deploy/oauth-proxy#OAUTH2_PROXY_CLIENT_SECRET"
    "OAUTH2_PROXY_OIDC_ISSUER_URL"   = "https://keycloak.${var.domain_name}/auth/realms/main"
    "OAUTH2_PROXY_REDIRECT_URL"      = "https://${var.domain_name}/oauth2/callback"
    "OAUTH2_PROXY_UPSTREAMS"         = "http://jacket:9117/jackett" # doesn't matter what this is, we don't use it
    "OAUTH2_PROXY_COOKIE_SECRET"     = random_password.cookie_secret.result
  }
}

resource "random_password" "cookie_secret" {
  length  = 32
  special = false
}
