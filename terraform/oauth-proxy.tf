resource "kubernetes_service_account_v1" "oauth_proxy" {
  metadata {
    name = "oauth-proxy"
  }
}


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


resource "kubernetes_config_map" "oauth_proxy" {
  metadata {
    name = "oauth-proxy"
    labels = {
      "app" = "oauth-proxy"
    }
  }

  data = {
    "OAUTH2_PROXY_SCOPE"            = "profile email openid"
    "OAUTH2_PROXY_HTTP_ADDRESS"     = ":4180"
    "OAUTH2_PROXY_PROVIDER"         = "keycloak-oidc"
    "OAUTH2_PROXY_ALLOWED_ROLE"     = "admin"
    "OAUTH2_PROXY_ALLOWED_GROUPS"   = "/admin"
    "OAUTH2_PROXY_COOKIE_SAMESITE"  = "lax"
    "OAUTH2_PROXY_REVERSE_PROXY"    = "true"
    "OAUTH2_PROXY_SET_XAUTHREQUEST" = "true"
    "OAUTH2_PROXY_EMAIL_DOMAINS"    = "*"
    "OAUTH2_PROXY_COOKIE_EXPIRE"    = "336h"
  }
}

resource "random_password" "cookie_secret" {
  length  = 32
  special = false
}
