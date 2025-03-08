#connect to github
// Create a secret containing the personal access token and grant permissions to the Service Agent
    // create the secret name
resource "google_secret_manager_secret" "github_token_secret" {
    project =  var.project_id
    secret_id = "github_token"
    depends_on = [ google_project_service.secret_manager_api ]
    replication {
        auto {}
    }
}
    // enter the value in the secret
resource "google_secret_manager_secret_version" "github_token_secret_version" {
    secret = google_secret_manager_secret.github_token_secret.id
    secret_data  = "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"
    depends_on = [ google_secret_manager_secret.github_token_secret ]
}

#bind the role to access the secrets from the service account
data "google_iam_policy" "serviceagent_secretAccessor" {
    binding {
        role = "roles/secretmanager.secretAccessor"
        members = ["serviceAccount:service-${var.project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
    }
    depends_on = [ google_service_account.default ]
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project = google_secret_manager_secret.github_token_secret.project
  secret_id = google_secret_manager_secret.github_token_secret.secret_id
  policy_data = data.google_iam_policy.serviceagent_secretAccessor.policy_data

  depends_on = [ data.google_iam_policy.serviceagent_secretAccessor ]
}

// Create the GitHub connection
resource "google_cloudbuildv2_connection" "my_connection" {
    project = var.project_id
    location = var.region
    name = "github-connection"

    github_config {
        app_installation_id = 62290763
        authorizer_credential {
            oauth_token_secret_version = google_secret_manager_secret_version.github_token_secret_version.id
        }
    }
    depends_on = [google_secret_manager_secret_iam_policy.policy]
}


# connect  to github repo
    resource "google_cloudbuildv2_repository" "my_repository" {
      project = var.project_id
      location = var.region
      name = var.github_repo
      parent_connection = google_cloudbuildv2_connection.my_connection.name
      remote_uri = var.git_uri
      depends_on = [ google_cloudbuildv2_connection.my_connection ]
  }
resource "google_cloudbuild_trigger" "github_trigger" {
  project     = var.project_id
  name        = "github-trigger"
  location    = var.region
  filename    = "cloudbuild.yaml"
  depends_on = [ google_cloudbuildv2_repository.my_repository ]
  repository_event_config {
    repository      = google_cloudbuildv2_repository.my_repository.id
     
    
    push {
      branch = "^main$"
    }
  }
  
  service_account = google_service_account.default.name
}