resource "digitalocean_database_cluster" "redis" {
  name       = "redis"
  engine     = "redis"
  version    = "6"
  size       = "db-s-1vcpu-1gb"
  region     = var.do_region
  node_count = 1
}
