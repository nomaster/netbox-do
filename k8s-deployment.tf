resource "kubernetes_namespace" "netbox" {
  metadata {
    name = "netbox"
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
        volume {
          name = "netbox-extra"
          config_map {
            name = "netbox-extra"
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
          env_from {
            config_map_ref {
              name = "netbox"
            }
          }
          env_from {
            secret_ref {
              name = "netbox"
            }
          }
          volume_mount {
            name       = "netbox-static"
            mount_path = "/opt/netbox/netbox/static/"
          }
          volume_mount {
            name       = "netbox-extra"
            mount_path = "/opt/netbox/netbox/netbox/extra.py"
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
          env_from {
            config_map_ref {
              name = "netbox"
            }
          }
          env_from {
            secret_ref {
              name = "netbox"
            }
          }
        }
      }
    }
  }
}
