# create the cluster for on GKE
resource "google_container_cluster" "primary" {
  name  = var.gke_cluster_name
  location = "us-central1-a"
  

  #remove  the default pool
  remove_default_node_pool = true
  initial_node_count = 1
  deletion_protection = false

  depends_on = [
google_project_service.kubernetes_engine_api,
    google_project_service.compute_engine_api,
  google_cloudbuild_trigger.github_trigger
  ]
}

#configure new node pool with one single node
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "custom-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 1
  depends_on = [ google_container_cluster.primary ]
  node_config {
    preemptible  = true
    machine_type = "e2-micro"
    disk_type = "pd-standard"
    disk_size_gb = 12
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
