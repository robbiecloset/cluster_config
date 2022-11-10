resource "digitalocean_project" "ambient" {
  name        = "ambient"

  description = "Project for blog & the long radio."
  environment = "Production"
  is_default  = false
  purpose     = "Web Application"
}

resource "digitalocean_project_resources" "project_cluster" {
  project = digitalocean_project.ambient.id
  resources = [
    digitalocean_kubernetes_cluster.ambient.urn
  ]

  depends_on = [
    digitalocean_kubernetes_cluster.ambient,
    digitalocean_project.ambient
  ]
}