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
    "AWS_S3_REGION_NAME" : var.do_region
    "AWS_S3_ENDPOINT_URL" : "https://${var.do_region}.digitaloceanspaces.com"
    "AWS_S3_CUSTOM_DOMAIN" : local.cdn
    "AWS_ACCESS_KEY_ID" : var.do_spaces_access_key_id
    "AWS_SECRET_ACCESS_KEY" : var.do_spaces_access_key_secret
    "DB_HOST" : digitalocean_database_cluster.postgres.host
    "DB_NAME" : digitalocean_database_cluster.postgres.database
    "DB_PORT" : digitalocean_database_cluster.postgres.port
    "DB_SSLMODE" : "require"
    "DB_USER" : digitalocean_database_cluster.postgres.user
    "METRICS_ENABLED" : "true"
    "REDIS_CACHE_HOST" : digitalocean_database_cluster.redis.host
    "REDIS_CACHE_PORT" : digitalocean_database_cluster.redis.port
    "REDIS_CACHE_SSL" : "true"
    "REDIS_HOST" : digitalocean_database_cluster.redis.host
    "REDIS_PORT" : digitalocean_database_cluster.redis.port
    "REDIS_SSL" : "true"
    "STORAGE_BACKEND": "storages.backends.s3boto3.S3Boto3Storage"
  }
}

resource "kubernetes_config_map" "netbox_extra" {
  metadata {
    name = "netbox-extra"
    namespace = kubernetes_namespace.netbox.metadata[0].name
  }
  data = {
    "extra.py" = file("netbox-extra.py")
  }
}
