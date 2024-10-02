#--------------------Provider----------------------
provider "google" {
    project = var.project_id
    credentials = "./cred.json"
    region  = europe-west9
}

#--------------------VPC---------------------------
resource "google_compute_network" "vpc_network" {
  project                 = "VCC-TD2-terraform"
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}
