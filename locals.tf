# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: locals.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Local variables for the terraform module tvdlab vcn.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

locals {
  availability_domain   = data.oci_identity_availability_domains.ad_list.availability_domains[var.ad_index - 1].name
  resource_name         = var.resource_name == "" ? data.oci_identity_compartment.compartment.name : var.resource_name
  resource_shortname    = lower(replace(local.resource_name, "-", ""))
  bastion_image_id      = var.bastion_image_id == "OEL" ? data.oci_core_images.oracle_images.images.0.id : var.bastion_image_id
  ssh_public_key_path   = var.ssh_public_key_path == "" ? "${path.module}/etc/authorized_keys.template" : var.ssh_public_key_path
  ssh_authorized_keys   = var.ssh_public_key != "" ? var.ssh_public_key : file(local.ssh_public_key_path)
  hosts_file            = var.hosts_file == "" ? "${path.module}/etc/hosts.template" : var.hosts_file
  guacamole_connections = var.guacamole_connections == "" ? "${path.module}/scripts/guacamole_connections.template.sql" : var.guacamole_connections
  # define and render fail2ban configuration
  fail2ban_template = var.fail2ban_template == "" ? "${path.module}/etc/fail2ban.template.conf" : var.fail2ban_template
  fail2ban_config = base64gzip(templatefile(local.fail2ban_template, {
    admin_email = var.admin_email
  }))

  # define and render bootstrap script
  guacamole_initialization_template = var.guacamole_initialization_template == "" ? "${path.module}/scripts/guacamole_init.template.sh" : var.guacamole_initialization_template
  guacamole_initialization = base64gzip(templatefile(local.guacamole_initialization_template, {
    webhost_name       = var.webhost_name
    webproxy_name      = var.webproxy_name
    host_name          = var.label_prefix == "none" ? format("${local.resource_shortname}-${var.bastion_name}%02d", count.index) : format("${var.label_prefix}-${local.resource_shortname}-${var.bastion_name}%02d", count.index)
    domain_name        = var.tvd_domain
    admin_email        = var.admin_email
    staging            = var.staging
    guacamole_enabled  = var.guacamole_enabled
    guacamole_user     = var.guacamole_user
    guacadmin_user     = var.guacadmin_user
    guacadmin_password = var.guacadmin_password
  }))
  # define and render cloudinit bootstrap configuration
  bootstrap_cloudinit_template = var.bootstrap_cloudinit_template == "" ? "${path.module}/cloudinit/bastion_host.yaml" : var.bootstrap_cloudinit_template
  bootstrap_cloudinit = base64gzip(templatefile(local.bootstrap_cloudinit_template, {
    yum_upgrade              = var.yum_upgrade
    guacamole_user           = var.guacamole_user
    guacamole_connections    = base64gzip(local.guacamole_connections)
    authorized_keys          = base64gzip(file(local.ssh_public_key_path))
    etc_hosts                = base64gzip(local.hosts_file)
    fail2ban_config          = local.fail2ban_config
    guacamole_initialization = local.guacamole_initialization
  }))
  #default_private_dns = cidrhost(cidrsubnet(var.vcn_cidr, var.private_newbits, var.private_netnum), var.tvd_dns_hostnum)
  #vcn_cidr            = data.oci_core_vcn.vcn.cidr_block
}
# --- EOF -------------------------------------------------------------------
