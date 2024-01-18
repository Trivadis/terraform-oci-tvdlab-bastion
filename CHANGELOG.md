# Changelog
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-configure-file { "MD024":{"allow_different_nesting": true }} -->
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] -

### Added

### Changed

### Fixed

### Removed

## [3.0.15] - 2024-01-18

### Changed

- Add command to remove wrong bash completion for docker-compose in *guacamole_init.template.sh*
- Add installation for docker-ce-cli, containerd.io, docker-buildx-plugin and docker-compose-plugin in bastion_host_ol7.yaml
- Add installation for docker-ce-cli, containerd.io, docker-buildx-plugin and docker-compose-plugin in bastion_host_ol8.yaml

## [3.0.14] - 2023-04-24

### Changed

- Update guacamole info in *guacamole_init.template.sh* at the end of the script

## [3.0.13] - 2023-04-24

### Changed

- Change order in bootstrap init file *guacamole_init.template.sh*

## [3.0.12] - 2023-04-24

### Fixed

- Remove *{}* to fix terraform call to function *templatefile*

## [3.0.11] - 2023-04-24

### Changed

- rename *boostrap_custom_config_status* to *bootstrap_custom_config_status*
- explicitly select */* when calculating remaining space

## [3.0.10] - 2023-04-24

### Fixed

- correctly escape variables in *guacamole_init.template.sh*

## [3.0.9] - 2023-04-24

### Fixed

- fix wrong variable name in *guacamole_init.template.sh*

## [3.0.8] - 2023-04-24

### Added

- add a check if script *guacamole_init.sh* is still running and status of
  *boostrap_custom_config_status* is set to **running**. If no login banner will
  report an error

### Changed

- change file headers in *bastion_host_ol7.yaml* and *bastion_host_ol8.yaml*

### Removed

- remove file *bastion_host.yaml*

## [3.0.7] - 2023-04-22

### Changed

- change bootstrap status file to */etc/boostrap_config_status*

## [3.0.6] - 2023-04-19

### Changed

- maintain status in /etc/boostrap_config_status

## [3.0.5] - 2023-04-19

### Changed

- change log base to /var/log

## [3.0.4] - 2023-04-19

### Fixed

- change file type for upload *post_bootstrap_config* in *compute.tf*

## [3.0.3] - 2023-04-19

### Changed

- replace *motd* by *login-info.sh* and add a comprehensive logon header

## [3.0.2] - 2023-04-19

### Changed

- update terreform required version to *1.0.0*

## [3.0.1] - 2023-04-19

### Changed

- update example and add module constrain
- update provider information in exampl *main.tf*

## [3.0.0] - 2023-04-18

### Added

- check *oci_dns_rrset* for NS record of *lab_domain* to see if there is a DNS zone.
  Based on this *dns_registration* and *staging* will be set.

### Changed

- rename *tvd_domain* to *lab_domain*
- rename *tvd_participants* into *numberOf_labs* e.g. Number of lab environments.
- change default OS to OL8
- update *bastion.tf* example
- update *terraform.tfvars* example

### Fixed

### Removed

- remove the variable *yum_upgrade*. The configuration will now be upgraded by
  default. If the upgrade is not necessary/desired, it must be specified in a
  custom cloud-init yaml file.
- remove *ssh_public_key_path*. Bastion host now requires in any case a valid ssh
  key via *ssh_public_key*. e.g. key handling has to be done outside of the module

## [2.3.7] - 2023-04-18

### Fixed

- clean up *cloud-init* template
- fix missing license in *cloud-init* template
- add verbose mode for remove command
- add remove command for docker-compose bash completion file to init script

## [2.3.6] - 2023-04-17

### Added

- add *cloud-init* output using *tee* to capture all subprocess output into a
  logfile e.g. */var/log/cloud-init-output.log*

## [2.3.5] - 2023-04-17

### Fixed

- fix docker repo url
- remove wrong parameter for yum in *bastion_host_ol7.yaml*

## [2.3.4] - 2023-04-17

### Changed

- remove cloud-init config for yum repos
- use dnf / yum config manager

## [2.3.3] - 2023-04-17

### Fixed

- remove *docker-compose* auto completion.

## [2.3.2] - 2023-04-17

### Fixed

- fix tipo in cloud init script
- fix *yum_repos* syntax in cloud-init

## [2.3.1] - 2023-04-17

### Fixed

- remove string function *startswith* in locals.tf to make sure module is backward compatible

## [2.3.0] - 2023-04-17

### Added

- add a dedicated cloud init file for OL7 and OL8

### Changed

- set default cloud init file based on selected OS release e.g. OL7 or OL8

## [2.2.0] - 2023-03-10

### Changed

- Update examples. separate module call from main.tf.

## [2.1.0] - 2023-03-10

### Fixed

- fix a couple of *tflint* issues

### Removed

- remove unused variables

## History

Release history:

- [unreleased]: <https://github.com/Trivadis/terraform-oci-tvdlab-bastion>
- [releases]: <https://github.com/Trivadis/terraform-oci-tvdlab-bastion/releases>
