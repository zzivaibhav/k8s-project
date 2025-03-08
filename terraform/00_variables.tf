variable "project_id" {
  description = "k8s-assignment-453118"
  type        = string
  default     = "k8s-assignment-453118"
}

variable "project_number" {
  description = "622163477922"
  type        = string
  default     = "622163477922"
  
}
variable "region" {
  description = "us-central1"
  type        = string
  default     = "us-central1"
}

variable "gke_cluster_name" {
  description = "k8s-assignment"
  type        = string
  default     = "k8s-assignment"
}

variable "artifact_registry_name" {
  description = "micro-services"
  type        = string
  default     = "micro-services"
}

variable "github_owner" {
  description = "zzivaibhav"
  type        = string
  default     = "zzivaibhav"
}

variable "github_repo" {
  description = "k8s-project"
  type        = string
  default     = "k8s-project"
}

variable "trigger_branch" {
  description = "^main$"
  type        = string
  default     = "^main$"
  
}

variable "git_uri" {
  description = "https://github.com/zzivaibhav/k8s-project.git"
  type        = string
  default     = "https://github.com/zzivaibhav/k8s-project.git"
}

 