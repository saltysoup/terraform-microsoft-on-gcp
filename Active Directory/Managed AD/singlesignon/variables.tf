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

## Common variables

variable "project_id" {
    type = string
    description = "Project ID"
    default     = "injae-sandbox-340804"
}

variable "region" {
  type        = string
  description = "Region to deploy VPC subnet, Managed AD and ADFS instance is running eg. us-central1"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zone where GCE instance is running eg. us-central1-b"
  default     = "us-central1-a"
}

variable "network" {
  type        = string
  description = "name of vpc network"
  default     = "network"
}

## Managed AD variables

variable "network_subnet_managedad_iprange" {
  type        = string
  description = "IP CIDR range for managed ad subnet"
  default     = "10.0.1.0/24"
}

variable "locations" {
  type        = list(string)
  description = "The region/s to deploy Managed AD in list format eg. [\"us-central1\", \"asia-southeast1\"]"
  default = ["us-central1"]
}

variable "domain_name" {
    type = string
    description = "The FQDN of your AD Domain eg. ad.contoso.com"
    default = "ad.contoso.com"
}

variable "reserved_ip_range" {
    type = string
    description = "The IP range to deploy the Managed AD resources in CIDR format eg. 10.152.100.0/24"
    default     = "10.0.2.0/24"
}

variable "admin_account" {
    type = string
    description = "The name of delegated administrator account for Managed AD"
    default = "setupadmin"
}

## ADFS instance variables

variable "network_subnet_adfs_iprange" {
  type        = string
  description = "IP CIDR range for ADFS instance subnet"
  default     = "10.0.2.0/24"
}

variable "adfs_instance_service_account" {
  type        = string
  description = "Name for ADFS instance Service Account"
  default     = "adfs-instance-sa"
}

variable "adfs_instance_machine_type" {
  type        = string
  description = "Machine type for ADFS instance"
  default     = "e2-medium"
}

## Workflows variables

variable "remote_script_location" {
  type        = string
  description = "Path of remote powershell script to execute in VM eg. https://my-bucket/myScript.ps1"
  default     = "https://github.com/saltysoup/terraform-microsoft-on-gcp/raw/main/Active%20Directory/Managed%20AD/singlesignon/scripts/test.ps1"
}

variable "remote_script_sha256_checksum" {
  type        = string
  description = "SHA265 checksum value of remote script"
  default = "3F9A8F18E7943F2BF2C1F8A85E1AD19434B1DADE48890E16181F203C2C19842D"
}

variable "instance_labels" {
  type        = map
  description = "One or more Key Value pairs of instance label to target in map format eg. {\"environment\" = \"dev\"}"
  default = {
    "env" = "test"
  }
}

variable "workflows_service_account" {
  type        = string
  description = "Name for Cloud Workflows Service Account"
  default     = "workflows-sa"
}

variable "workflows_name" {
  type        = string
  description = "Name for Cloud Workflows"
  default     = "Runcommand"
}