# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: bastion.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.03.09
# Revision...: 
# Purpose....: Configuration to build the training bastion host using tvdlab-bastion.
# Notes......: 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------
module "tvdlab-bastion" {
  source  = "Trivadis/tvdlab-bastion/oci"
  version = ">= 2.2.0" # to limit module version specifiy upper / lower version = ">= 0.5.0, < 2.0.0"

  # - Mandatory Parameters -----------------------------------------------------
  compartment_id      = var.compartment_ocid
  tenancy_ocid        = var.tenancy_ocid
  ssh_public_key      = local.ssh_authorized_keys
  ssh_public_key_path = var.ssh_public_key_path

  # - Optional Parameters ------------------------------------------------------
  # Lab Configuration
  resource_name = local.resource_name
  lab_domain    = var.lab_domain
  numberOf_labs = var.numberOf_labs

  # general oci parameters
  ad_index     = var.ad_index
  label_prefix = lower(var.label_prefix)
  defined_tags = local.bastion_defined_tags
  tags         = var.tags

  # bastion parameters
  bastion_enabled              = var.bastion_enabled
  admin_email                  = var.admin_email
  bastion_boot_volume_size     = var.bastion_boot_volume_size
  bastion_dns_registration     = var.bastion_dns_registration
  bastion_image_id             = var.bastion_image_id
  bastion_memory_in_gbs        = var.bastion_memory_in_gbs
  bastion_name                 = var.bastion_name
  bastion_ocpus                = var.bastion_ocpus
  bastion_os                   = var.bastion_os
  bastion_os_version           = var.bastion_os_version
  bastion_shape                = var.bastion_shape
  bastion_state                = local.bastion_state
  bastion_subnet               = module.tvdlab-vcn.public_subnet_id
  bootstrap_cloudinit_template = var.bootstrap_cloudinit_template
  webproxy_name                = var.webproxy_name
  webhost_name                 = var.webhost_name
  inbound_ssh_port             = var.inbound_ssh_port
  inbound_vpn_port             = var.inbound_vpn_port
  fail2ban_template            = var.fail2ban_template
  guacadmin_password           = local.guacadmin_password
  guacadmin_user               = var.guacadmin_user
  guacamole_connections        = local.guacamole_connections
  guacamole_enabled            = var.guacamole_enabled
  guacamole_user               = var.guacamole_user
  hosts_file                   = local.hosts_file
  staging                      = local.staging_enabled
}
# --- EOF ----------------------------------------------------------------------
