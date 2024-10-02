provider "google" {
    project = var.project_id
    credentials = "./cred.json"
    region  = var.region
}