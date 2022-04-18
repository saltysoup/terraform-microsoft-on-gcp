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

variable "project_id" {
    type = string
    description = "Project ID for Managed AD"
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
}

variable "admin_account" {
    type = string
    description = "The name of delegated administrator account for Managed AD"
    default = "setupadmin"
}