# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: outputs.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Output for the terraform module tvdlab bastion.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ---------------------------------------------------------------------------

# display public IPs jumphost
output "bastion_id" {
  description = "OCID of the bastion server instances."
  value = oci_core_instance.bastion.*.id
}

output "bastion_public_ip" {
  description = "The public IP address of the bastion server instances."
  value = oci_core_instance.bastion.*.public_ip
}

output "bastion_dns_records" {
  description = "The DNS records for the bastion server instances."
  value = [oci_dns_record.bastion.*.rdata]
}
# --- EOF -------------------------------------------------------------------