provider "vcd" {
  auth_type                        = "service_account_token_file"
  service_account_token_file       = "token.json"
  org                              = "System"
  url                              = "https://vcloud-r1.dinova.cloud/api"
  allow_unverified_ssl             = true
  allow_service_account_token_file = true
}

terraform {
  # Questo blocco dice a Terrakube di inizializzare lo stato remoto S3
  backend "s3" {}
}

terraform {
  cloud {
    hostname = "terrakube-api.minikube.net"
    organization = "simple"

    workspaces {
      name = "deleteme"
    }
  }
}

resource "vcd_org" "my-org" {
  name             = "test-tf"
  full_name        = "test-tf"
  description      = "The pride of my work"
  is_enabled       = true
  delete_recursive = true
  delete_force     = false

  vapp_lease {
    maximum_runtime_lease_in_sec          = 3600 # 1 hour
    power_off_on_runtime_lease_expiration = true
    maximum_storage_lease_in_sec          = 0 # never expires
    delete_on_storage_lease_expiration    = false
  }
  vapp_template_lease {
    maximum_storage_lease_in_sec       = 604800 # 1 week
    delete_on_storage_lease_expiration = true
  }
  account_lockout {
    enabled                       = true
    invalid_logins_before_lockout = 10
    lockout_interval_minutes      = 60
  }
}
