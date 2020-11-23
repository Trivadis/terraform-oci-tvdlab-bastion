# Scripts

This directory contains scripts used by *cloud-init* to setup and bootstrap the bastion host. Template files are adapted at runtime by Terraform `templatefile`. Variables are replaced accordingly.

- [guacamole_init.template.sh](guacamole_init.template.sh) Script to setup and initialize the Guacamole Docker stack on the bastion host based on [oehrlis/guacamole](https://github.com/oehrlis/guacamole).
- [guacamole_connections.template.sql](guacamole_connections.template.sql) Template file to setup custom Guacamole connections. Effective file must be defined by the user when calling the module.
