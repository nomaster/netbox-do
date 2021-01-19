resource "digitalocean_project" "netbox" {
  name        = "NetBox"
  description = "NetBox demo installation"
  purpose     = "Web Application"
  environment = "Development"
}


resource "digitalocean_project_resources" "netbox" {
  project = digitalocean_project.netbox.id
  resources = [
    digitalocean_database_cluster.postgres.urn,
    digitalocean_database_cluster.redis.urn,
  ]
}
