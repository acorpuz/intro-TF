# Terraform turing-test Configuration 
Terraform repo with standard file separation and default branches.

# Scope of the Project
A sample project for demonstration purposes.

The configuration will create a GCE instance, a PostgreSQL database in a VPC with basic firewall rules granting ssh and web access and a Storage bucket.

# Setup and variables 
Create a GCP service account key [https://console.cloud.google.com/apis/credentials/serviceaccountkey] to enable Terraform to access your GCP account. When creating the key, use the following settings:

* Select the target GCP project.
* Click "Create Service Account".
* Give it any name you like and click "Create".
* For the Role, choose "Project -> Editor", then click "Continue".
* Skip granting additional users access, and click "Done".

After you create your service account, download your service account key.
* Select your service account from the list.
* Select the "Keys" tab.
* In the drop down menu, select "Create new key".
* Leave the "Key Type" as JSON.
* Click "Create" to create the key and save the key file to your system.


## GCP Service accounts notes
To allow for Ansible to connect to GCE instances, an appropriate service account must be created and associated to the instance. Typically we are using the sa-ansible@meetup-demo-443710.iam.gserviceaccount.com service account with the following permissions: 
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

### A sample error message:

```terraform

│ Error: Error when reading or editing Service Account "projects/-/serviceAccounts/xxxxxxxxxxxxx-compute@developer.gserviceaccount.com": googleapi: Error 403: Identity and Access Management (IAM) API has not been used in project xxxxxxxxxxxxx before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/iam.googleapis.com/overview?project=xxxxxxxxxxxxx then retry. If you enabled this API recently, wait a few minutes
for the action to propagate to our systems and retry.
│ Details:
│ [
│   {
│     "@type": "type.googleapis.com/google.rpc.Help",
│     "links": [
│       {
│         "description": "Google developers console API activation",
│         "url": "https://console.developers.google.com/apis/api/iam.googleapis.com/overviw?project=xxxxxxxxxxxxxx"
│       }
│     ]
│   },
│   {
│     "@type": "type.googleapis.com/google.rpc.ErrorInfo",
│     "domain": "googleapis.com",
│     "metadata": {
│       "consumer": "projects/766777705700",
│       "service": "iam.googleapis.com"
│     },
│     "reason": "SERVICE_DISABLED"
│   }
│ ]
│ , accessNotConfigured
│
│   with data.google_compute_default_service_account.default,
│   on main.tf line 8, in data "google_compute_default_service_account" "default":
│    8: data "google_compute_default_service_account" "default" {
│
╵
```

## Security considerations
Do NOT hardcode passwords in the terraform files, the variables.tf file has variables that can be exported in the shell and will be read and used by terraform:

`$ export TF_VAR_pgpass=(db password)`

Then run `terraform fmt; terraform validate; terraform plan; terraform apply`

# Maintainers, contacts and license
License WTFPL (http://www.wtfpl.net/txt/copying/).
