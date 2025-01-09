# Terraform <name_of_project> Configuration 
Terraform repo with standard file separation and default branches.
-- Add any descriptions here --

# Scope of the Project
-- What the project does --

# Setup and variables 
 -- Describe any setup steps needed (i.e. service accounts json) and any variables needed. --

## GCP Service accounts notes
To allow for Ansible to connect to GCE instances, an appropriate service account must be created and associated to the instance. Typically we are using the sa-ansible-multiproject@rapsodoo-test.iam.gserviceaccount.com service account with the following permissions: 
* Compute OS Admin Login
* Compute OS Login
* Service Account User 

Ensure that the service account is added with the correct permissions in the project's IAM page and associated with the instance during its creation.

## Cloud SQL notes
To create databases, specifically the internal network, there are APIs that need to be activated (substitute xxxxxxx with the project id, this is noted on the terraform error message) :
* Cloud Resource manager: https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=xxxxxxxxx
* SQL admin: https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview?project=xxxxxxxxx
* Service Networking API: https://console.developers.google.com/apis/api/servicenetworking.googleapis.com/overview?project=xxxxxxxxx

Ensure that the GCP account you use to create this terraform resource has the following role:
* servicenetworking.networksAdmin (Service Networking Admin)

## Security considerations
Do NOT hardcode passwords in the terraform files, the main.tf file has variables that can be exported in the shell and will be read and used by terraform:

`$ export TF_VAR_pgpass_test=(test db password)`  
`$ export TF_VAR_pgpass_prod=(production db password)`

Then run `terraform plan; terraform validate; terraform apply`

# Maintainers, contacts and license
Copyright 2021-TODAY Rapsodoo Italia S.r.L. (www.rapsodoo.com)
License LGPL-3.0 or later (https://www.gnu.org/licenses/lgpl).

Maintainer: system@rapsodoo.com
