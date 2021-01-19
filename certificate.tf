resource "digitalocean_certificate" "netbox" {
  name    = "netbox"
  type    = "lets_encrypt"
  domains = [
    digitalocean_domain.netbox.id
  ]
}
