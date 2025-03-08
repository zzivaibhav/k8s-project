# Create the service account
resource "google_service_account" "default" {
  account_id   = "kubernetes-project"
  display_name = "Access to Kubernetes and Compute Engine"
}


# Enable Secret Manager API
resource "google_project_service" "secret_manager_api" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
   
    disable_on_destroy = true
}

# Enable Cloud Build API
resource "google_project_service" "cloud_build_api" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
  disable_on_destroy = true
}

# Enable Kubernetes Engine API
resource "google_project_service" "kubernetes_engine_api" {
  project = var.project_id
  service = "container.googleapis.com"
  depends_on = [google_project_service.cloud_build_api,
  google_project_service.compute_engine_api]
  disable_on_destroy = true
}

# Enable Compute Engine API
resource "google_project_service" "compute_engine_api" {
  project = var.project_id
  service = "compute.googleapis.com"
  depends_on = [google_project_service.cloud_build_api]
  disable_dependent_services=true
}

# Enable Artifact Registry API
resource "google_project_service" "enable_artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  depends_on = [google_project_service.cloud_build_api]
  disable_on_destroy = true
}

# Assign Cloud Run Admin role to the service account
resource "google_project_iam_member" "cloud_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Assign Compute Admin role to the service account
resource "google_project_iam_member" "compute_engine_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Assign Kubernetes Engine Admin role to the service account
resource "google_project_iam_member" "kubernetes_engine_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
  depends_on = [ google_project_service.kubernetes_engine_api ]
}

# Assign Cloud Build Editor role to the service account
resource "google_project_iam_member" "cloud_build_editor" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"
  member  = "serviceAccount:${google_service_account.default.email}"
  depends_on = [ google_project_service.cloud_build_api ]
}


resource "google_project_iam_member" "logs_viewer" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "cloudbuild_logs_viewer" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "cloudbuild_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
 member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "cloudbuild_artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
 member  = "serviceAccount:${google_service_account.default.email}"
}
