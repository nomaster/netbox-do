resource "kubernetes_config_map" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.netbox.metadata[0].name
  }
  data = {
    "nginx.conf" = file("nginx.conf")
  }
}

resource "kubernetes_config_map" "netbox" {
  metadata {
    name      = "netbox"
    namespace = kubernetes_namespace.netbox.metadata[0].name
  }
  data = {
    "ALLOWED_HOSTS" : "*"
    "DB_HOST" : digitalocean_database_cluster.postgres.host
    "DB_NAME" : digitalocean_database_cluster.postgres.database
    "DB_PORT" : digitalocean_database_cluster.postgres.port
    "DB_SSLMODE" : "require"
    "DB_USER" : digitalocean_database_cluster.postgres.user
    "REDIS_CACHE_HOST" : digitalocean_database_cluster.redis.host
    "REDIS_CACHE_PORT" : digitalocean_database_cluster.redis.port
    "REDIS_CACHE_SSL" : "true"
    "REDIS_HOST" : digitalocean_database_cluster.redis.host
    "REDIS_PORT" : digitalocean_database_cluster.redis.port
    "REDIS_SSL" : "true"
  }
}
