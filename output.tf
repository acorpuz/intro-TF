# Define all the outputs here, for example outputs for the route gateway, provisioning state, etc.
output "public_ip" {
  value = google_compute_address.static_ip-template.address
}
