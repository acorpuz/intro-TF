# Specify the backend storage method for the state file and required providers here.
provider "google" {
  credentials = file("sa-terraform.json")

  project = "meetup-demo-443710"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6.14"
    }
  }
}
