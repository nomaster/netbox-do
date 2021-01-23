resource "random_pet" "bucket" {
}

resource "digitalocean_spaces_bucket" "netbox" {
  name   = random_pet.bucket.id
  region = var.do_region
}
