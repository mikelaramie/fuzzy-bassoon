# Organization ID to deploy to (if applicable)
variable "org_id" {
  type        = string
  description = "The organization ID (numeric) that resources will be deployed within"
  default     = null
}

variable "parent_folder" {
  type        = string
  description = "The Folder ID (numeric) that folders will be deployed within if not at the org root"
  default     = null
}

variable "folder_id" {
  type        = string
  description = "The Folder ID (numeric) that projects will be deployed within if not automatically creating"
  default     = null
}

variable "main_folder_name" {
  type        = string
  description = "The display name of the folder to be created"
  default     = "Test Infrastructure"
}

variable "billing_account" {
  type        = string
  description = "Billing Account to attach to the projects created"
}

variable "region" {
  type        = string
  description = "Default region to use for resources"
  default     = "us-east1"
}

variable "zone" {
  type        = string
  description = "Default zone to use for resources"
  default     = "us-east1-b"
}
