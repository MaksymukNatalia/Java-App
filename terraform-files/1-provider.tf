terraform {
  required_providers {
    google = {
    source  = "hashicorp/google"
    version = "~> 5.0"
  }
 }
}
provider "google" {
 
  project = "schedule-405513"
  region  = "us-central1"
  zone    = "us-central1-a"
}