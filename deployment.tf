resource "kubernetes_namespace" "netbox" {
  metadata {
    name = "netbox"
  }
}

resource "kubernetes_config_map" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.netbox.metadata[0].name
  }
  data = {
    "nginx.conf" = file("nginx.conf")
  }
}

resource "kubernetes_deployment" "netbox" {
  metadata {
    name      = "netbox-server"
    namespace = kubernetes_namespace.netbox.metadata[0].name
    labels = {
      app = "netbox"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "netbox"
      }
    }
    template {
      metadata {
        labels = {
          app = "netbox"
        }
      }
      spec {
        volume {
          name = "netbox-static"
          empty_dir {}
        }
        volume {
          name = "nginx-config"
          config_map {
            name = "nginx"
          }
        }
        container {
          image = "netboxcommunity/netbox:v${var.netbox_version}"
          name  = "netbox"
          port {
            container_port = 8001
          }
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          env {
            name  = "ALLOWED_HOSTS"
            value = "*"
          }
          env {
            name  = "DB_HOST"
            value = digitalocean_database_cluster.postgres.host
          }
          env {
            name  = "DB_PORT"
            value = digitalocean_database_cluster.postgres.port
          }
          env {
            name  = "DB_SSLMODE"
            value = "require"
          }
          env {
            name  = "DB_USER"
            value = digitalocean_database_cluster.postgres.user
          }
          env {
            name  = "DB_PASSWORD"
            value = digitalocean_database_cluster.postgres.password
          }
          env {
            name  = "DB_NAME"
            value = digitalocean_database_cluster.postgres.database
          }
          env {
            name  = "SECRET_KEY"
            value = random_password.netbox_secret.result
          }
          env {
            name  = "REDIS_HOST"
            value = digitalocean_database_cluster.redis.host
          }
          env {
            name  = "REDIS_PORT"
            value = digitalocean_database_cluster.redis.port
          }
          env {
            name  = "REDIS_PASSWORD"
            value = digitalocean_database_cluster.redis.password
          }
          env {
            name  = "REDIS_SSL"
            value = "true"
          }
          env {
            name  = "REDIS_CACHE_HOST"
            value = digitalocean_database_cluster.redis.host
          }
          env {
            name  = "REDIS_CACHE_PORT"
            value = digitalocean_database_cluster.redis.port
          }
          env {
            name  = "REDIS_CACHE_PASSWORD"
            value = digitalocean_database_cluster.redis.password
          }
          env {
            name  = "REDIS_CACHE_SSL"
            value = "true"
          }
          volume_mount {
            name       = "netbox-static"
            mount_path = "/opt/netbox/netbox/static/"
          }
        }
        container {
          image = "nginx:1.19"
          name  = "nginx"
          port {
            container_port = 80
          }
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          volume_mount {
            name       = "netbox-static"
            mount_path = "/opt/netbox/netbox/static/"
            read_only  = true
          }
          volume_mount {
            name       = "nginx-config"
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path   = "nginx.conf"
            read_only  = true
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "netbox-worker" {
  metadata {
    name      = "netbox-worker"
    namespace = kubernetes_namespace.netbox.metadata[0].name
    labels = {
      app = "netbox-worker"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "netbox-worker"
      }
    }
    template {
      metadata {
        labels = {
          app = "netbox-worker"
        }
      }
      spec {
        container {
          name    = "netbox-worker"
          image   = "netboxcommunity/netbox:v${var.netbox_version}"
          command = ["python3", "/opt/netbox/netbox/manage.py", "rqworker"]
          env {
            name  = "DB_HOST"
            value = digitalocean_database_cluster.postgres.host
          }
          env {
            name  = "DB_PORT"
            value = digitalocean_database_cluster.postgres.port
          }
          env {
            name  = "DB_SSLMODE"
            value = "require"
          }
          env {
            name  = "DB_USER"
            value = digitalocean_database_cluster.postgres.user
          }
          env {
            name  = "DB_PASSWORD"
            value = digitalocean_database_cluster.postgres.password
          }
          env {
            name  = "DB_NAME"
            value = digitalocean_database_cluster.postgres.database
          }
          env {
            name  = "SECRET_KEY"
            value = random_password.netbox_secret.result
          }
          env {
            name  = "REDIS_HOST"
            value = digitalocean_database_cluster.redis.host
          }
          env {
            name  = "REDIS_PASSWORD"
            value = digitalocean_database_cluster.redis.password
          }
          env {
            name  = "REDIS_PORT"
            value = digitalocean_database_cluster.redis.port
          }
          env {
            name  = "REDIS_SSL"
            value = "true"
          }
          env {
            name  = "REDIS_CACHE_HOST"
            value = digitalocean_database_cluster.redis.host
          }
          env {
            name  = "REDIS_CACHE_PORT"
            value = digitalocean_database_cluster.redis.port
          }
          env {
            name  = "REDIS_CACHE_PASSWORD"
            value = digitalocean_database_cluster.redis.password
          }
          env {
            name  = "REDIS_CACHE_SSL"
            value = "true"
          }
        }
      }
    }
  }
}

resource "random_password" "netbox_secret" {
  length = 32
}

