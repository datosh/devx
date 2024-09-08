resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_network" "vpc_network" {
  name                    = "default"
  auto_create_subnetworks = true
  mtu                     = 1460
}

data "google_compute_address" "static_ip" {
  name = "static-ip"
}

resource "google_compute_firewall" "default" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "default" {
  name         = "letsencrypt-demo"
  machine_type = "e2-medium"

  tags = ["lets-encrypt"]

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2404-noble-amd64-v20240829"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {
      nat_ip = data.google_compute_address.static_ip.address
    }
  }

  metadata = {
    ssh-keys = join("\n", [for key in var.ssh_keys : "${key.user}:${key.key}"])
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = file("install.sh")
}
