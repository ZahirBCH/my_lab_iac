provider "google" {
  credentials = file("/tmp/keyfile.json")
  project = "my-lab-production"
  region  = "europe-west9"
  zone    = "europe-west9-a"
}

resource "google_compute_network" "my_network" {
  name = "my-lab-network"
}

resource "google_compute_subnetwork" "my_subnet" {
  name          = "my-lab-subnet"
  region        = "europe-west9" # Remplacez par la région de votre choix
  network       = google_compute_network.my_network.self_link
  ip_cidr_range = "10.0.0.0/24" # Remplacez par la plage IP de votre choix
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

resource "google_artifact_registry_repository" "my_artifact_registry" {
  provider = google

  location      = "europe-west9"
  repository_id = "my-lab-artifact-registry"
  description   = "Ma Artifact Registry pour des images Docker"
  format        = "DOCKER"
}
