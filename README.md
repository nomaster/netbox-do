# NetBox on Kubernetes

This code showcases how to deploy NetBox with Kubernetes.

The infrastructure is provided by Digital Ocean's managed Kubernetes service. The DNS entries come from a subdomain delegated by a zone hosted on Cloudflare.

## Usage

If you want to deploy your own instance, make sure to fill the following variables:

* `netbox_domain` the domain name for your NetBox (in my case netbox.nomaster.cc)
* `netbox_version` the version number for your NetBox (currently 2.10)
* `do_region` for the DO datacenter location, for example fra1
* `do_token` your access token for the DO API
* `cf_token` your acess token for the CF API
* `cf_zoneid` the ID of your DNS zone at CF

## Contribution

This is an example project and the installation is not intended for productive usage. If you want, fork the project or use it as a source of inspiration.

If you have any questions, please post a message on the [discussion board](https://github.com/nomaster/netbox-do/discussions)!