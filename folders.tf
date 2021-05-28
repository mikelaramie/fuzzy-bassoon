# Creates the folder(s) for our project(s) - disable this if specifying an existing folder via var.folder_id
resource "google_folder" "main_folder" {
  #count           = var.org_id != null ? 1 : 0
  display_name = var.main_folder_name
  parent       = var.parent_folder != null ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}
