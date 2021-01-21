resource "digitalocean_kubernetes_cluster" "netbox" {
  name    = "netbox-cluster"
  region  = var.do_region
  version = "1.19.3-do.3"
  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 1
  }
}
