# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: variables.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Variable file for the terraform module tvdlab vcn.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ---------------------------------------------------------------------------

# provider identity parameters
variable "region" {
    # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
    description = "The OCI region where resources will be created"
    type        = string
}

variable "tenancy_ocid" {
  description = "tenancy id where to create the sources"
  type        = string
}

# general oci parameters
variable "compartment_id" {
    description = "OCID of the tcompartment where to create all resources"
    type        = string
}

variable "label_prefix" {
    description = "A string that will be prepended to all resources"
    type        = string
    default     = "none"
}

variable "vcn_cidr" {
    description = "cidr block of VCN"
    default     = "10.0.0.0/16"
    type        = string
}

variable "vcn_private_cidr" {
    description = "cidr block of VCN"
    default     = "10.0.1.0/29"
    type        = string
}

variable "vcn_public_cidr" {
    description = "cidr block of VCN"
    default     = "10.0.0.0/29"
    type        = string
}

variable "vcn_name" {
    description = "user-friendly name of to use for the vcn to be appended to the label_prefix"
    type        = string
}

# network parameters

variable "availability_domain" {
  description = "the AD to place the bastion host"
  default     = 1
  type        = number
}

variable "tags" {
  description = "simple key-value pairs to tag the resources created"
  type        = map(any)
  default = {
    environment = "dev"
  }
}

# Bastion Host Parameter
variable "bastion_enabled" {
  description = "whether to create the bastion"
  default     = false
  type        = bool
}

variable "bastion_dns_registration" {
  description = "whether to register the bastion host in DNS zone"
  default     = false
  type        = bool
}

variable "bastion_name" {
  description = "Name portion of bastion host"
  default     = "bastion"
  type        = string
}

variable "bastion_image_id" {
  description = "Provide a custom image id for the bastion host or leave as Autonomous."
  default     = "Autonomous"
  type        = string
}

variable "bastion_shape" {
  description = "The shape of bastion instance."
  default     = "VM.Standard.E2.2"
  type        = string
}

variable "bastion_state" { 
  description = "Whether bastion host should be either RUNNING or STOPPED state. "
  default = "RUNNING" 
}

variable "bastion_upgrade" {
  description = "Whether to upgrade the bastion host packages after provisioning. It's useful to set this to false during development/testing so the bastion is provisioned faster."
  default     = false
  type        = bool
}

variable "ssh_public_key" {
  description = "the content of the ssh public key used to access the bastion. set this or the ssh_public_key_path"
  default     = ""
  type        = string
}

variable "ssh_public_key_path" {
  description = "path to the ssh public key used to access the bastion. set this or the ssh_public_key"
  default     = ""
  type        = string
}

variable "bastion_subnet" {
  description = "List of subnets for the bastion hosts"
  type    = list(string)
}

# variable "bastion_vcn" {
#   description = "List of VCN for the bastion hosts"
#   type    = list(string)
# }

# Trivadis LAB specific parameter
variable "tvd_participants" {
    description = "The number of VCN to create"
    type        = number
    default     = 1
}

variable "tvd_domain" {   
    description = "The domain name of the LAB environment"
    type        = string
    default     = "trivadislabs.com" 
}

variable "tvd_dns1" {   
    description = "The DNS IP of the training environment"
    type        = string
    default     = "10.0.1.4" 
}

variable "tvd_dns2" {   
    description = "The DNS IP of the training environment"
    type        = string
    default     = "8.8.8.8" 
}
# --- EOF -------------------------------------------------------------------