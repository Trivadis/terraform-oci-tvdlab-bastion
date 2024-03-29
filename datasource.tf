# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: datasource.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.04.19
# Revision...: 
# Purpose....: Compute Instance for the terraform module tvdlab bastion.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------

# get list of availability domains
data "oci_identity_availability_domains" "ad_list" {
  compartment_id = var.tenancy_ocid
}

# get compartment information
data "oci_identity_compartment" "compartment" {
  id = var.compartment_id
}

# define the Oracle linux image
data "oci_core_images" "oracle_images" {
  compartment_id           = var.compartment_id
  operating_system         = var.bastion_os
  operating_system_version = var.bastion_os_version
  shape                    = var.bastion_shape
  sort_by                  = "TIMECREATED"
}

# query for the NS record of the LAB domain to see if we have a DNS Zone
data "oci_dns_rrset" "lab_domain" {
  domain          = var.lab_domain
  rtype           = "NS"
  zone_name_or_id = var.lab_domain
}
# --- EOF ----------------------------------------------------------------------
