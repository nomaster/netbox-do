resource "kubernetes_secret" "netbox" {
  metadata {
    name      = "netbox"
    namespace = kubernetes_namespace.netbox.metadata[0].name
  }
  data = {
    "DB_PASSWORD" : digitalocean_database_cluster.postgres.password
    "REDIS_CACHE_PASSWORD" : digitalocean_database_cluster.redis.password
    "REDIS_PASSWORD" : digitalocean_database_cluster.redis.password
    "SECRET_KEY" : random_password.netbox_secret.result
  }
}

resource "random_password" "netbox_secret" {
  length = 32
}
