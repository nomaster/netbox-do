resource "random_pet" "bucket" {
}


resource "digitalocean_spaces_bucket" "netbox" {
  name   = random_pet.bucket.id
  region = var.do_region
  acl    = "public-read"
}

resource "digitalocean_certificate" "cdn" {
  name = "netbox-cdn"
  type = "lets_encrypt"
  domains = [ 
    local.cdn
   ]
}

resource "digitalocean_cdn" "netbox" {
  origin           = digitalocean_spaces_bucket.netbox.bucket_domain_name
  #custom_domain    = digitalocean_domain.cdn.name
  #certificate_name = digitalocean_certificate.cdn.name
}
