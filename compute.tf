# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: compute.tf
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

resource "oci_core_instance" "bastion" {
  count               = var.bastion_enabled == true ? var.tvd_participants : 0
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.label_prefix == "none" ? format("${local.vcn_shortname}-${var.bastion_name}%02d", count.index) : format("${var.label_prefix}-${local.vcn_shortname}-${var.bastion_name}%02d", count.index)
  shape               = var.bastion_shape
  state               = var.bastion_state
  freeform_tags       = var.tags

  create_vnic_details {
    subnet_id        = var.bastion_subnet[count.index]
    assign_public_ip = true
    display_name     = var.label_prefix == "none" ? "bastion-vnic" : "${var.label_prefix}-bastion-vnic"
    hostname_label   = format("${local.vcn_shortname}-${var.bastion_name}%02d", count.index)
  }

  # prevent the bastion from destroying and recreating itself if the image ocid changes 
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key != "" ? var.ssh_public_key : file(var.ssh_public_key_path)
    #user_data           = data.template_cloudinit_config.bastion[0].rendered
  }

  source_details {
    source_type = "image"
    source_id   = local.bastion_image_id
  }

  timeouts {
    create = "60m"
  }
}
# --- EOF -------------------------------------------------------------------
