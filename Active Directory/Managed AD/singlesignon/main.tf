/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

## Helper stuff

resource "random_pet" "name" {
  length = 1
}

resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

## VPC stuff
# Create a VPC
resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "${random_pet.name.id}-${var.network}"
  auto_create_subnetworks = false
}

# Create firewall rules
resource "google_compute_firewall" "rules" {
  project     = var.project_id
  name        = "${random_pet.name.id}-adfs"
  network     = google_compute_network.vpc_network.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["${google_compute_network.vpc_network.name}-adfs"]
}

# Create a Managed AD subnet
resource "google_compute_subnetwork" "subnet_managedad" {
  name          = "${google_compute_network.vpc_network.name}-subnet-managedad"
  ip_cidr_range = var.network_subnet_managedad_iprange
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Create a ADFS instance subnet
resource "google_compute_subnetwork" "subnet_adfs" {
  name          = "${google_compute_network.vpc_network.name}-subnet-adfs"
  ip_cidr_range = var.network_subnet_adfs_iprange
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

## Managed AD stuff

resource "google_active_directory_domain" "ad_domain" {
  project           = var.project_id
  domain_name       = var.domain_name
  locations         = var.locations
  reserved_ip_range = google_compute_subnetwork.subnet_managedad.ip_cidr_range
  admin             = var.local_admin_account
}

## ADFS VM stuff

# Create a service account for ADFS instance - used later for Workspace domain delegation
module "service_accounts_adfs" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 3.0"
  project_id = var.project_id
  prefix     = random_pet.name.id
  names      = ["${var.adfs_instance_service_account}"]
  project_roles = [
    "${var.project_id}=>roles/editor" # todo: least privilege
  ]
}

# Create instance
resource "google_compute_instance" "adfs_instance" {
  name         = "${random_pet.name.id}-adfs-vm"
  machine_type = var.adfs_instance_machine_type
  zone         = var.zone

  # target instance labels
  for_each = var.instance_labels
  labels = {
    "${each.key}" = "${each.value}"
  }

  tags = ["${google_compute_network.vpc_network.name}-adfs"]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2022"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_adfs.name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    windows-startup-script-cmd = "net user /add ${var.local_admin_account} ${random_password.password.result} & net localgroup administrators ${var.local_admin_account} /add"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = module.service_accounts_adfs.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    google_active_directory_domain.ad_domain
  ]
}

## Workflows stuff
# Create a service account for Workflows
module "service_accounts_workflows" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 3.0"
  project_id = var.project_id
  prefix     = random_pet.name.id
  names      = ["${var.workflows_service_account}"]
  project_roles = [
    "${var.project_id}=>roles/osconfig.osPolicyAssignmentAdmin",
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/iam.serviceAccountTokenCreator"
  ]
}

# Define and deploy a workflow
resource "google_workflows_workflow" "runcommand" {
  project         = var.project_id
  name            = "${var.workflows_name}-${random_pet.name.id}"
  region          = var.region
  description     = "A cloud workflow using OS guest policy to invoke remote operation on GCE"
  service_account = module.service_accounts_workflows.email
  # target instance labels
  for_each = var.instance_labels
  # Imported main workflow YAML file
  source_contents = templatefile("${path.module}/templates/workflow.yaml",
    {
      zone                          = var.zone
      remote_script_location        = var.remote_script_location
      remote_script_sha256_checksum = var.remote_script_sha256_checksum
      runcommand_name               = "runcommand-${random_pet.name.id}"
      label_key                     = "${each.key}"
      label_value                   = "${each.value}"
      domainName                    = var.domain_name
      localAdminUsername            = var.local_admin_account
      localAdminPassword            = random_password.password.result
      managedADAdminUsername        = var.managedad_admin_account
    }
  )
  depends_on = [
    google_compute_instance.adfs_instance
  ]
}