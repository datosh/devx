terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.0.1"
    }
  }
}

provider "google" {
  project     = "fka-conference-demo"
  region      = "europe-west4"
  zone        = "europe-west4-a"
}

resource "google_compute_address" "static_ip" {
  name = "static-ip"
}
