# Defines here all variables needed.
variable "service_account" {
  type        = string
  description = "Ansible service account"
  default     = "sa-ansible@meetup-demo-443710.iam.gserviceaccount.com"
}
variable "name" {
  type        = string
  description = "Resources name"
}
variable "pgpass" {
  description = "The password for the postgres user in the db"
  type        = string
  sensitive   = true
}
