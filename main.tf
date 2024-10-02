#--------------------Provider----------------------
provider "google" {
    project = "VCC-TD2-terraform"
    credentials = "./cred.json"
    region  = "europe-west9"
}

#--------------------VPC---------------------------
resource "google_compute_network" "vpc_network" {
  project                 = "VCC-TD2-terraform"
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}

#--------------------BDD dans le VPC---------------
resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "default" {
  name         = "vcc-td2-compute-engine"
  machine_type = "n2-standard-2"
  zone         = "europe-west9-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "vpc-network"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}