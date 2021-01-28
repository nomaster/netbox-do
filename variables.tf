variable "do_region" {
  description = "DigitalOcean region"
  type        = string
}

variable "do_token" {
  description = "DigitalOcean access token"
  type        = string
}

variable "do_spaces_access_key_id" {
  description = "DigitalOcean Spaces access key ID"
  type        = string
  default     = null
}

variable "do_spaces_access_key_secret" {
  description = "DigitalOcean Spaces access key secret"
  type        = string
  default     = null
}

variable "do_nameservers" {
  description = "DigitalOcean nameserver hostnames"
  type        = map(string)
  default = {
    "ns1" = "ns1.digitalocean.com",
    "ns2" = "ns2.digitalocean.com",
    "ns3" = "ns3.digitalocean.com",
  }
}

variable "cf_email" {
  description = "Cloudflare email address"
  type        = string
}

variable "cf_token" {
  description = "Cloudflare access token"
  type        = string
}

variable "cf_zoneid" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "netbox_version" {
  description = "NetBox version"
  type        = string
}

variable "netbox_domain" {
  description = "NetBox domain"
  type        = string
}

locals {
  cdn = "cdn.${var.netbox_domain}"
}
