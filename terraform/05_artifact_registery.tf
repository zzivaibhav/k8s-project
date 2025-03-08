resource "google_artifact_registry_repository" "microservices_repo" {
  provider      = google
  location      = "us-central1"  
  repository_id = var.artifact_registry_name
  description   = "Docker repository for microservices"
  format        = "DOCKER"
  project       = var.project_id
  depends_on    = [
    google_project_service.enable_artifact_registry,
    google_cloudbuild_trigger.github_trigger
  ]
}
