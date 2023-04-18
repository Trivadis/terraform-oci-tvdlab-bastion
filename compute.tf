# ---------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: compute.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.03.09
# Revision...: 
# Purpose....: Compute Instance for the terraform module tvdlab bastion.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

resource "oci_core_instance" "bastion" {
  count               = var.bastion_enabled == true ? var.numberOf_labs : 0
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.label_prefix == "none" ? format("${local.resource_shortname}-${var.bastion_name}%02d", count.index) : format("${var.label_prefix}-${local.resource_shortname}-${var.bastion_name}%02d", count.index)
  shape               = var.bastion_shape
  state               = var.bastion_state
  freeform_tags       = var.tags
  defined_tags        = var.defined_tags

  create_vnic_details {
    subnet_id        = var.bastion_subnet[count.index]
    assign_public_ip = true
    display_name     = var.label_prefix == "none" ? "bastion-vnic" : "${var.label_prefix}-bastion-vnic"
    hostname_label   = var.label_prefix == "none" ? format("${local.resource_shortname}-${var.bastion_name}%02d", count.index) : format("${var.label_prefix}-${local.resource_shortname}-${var.bastion_name}%02d", count.index)
  }

  # prevent the bastion from destroying and recreating itself if the image ocid changes 
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }

  metadata = {
    ssh_authorized_keys = local.ssh_authorized_keys
    user_data = base64gzip(templatefile(local.bootstrap_cloudinit_template, {
      guacamole_user        = var.guacamole_user
      ssh_port              = var.inbound_ssh_port
      vpn_port              = var.inbound_vpn_port
      guacamole_connections = base64gzip(local.guacamole_connections)
      authorized_keys       = base64gzip(local.ssh_authorized_keys)
      etc_hosts             = base64gzip(local.hosts_file)
      fail2ban_config       = local.fail2ban_config
      post_bootstrap_config = base64gzip(local.post_bootstrap_config)
      guacamole_initialization = base64gzip(templatefile("${path.module}/scripts/guacamole_init.template.sh", {
        webhost_name       = var.webhost_name
        webproxy_name      = var.webproxy_name
        host_name          = var.label_prefix == "none" ? format("${local.resource_shortname}-${var.bastion_name}%02d", count.index) : format("${var.label_prefix}-${local.resource_shortname}-${var.bastion_name}%02d", count.index)
        domain_name        = var.lab_domain
        admin_email        = var.admin_email
        staging            = var.staging
        vpn_port           = var.inbound_vpn_port
        guacamole_enabled  = var.guacamole_enabled
        guacamole_user     = var.guacamole_user
        guacadmin_user     = var.guacadmin_user
        guacadmin_password = var.guacadmin_password
      }))
    }))
  }

  shape_config {
    memory_in_gbs = var.bastion_memory_in_gbs
    ocpus         = var.bastion_ocpus
  }

  source_details {
    source_type             = "image"
    source_id               = local.bastion_image_id
    boot_volume_size_in_gbs = var.bastion_boot_volume_size
  }

  timeouts {
    create = "60m"
  }
}
# --- EOF -------------------------------------------------------------------
