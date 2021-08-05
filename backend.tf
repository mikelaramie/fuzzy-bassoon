terraform {
  backend "gcs" {
    bucket = "mtothel-terraform-state"
    prefix = "fuzzy-bassoon/"
  }
}
