# ---------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: variables.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.03.09
# Revision...: 
# Purpose....: Variable file for the terraform module tvdlab bastion.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

# provider identity parameters ----------------------------------------------
variable "tenancy_ocid" {
  description = "tenancy id where to create the resources"
  type        = string
}

# general oci parameters ----------------------------------------------------
variable "compartment_id" {
  description = "OCID of the compartment where to create all resources"
  type        = string
}

variable "label_prefix" {
  description = "A string that will be prepended to all resources"
  type        = string
  default     = "none"
}

variable "resource_name" {
  description = "user-friendly string to name all resource. If undefined it will be derived from compartment name. "
  type        = string
  default     = ""
}

variable "ad_index" {
  description = "The index of the availability domain. This is used to identify the availability_domain place the compute instances."
  default     = 1
  type        = number
}

variable "defined_tags" {
  description = "Defined tags for this resource"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "A simple key-value pairs to tag the resources created"
  type        = map(any)
  default     = {}
}

# Bastion Host Parameter ----------------------------------------------------
variable "bastion_enabled" {
  description = "whether to create the bastion"
  default     = true
  type        = bool
}

variable "bastion_dns_registration" {
  description = "whether to register the bastion host in DNS zone"
  default     = true
  type        = bool
}

variable "bastion_name" {
  description = "Name portion of bastion host"
  default     = "bastion"
  type        = string
}

variable "bastion_image_id" {
  description = "Provide a custom image id for the bastion host or leave as OEL (Oracle Enterprise Linux)."
  default     = "OEL"
  type        = string
}

variable "bastion_os" {
  description = "Base OS for the bastion host."
  default     = "Oracle Linux"
  type        = string
}

variable "bastion_os_version" {
  description = "Define Base OS version for the bastion host."
  default     = "8"
  type        = string
}

variable "bastion_shape" {
  description = "The shape of bastion instance."
  default     = "VM.Standard.E4.Flex"
  type        = string
}

variable "bastion_ocpus" {
  description = "The ocpus for the shape."
  default     = 1
  type        = number
}

variable "bastion_memory_in_gbs" {
  description = "The memory in gbs for the shape."
  default     = 4
  type        = number
}

variable "bastion_boot_volume_size" {
  description = "Size of the boot volume."
  default     = 50
  type        = number
}

variable "bastion_state" {
  description = "Whether bastion host should be either RUNNING or STOPPED state."
  default     = "RUNNING"
  type        = string
}

variable "bootstrap_cloudinit_template" {
  description = "Bootstrap script. If left out, it will use the embedded cloud-init configuration to boot the bastion host."
  default     = ""
  type        = string
}

variable "post_bootstrap_config" {
  description = "Host environment config script used after bootstrap host."
  default     = ""
  type        = string
}

variable "ssh_public_key" {
  description = "Publiy keys for the authorized_keys file, which are used to access the bastion host."
  default     = ""
  type        = string
}

variable "inbound_vpn_port" {
  description = "Inbound OpenVPN access port configured in security list."
  type        = number
  default     = 1194
}

variable "inbound_ssh_port" {
  description = "Inbound SSH access port configured in security list."
  type        = number
  default     = 22
}

variable "bastion_subnet" {
  description = "List of subnets for the bastion hosts"
  type        = list(string)
}

variable "hosts_file" {
  description = "Content of a custom host file which has to be appended to /etc/hosts"
  default     = ""
  type        = string
}

variable "guacamole_enabled" {
  description = "whether to configure guacamole or not"
  default     = true
  type        = bool
}

variable "webhost_name" {
  description = "web host name used configure nginx / dns"
  default     = ""
  type        = string
}

variable "webproxy_name" {
  description = "web proxy name used configure nginx"
  default     = ""
  type        = string
}

variable "guacamole_connections" {
  description = "path to a custom guacamole connections SQL script"
  default     = ""
  type        = string
}

variable "fail2ban_template" {
  description = "path to a fail2ban configuration template file"
  default     = ""
  type        = string
}

variable "guacamole_user" {
  description = "Guacamole OS user name"
  default     = "avocado"
  type        = string
}

variable "guacadmin_user" {
  description = "Guacamole console admin user"
  default     = "guacadmin"
  type        = string
}

variable "guacadmin_password" {
  description = "Guacamole console admin user password. If password is empty it will be autogenerate during setup."
  default     = ""
  type        = string
}

variable "admin_email" {
  description = "Admin email used to configure Let's encrypt."
  default     = "admin@domain.com"
  type        = string
}

variable "staging" {
  description = "Set to 1 if you're testing your setup to avoid hitting request limits"
  default     = 0
  type        = number
}

# Trivadis LAB specific parameter -------------------------------------------
variable "numberOf_labs" {
  description = "Number of similar lab environments to be created. Default just one environment."
  type        = number
  default     = 1
}

variable "lab_domain" {
  description = "The domain name of the LAB environment"
  type        = string
  default     = "trivadislabs.com"
}
# --- EOF -------------------------------------------------------------------
