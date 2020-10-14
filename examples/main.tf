# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: main.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Main file to use terraform module tvdlab vcn.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ---------------------------------------------------------------------------


module "tvdlab-bastion" {
  source  = "Trivadis/tvdlab-bastion/oci"
  version = "1.0.0"

  # - Mandatory Parameters --------------------------------------------------
  tenancy_ocid   = var.tenancy_ocid
  region         = var.region
  compartment_id = var.compartment_id
  # either ssh_public_key or ssh_public_key_path must be specified
  # ssh_public_key      = var.ssh_public_key
  ssh_public_key_path = var.ssh_public_key_path
  bastion_subnet      = module.tvdlab-vcn.public_subnet_id

  # - Optional Parameters ---------------------------------------------------
  # general oci parameters
  availability_domain = var.availability_domain
  label_prefix        = var.label_prefix
  tags                = var.tags

  # Lab Configuration
  resource_name    = var.resource_name
  tvd_domain       = var.tvd_domain
  tvd_participants = var.tvd_participants

  # bastion parameters
  bastion_enabled          = var.bastion_enabled
  bastion_dns_registration = var.bastion_dns_registration
  bastion_name             = var.bastion_name
  bastion_image_id         = var.bastion_image_id
  bastion_shape            = var.bastion_shape
  bastion_bootstrap        = var.bastion_bootstrap
  bastion_state            = var.bastion_state
}

# display public IPs of bastion hosts
output "bastion_public_ip" {
  description = "The public IP address of the bastion server instances."
  value = module.tvdlab-bastion.bastion_public_ip
}
# --- EOF -------------------------------------------------------------------
