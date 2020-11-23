# Configuration Files

This directory contains configuration files and templates used by cloud init.

- [authorized_keys.template](authorized_keys.template) Default *authorized_keys* files used as a fallback if not specified. Effective file must be defined by the user when calling the module.
- [hosts.template](hosts.template) Template for a custom hosts file. This will be appended to the current `/etc/hosts` files. Effective file must be defined by the user when calling the module.
- [fail2ban.template.conf](fail2ban.template.conf) Fail2Ban configuration file.
