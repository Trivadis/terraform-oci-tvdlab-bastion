# ---------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: main.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.03.09
# Revision...: 
# Purpose....: Main file to use terraform module tvdlab bastion.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "3.96.0"
    }
  }
}

# define the terraform provider
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

module "tvdlab-bastion" {
  source  = "Trivadis/tvdlab-bastion/oci"
  version = ">= 2.0.0"

  # - Mandatory Parameters --------------------------------------------------
  tenancy_ocid   = var.tenancy_ocid
  compartment_id = var.compartment_id
  # either ssh_public_key or ssh_public_key_path must be specified
  ssh_public_key      = var.ssh_public_key
  ssh_public_key_path = var.ssh_public_key_path
  bastion_subnet      = module.tvdlab-vcn.public_subnet_id

  # - Optional Parameters ---------------------------------------------------
  # general oci parameters
  ad_index     = var.ad_index
  label_prefix = var.label_prefix
  defined_tags = var.bastion_defined_tags
  tags         = var.tags

  # Lab Configuration
  resource_name    = var.resource_name
  tvd_domain       = var.tvd_domain
  tvd_participants = var.tvd_participants

  # bastion parameters
  bastion_enabled              = var.bastion_enabled
  bastion_dns_registration     = var.bastion_dns_registration
  bastion_name                 = var.bastion_name
  bastion_image_id             = var.bastion_image_id
  bastion_shape                = var.bastion_shape
  bastion_ocpus                = var.bastion_ocpus
  bastion_memory_in_gbs        = var.bastion_memory_in_gbs
  bootstrap_cloudinit_template = var.bootstrap_cloudinit_template
  post_bootstrap_config        = var.post_bootstrap_config
  bastion_state                = var.bastion_state
  bastion_os                   = var.bastion_os
  bastion_os_version           = var.bastion_os_version
  bastion_boot_volume_size     = var.bastion_boot_volume_size
  hosts_file                   = var.hosts_file
  yum_upgrade                  = var.yum_upgrade
  inbound_ssh_port             = var.inbound_ssh_port
  inbound_vpn_port             = var.inbound_vpn_port
  guacamole_enabled            = var.guacamole_enabled
  guacamole_connections        = var.guacamole_connections
  webhost_name                 = var.webhost_name
  webproxy_name                = var.webproxy_name
  fail2ban_template            = var.fail2ban_template
  guacamole_user               = var.guacamole_user
  guacadmin_user               = var.guacadmin_user
  guacadmin_password           = var.guacadmin_password
  admin_email                  = var.admin_email
  staging                      = var.staging
}

# display public IPs of bastion hosts
output "bastion_public_ip" {
  description = "The public IP address of the bastion server instances."
  value       = module.tvdlab-bastion.bastion_public_ip
}
# --- EOF -------------------------------------------------------------------
