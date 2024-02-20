provider "google" {
  credentials = file("/tmp/keyfile.json")
  project = "my-lab-production"
  region  = "europe-west9"
  zone    = "europe-west9-a"
}

resource "google_container_cluster" "primary" {
  name     = "my-lab-cluster"
  location = "europe-west9-a"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
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