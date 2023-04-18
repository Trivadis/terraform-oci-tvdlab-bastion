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
  version = ">= 3.0.0" # to limit module version specifiy upper / lower version = ">= 0.5.0, < 2.0.0"

  # - Mandatory Parameters -----------------------------------------------------
  compartment_id = var.compartment_ocid               # OCID of the compartment where to create all resources
  tenancy_ocid   = var.tenancy_ocid                   # tenancy id where to create the resources
  ssh_public_key = var.ssh_public_key                 # Publiy keys for the authorized_keys file, which are used to access the bastion host.
  bastion_subnet = module.tvdlab-vcn.public_subnet_id # List of subnets for the bastion hosts

  # - Optional Parameters ------------------------------------------------------
  # Lab Configuration
  resource_name = local.resource_name # user-friendly string to name all resource. If undefined it will be derived from compartment name.
  lab_domain    = var.lab_domain      # The domain name of the LAB environment
  numberOf_labs = var.numberOf_labs   # Number of similar lab environments to be created. Default just one environment.

  # general oci parameters
  ad_index     = var.ad_index               # The index of the availability domain. This is used to identify the availability_domain place the compute instances.
  label_prefix = lower(var.label_prefix)    # A string that will be prepended to all resources
  defined_tags = local.bastion_defined_tags # Defined tags for this resource"
  tags         = var.tags                   # "A simple key-value pairs to tag the resources created

  # bastion parameters
  bastion_enabled              = var.bastion_enabled              # whether to create the bastion
  bastion_name                 = var.bastion_name                 # Name portion of bastion host
  bastion_boot_volume_size     = var.bastion_boot_volume_size     # Size of the boot volume.
  bastion_image_id             = var.bastion_image_id             # Provide a custom image id for the bastion host or leave as OEL (Oracle Enterprise Linux).
  bastion_memory_in_gbs        = var.bastion_memory_in_gbs        # The memory in gbs for the shape.
  bastion_ocpus                = var.bastion_ocpus                # The ocpus for the shape.
  bastion_os                   = var.bastion_os                   # Base OS for the bastion host.
  bastion_os_version           = var.bastion_os_version           # Define Base OS version for the bastion host.
  bastion_shape                = var.bastion_shape                # The shape of bastion instance.
  bastion_state                = local.bastion_state              # Whether bastion host should be either RUNNING or STOPPED state.
  bootstrap_cloudinit_template = var.bootstrap_cloudinit_template # Bootstrap script. If left out, it will use the embedded cloud-init configuration to boot the bastion host.
  post_bootstrap_config        = var.post_bootstrap_config        # Host environment config script used after bootstrap host.

  # Network Configuration
  inbound_ssh_port  = var.inbound_ssh_port  # Inbound SSH access port configured in security list.
  inbound_vpn_port  = var.inbound_vpn_port  # Inbound OpenVPN access port configured in security list.
  fail2ban_template = var.fail2ban_template # path to a fail2ban configuration template file
  hosts_file        = local.hosts_file      # Content of a custom host file which has to be appended to /etc/hosts

  # Guacamole Configuration
  admin_email              = var.admin_email              # Admin email used to configure Let's encrypt.
  bastion_dns_registration = var.bastion_dns_registration # whether to register the bastion host in DNS zone
  webproxy_name            = var.webproxy_name            # web proxy name used configure nginx
  webhost_name             = var.webhost_name             # web host name used configure nginx / dns
  guacadmin_password       = local.guacadmin_password     # Guacamole console admin user password. If password is empty it will be autogenerate during setup.
  guacamole_user           = var.guacamole_user           # Guacamole OS user name
  guacamole_connections    = local.guacamole_connections  # path to a custom guacamole connections SQL script
  guacamole_enabled        = var.guacamole_enabled        # whether to configure guacamole or not
  guacadmin_user           = var.guacadmin_user           # Guacamole console admin user
  staging                  = local.staging_enabled        # Set to 1 if you're testing your setup to avoid hitting request limits
}
# --- EOF ----------------------------------------------------------------------
