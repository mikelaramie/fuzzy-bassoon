resource "random_id" "suffix" {
  byte_length = 4
}

# Creates the project(s) for our environment(s)
module "gke-project-01" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.3"

  name            = "gke-project-01-${random_id.suffix.hex}"
  project_id      = "gke-project-01-${random_id.suffix.hex}"
  org_id          = var.org_id
  folder_id       = var.folder_id != null ? var.folder_id : google_folder.main_folder.name
  billing_account = var.billing_account

  activate_apis = [
    "cloudbilling.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  default_service_account = "deprivilege"
}
