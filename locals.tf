# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: locals.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.04.19
# Revision...: 
# Purpose....: Local variables for the terraform module tvdlab vcn.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------

locals {
  dns_registration    = data.oci_dns_rrset.lab_domain.id == null ? false : var.bastion_dns_registration
  staging             = local.dns_registration ? 0 : var.staging
  availability_domain = data.oci_identity_availability_domains.ad_list.availability_domains[var.ad_index - 1].name
  resource_name       = var.resource_name == "" ? data.oci_identity_compartment.compartment.name : var.resource_name
  resource_shortname  = lower(replace(local.resource_name, "-", ""))
  bastion_image_id    = var.bastion_image_id == "OEL" ? data.oci_core_images.oracle_images.images[0].id : var.bastion_image_id
  hosts_file          = var.hosts_file == "" ? "${path.module}/etc/hosts.template" : var.hosts_file

  post_bootstrap_config = var.post_bootstrap_config == "" ? "${path.module}/cloudinit/bastion_config.template.sh" : var.post_bootstrap_config
  guacamole_connections = var.guacamole_connections == "" ? "${path.module}/scripts/guacamole_connections.template.sql" : var.guacamole_connections
  # define and render fail2ban configuration
  fail2ban_template = var.fail2ban_template == "" ? "${path.module}/etc/fail2ban.template.conf" : var.fail2ban_template
  fail2ban_config = base64gzip(templatefile(local.fail2ban_template, {
    admin_email = var.admin_email
    ssh_port    = var.inbound_ssh_port
    vpn_port    = var.inbound_vpn_port
  }))

  default_bootstrap_template_name = var.bastion_os_version == "8" ? "bastion_host_ol8.yaml" : "bastion_host_ol7.yaml"
  # define and render cloudinit bootstrap configuration
  bootstrap_cloudinit_template = var.bootstrap_cloudinit_template == "" ? "${path.module}/cloudinit/${local.default_bootstrap_template_name}" : var.bootstrap_cloudinit_template
}
# --- EOF ----------------------------------------------------------------------
