# ---------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: dns.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.03.09
# Revision...: 
# Purpose....: DNS registration for bastion jost.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

# update DNS
resource "oci_dns_rrset" "bastion" {
  count           = var.bastion_enabled == true && local.dns_registration == true ? var.numberOf_labs : 0
  zone_name_or_id = var.lab_domain
  domain          = join(".", [oci_core_instance.bastion[count.index].hostname_label, var.lab_domain])
  rtype           = "A"
  items {
    domain = join(".", [oci_core_instance.bastion[count.index].hostname_label, var.lab_domain])
    rtype  = "A"
    rdata  = oci_core_instance.bastion[count.index].public_ip
    ttl    = 30
  }

}

resource "oci_dns_rrset" "webhost" {
  count           = var.bastion_enabled == true && local.dns_registration == true && var.webhost_name != "" ? var.numberOf_labs : 0
  zone_name_or_id = var.lab_domain
  domain          = join(".", [var.webhost_name, var.lab_domain])
  rtype           = "A"
  items {
    domain = join(".", [var.webhost_name, var.lab_domain])
    rtype  = "A"
    rdata  = oci_core_instance.bastion[0].public_ip
    ttl    = 30
  }

}
# --- EOF -------------------------------------------------------------------
