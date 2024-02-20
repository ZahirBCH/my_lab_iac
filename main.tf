provider "google" {
  credentials = file("/tmp/keyfile.json")
  project = "my-lab-production"
  region  = "europe-west9"
  zone    = "europe-west9-a"
}

resource "google_container_cluster" "primary" {
  name     = "my-lab-cluster"
  location = "europe-west9"

  # Définir les caractéristiques du cluster
  node_pool {
    name       = "default-pool"
    machine_type = "e2-small"
    disk_size_gb = 10
    disk_type = "pd-standard"
    initial_node_count = 1
    node_count = 3

    # Configuration des spécificités du pool de nœuds
    node_config {
      preemptible  = false
      oauth_scopes = [
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
      ]
    }
  }

  # Définir la version de Kubernetes
  min_master_version = "1.21"
  master_version     = "1.21"
}