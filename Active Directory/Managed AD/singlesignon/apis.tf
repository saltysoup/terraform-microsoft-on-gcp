# Enable Google Workspaces Admin API
resource "google_project_service" "google-workspace-admin" {
  project            = var.project_id
  service            = "admin.googleapis.com"
  disable_on_destroy = false
}

# Enable Workflows API
resource "google_project_service" "google-workflows" {
  project            = var.project_id
  service            = "workflows.googleapis.com"
  disable_on_destroy = false
}

# Enable Compute API
resource "google_project_service" "google-compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# Enable Compute API
resource "google_project_service" "google-managedad" {
  project            = var.project_id
  service            = "managedidentities.googleapis.com"
  disable_on_destroy = false
}