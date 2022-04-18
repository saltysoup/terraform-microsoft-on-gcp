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

 resource "google_active_directory_domain" "ad_domain" {
  project = "${var.project_id}"
  domain_name       = "${var.domain_name}"
  locations         = "${var.locations}"
  reserved_ip_range = "${var.reserved_ip_range}"
  admin = "${var.admin_account}"
}