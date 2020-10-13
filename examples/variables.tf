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
variable "fingerprint" {
  description = "fingerprint of oci api private key"
  type        = string
  default     = ""
}

variable "private_key_path" {
  description = "path to oci api private key used"
  type        = string
  default     = ""
}

variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "the oci region where resources will be created"
  type        = string
}

variable "tenancy_ocid" {
  description = "tenancy id where to create the sources"
  type        = string
}

variable "user_ocid" {
  description = "id of user that terraform will use to create the resources"
  type        = string
}

# general oci parameters
variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}

# vcn parameters
variable "internet_gateway_enabled" {
  description = "whether to create the internet gateway"
  default     = true
  type        = bool
}

variable "nat_gateway_enabled" {
  description = "whether to create a nat gateway in the vcn"
  default     = true
  type        = bool
}

variable "service_gateway_enabled" {
  description = "whether to create a service gateway"
  default     = false
  type        = bool
}

variable "vcn_cidr" {
  description = "cidr block of VCN"
  default     = "10.0.0.0/16"
  type        = string
}

variable "vcn_name" {
  description = "user-friendly name of to use for the vcn to be appended to the label_prefix"
  type        = string
}

variable "tvd_participants" {
  description = "The number of VCNs to create"
  type        = number
  default     = 1
}

variable "tags" {
  description = "simple key-value pairs to tag the resources created"
  type        = map(any)
}
# --- EOF -------------------------------------------------------------------