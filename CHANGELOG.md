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
