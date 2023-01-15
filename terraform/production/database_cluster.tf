resource "digitalocean_database_cluster" "ghost-mysql" {
  name       = "ghost-mysql-cluster"
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc3"
  node_count = 1
}