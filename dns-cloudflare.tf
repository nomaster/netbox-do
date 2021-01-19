resource "cloudflare_record" "netbox" {
  for_each = var.do_nameservers
  zone_id  = var.cf_zoneid
  name     = var.netbox_domain
  type     = "NS"
  ttl      = 300
  value    = each.value
}

