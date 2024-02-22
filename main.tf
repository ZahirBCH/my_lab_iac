variable "project_id" {
  type = string
}

provider "google" {
  credentials = file("/tmp/keyfile.json")
  project = var.project_id
  region  = "europe-west9"
  zone    = "europe-west9-a"
}

resource "google_container_cluster" "primary" {
  name     = "my-lab-cluster"
  location = "europe-west9-a"

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.primary.id
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
    disk_size_gb = 10
    disk_type = "pd-standard"
  }
}

resource "google_artifact_registry_repository" "my_artifact_registry" {
  provider      = google

  location      = "europe-west9"
  repository_id = "my-lab-artifact-registry"
  description   = "Ma Artifact Registry pour des images Docker"
  format        = "DOCKER"
}
