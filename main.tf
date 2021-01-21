terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "nomaster"
    workspaces {
      name = "netbox-app"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.17.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  api_token = var.cf_token
}

provider "kubernetes" {
  load_config_file = false
  host             = digitalocean_kubernetes_cluster.netbox.endpoint
  token            = digitalocean_kubernetes_cluster.netbox.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.netbox.kube_config[0].cluster_ca_certificate
  )
}
