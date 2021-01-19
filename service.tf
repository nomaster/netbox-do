resource "kubernetes_service" "netbox" {
  metadata {
    name      = "netbox"
    namespace = kubernetes_namespace.netbox.metadata[0].name
    annotations = {
      "service.beta.kubernetes.io/do-loadbalancer-name"                   = var.netbox_domain
      "service.beta.kubernetes.io/do-loadbalancer-certificate-id"         = digitalocean_certificate.netbox.id
      "service.beta.kubernetes.io/do-loadbalancer-protocol"               = "http2"
      "service.beta.kubernetes.io/do-loadbalancer-redirect-http-to-https" = true
      "service.beta.kubernetes.io/do-loadbalancer-tls-ports"              = 443
      "service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol"  = true
    }
  }
  spec {
    selector = {
      app = "netbox"
    }
    session_affinity = "ClientIP"
    port {
      name        = "http"
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
    port {
      name        = "https"
      port        = 443
      target_port = 80
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }
}
