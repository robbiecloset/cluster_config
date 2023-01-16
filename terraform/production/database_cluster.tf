resource "digitalocean_database_cluster" "ghost-mysql" {
  name       = "ghost-mysql-cluster"
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc3"
  node_count = 1
}

resource "digitalocean_database_firewall" "ghost-mysql-fw" {
  cluster_id = digitalocean_database_cluster.ghost-mysql.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.ambient.id
  }
}