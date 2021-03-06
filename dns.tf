# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: dns.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.13
# Revision...: 
# Purpose....: DNS registration for bastion jost.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

# update DNS
resource "oci_dns_rrset" "bastion" {
  count           = var.bastion_enabled == true && var.bastion_dns_registration == true ? var.tvd_participants : 0
  zone_name_or_id = var.tvd_domain
  domain          = join(".", [oci_core_instance.bastion.*.hostname_label[count.index], var.tvd_domain])
  rtype           = "A"
  items {
    domain = join(".", [oci_core_instance.bastion.*.hostname_label[count.index], var.tvd_domain])
    rtype  = "A"
    rdata  = oci_core_instance.bastion.*.public_ip[count.index]
    ttl    = 30
  }

}

resource "oci_dns_rrset" "webhost" {
  count           = var.bastion_enabled == true && var.bastion_dns_registration == true && var.webhost_name != "" ? var.tvd_participants : 0
  zone_name_or_id = var.tvd_domain
  domain          = join(".", [var.webhost_name, var.tvd_domain])
  rtype           = "A"
  items {
    domain = join(".", [var.webhost_name, var.tvd_domain])
    rtype  = "A"
    rdata  = oci_core_instance.bastion.*.public_ip[0]
    ttl    = 30
  }

}
# --- EOF -------------------------------------------------------------------
