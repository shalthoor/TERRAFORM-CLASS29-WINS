provider "google" {
  project     = "october-2026-511906"
  region      = var.region
  credentials = file("kube-abhi-project-a7760852fb32.json")
}
