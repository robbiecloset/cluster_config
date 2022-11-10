resource "digitalocean_vpc" "ambient" {
  name     = "ambient"
  region   = "nyc3"
  ip_range = "10.10.10.0/24"
}