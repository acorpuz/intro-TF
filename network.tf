resource "google_compute_network" "vpc_tf-demo" {
  name        = var.name
  description = "Network for VM"
}
resource "google_compute_firewall" "rules-tf-demo" {
  name          = format("%s-allow-internal", var.name)
  network       = google_compute_network.vpc_tf-demo.name
  description   = "Allows all connections on internal network"
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = ["10.128.0.0/9"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
}
resource "google_compute_firewall" "rules-ssh-tf-demo" {
  name          = format("%s-allow-ssh", var.name)
  network       = google_compute_network.vpc_tf-demo.name
  description   = "Allows ssh/sftp connections"
  priority      = 65534
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
resource "google_compute_firewall" "rules-http-tf-demo" {
  name          = format("%s-allow-http", var.name)
  network       = google_compute_network.vpc_tf-demo.name
  description   = "Allows http and https connections"
  priority      = 65534
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}
