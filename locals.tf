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
# Modified...:
# see git revision history for more information on changes/updates
# ---------------------------------------------------------------------------

locals {
  all_protocols       = "all"
  availability_domain = data.oci_identity_availability_domains.ad_list.availability_domains[var.availability_domain - 1].name
  icmp_protocol       = 1
  tcp_protocol        = 6
  ssh_port            = 22
  anywhere            = "0.0.0.0/0"
  vcn_shortname       = lower(replace(var.vcn_name, "-", ""))
  public_dns_label    = "public"
  private_dns_label   = "private"
  bastion_image_id    = var.bastion_image_id == "Autonomous" ? data.oci_core_images.autonomous_images.images.0.id : var.bastion_image_id
  #default_private_dns = cidrhost(cidrsubnet(var.vcn_cidr, var.private_newbits, var.private_netnum), var.tvd_dns_hostnum)
  #vcn_cidr            = data.oci_core_vcn.vcn.cidr_block
}
# --- EOF -------------------------------------------------------------------
