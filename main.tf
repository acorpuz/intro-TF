# Any Locals and Data blocks are added here, ideally any other resource should be defined using modules

# reserve static ip
resource "google_compute_address" "static_ip-template" {
  name = format("%s-reserved-ipv4", var.name)
}

data "google_compute_default_service_account" "default" {
}

### Create a GCE Instance
resource "google_compute_instance" "gce_tf-demo" {
  name                      = var.name
  machine_type              = "e2-micro"
  allow_stopping_for_update = true
  deletion_protection       = false
  tags                      = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      labels = {
        client = "turing"
      }
    }
    device_name = format("%s-disk", var.name)
  }

  network_interface {
    network = google_compute_network.vpc_tf-demo.name

    access_config {
      nat_ip = google_compute_address.static_ip-template.address
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}

### Create postgres database
resource "google_compute_global_address" "private_ip_block" {
  name          = "tf-demo-private-ip-block"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 20
  network       = google_compute_network.vpc_tf-demo.self_link
}
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_tf-demo.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}


resource "google_sql_database_instance" "tf-demo-psql" {
  name                = "tf-demo-db"
  database_version    = "POSTGRES_15"
  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = "db-custom-1-3840"
    availability_type = "ZONAL"
    disk_autoresize   = true
    disk_type         = "PD_SSD"

    ip_configuration {
      private_network = google_compute_network.vpc_tf-demo.self_link
      ipv4_enabled    = true // enable Service Networking API
    }
    backup_configuration {
      # no backups in test
      enabled = false
    }
    maintenance_window {
      day          = 7 // Sunday
      hour         = 3
      update_track = "stable"
    }
    database_flags {
      name  = "max_connections"
      value = 512
    }
  }
}
resource "google_sql_user" "postgres-admin" {
  name     = "postgres"
  instance = google_sql_database_instance.tf-demo-psql.name
  password = var.pgpass
}


### Create a storage bucket
resource "google_storage_bucket" "tf-demo-storage" {
  name          = "tf-demo-data"
  location      = "EUROPE-WEST1"
  force_destroy = true
}
