resource "digitalocean_domain" "netbox" {
  depends_on = [
    cloudflare_record.netbox
  ]
  name = var.netbox_domain
}

resource "digitalocean_record" "netbox" {
  domain   = digitalocean_domain.netbox.name
  type     = "A"
  name     = "@"
  value    = kubernetes_service.netbox.load_balancer_ingress[0].ip
  ttl      = 300
}
