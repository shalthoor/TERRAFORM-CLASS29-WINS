terraform {
  backend "gcs" {
    bucket = "bucket-sandesh-class29-wins"  # GCS bucket name
    prefix = "terraform/state"              # Path within the bucket (e.g., a folder structure)
  }
}
