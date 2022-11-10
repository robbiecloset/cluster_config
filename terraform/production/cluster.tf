resource "digitalocean_kubernetes_cluster" "ambient" {
  name   = "ambient"
  region = "nyc3"

  # `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    # For the moment, I am thinking I will want one pool for the blog,
    # and I'll introduce another for the long radio, hence the naming
    # convention.
    name       = "ghost-pool"

    # `doctl compute size list`
    size       = "s-1vcpu-2gb"
    node_count = 1
  }

  depends_on = [
    digitalocean_vpc.ambient
  ]
  vpc_uuid = digitalocean_vpc.ambient.id
}