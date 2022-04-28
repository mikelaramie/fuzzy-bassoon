# Creates the folder(s) for our project(s) unless an existing folder is set via var.folder_id
resource "google_folder" "main_folder" {
  count        = var.folder_id != null ? 1 : 0
  display_name = var.main_folder_name
  parent       = var.parent_folder != null ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}
