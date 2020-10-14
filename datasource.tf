# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: datasource.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Compute Instance for the terraform module tvdlab bastion.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ---------------------------------------------------------------------------

# get list of availability domains
data "oci_identity_availability_domains" "ad_list" {
  compartment_id = var.tenancy_ocid
}

# get tenancy information
data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

# get compartment information
data "oci_identity_compartment" "compartment" {
  id = var.compartment_id
}

# get the tenancy's home region
data "oci_identity_regions" "home_region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenancy.home_region_key]
  }
}

# define the Oracle linux image
data "oci_core_images" "oracle_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = var.bastion_os_version
  shape                    = var.bastion_shape
  sort_by                  = "TIMECREATED"
}
# --- EOF -------------------------------------------------------------------
