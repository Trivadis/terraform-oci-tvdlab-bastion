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

# display public IPs jumphost
output "bastion_id" {
  description = "OCID of the bastion server instances."
  value       = oci_core_instance.bastion.*.id
}

output "bastion_hostname" {
  description = "The hostname for VNIC's primary private IP of the bastion server instances."
  value       = oci_core_instance.bastion.*.hostname_label
}

output "bastion_public_ip" {
  description = "The public IP address of the bastion server instances."
  value       = oci_core_instance.bastion.*.public_ip
}

output "bastion_private_ip" {
  description = "The private IP address of the bastion server instances."
  value       = oci_core_instance.bastion.*.private_ip
}

output "bastion_dns_records" {
  description = "The DNS records for the bastion server instances."
  value       = [oci_dns_rrset.bastion.*.items]
}

output "bastion_ssh_access" {
  description = "SSH access string for bastion hosts with specific port"
  value       = formatlist("ssh -A -p ${var.public_ssh_port} opc@%s.${var.tvd_domain}", oci_core_instance.bastion.*.hostname_label)
}
output "bastion_public_url" {
  description = "Bastion Apache Guacammole URL."
  value       = formatlist("http://%s.${var.tvd_domain}/guacamole", oci_core_instance.bastion.*.hostname_label)
}
# --- EOF -------------------------------------------------------------------
