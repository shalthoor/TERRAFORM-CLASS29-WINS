# 1. VPC Configuration
resource "google_compute_network" "terraform-vpc" {
  name                    = "airtel-network"
  auto_create_subnetworks = false
}

# 2. Subnet Configuration
resource "google_compute_subnetwork" "subnet_test" {
  name          = "subnet-2"
  network       = google_compute_network.terraform-vpc.name
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
}

# 3. Storage Bucket
resource "google_storage_bucket" "bucket-sandesh-class29-wins" {
  name     = "sandeshbucket-${random_id.bucket_suffix.hex}"
  location = "US"
}

# Random suffix for unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 4. VM Instance Configuration
resource "google_compute_instance" "vm_instance" {
  count        = var.instance_count
  name         = "${var.instance_name}-${count.index + 1}"
  machine_type = var.instance_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
      size  = 10
    }
  }

  network_interface {
    network    = google_compute_network.airtel_network.name
    subnetwork = google_compute_subnetwork.subnet_test.name

    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    echo "Hello, World!" > /var/www/html/index.html
    systemctl start apache2
  EOT
}


# 6. Persistent Disk
resource "google_compute_disk" "disk" {
  name  = "my-disk-sandesh"
  size  = 10
  type  = "pd-standard"
  zone  = var.zone
}
