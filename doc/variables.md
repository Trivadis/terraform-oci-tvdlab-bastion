# Module Variables

Variables for the configuration of the terraform module, defined in [variables](../variables.tf).

## Provider

| Parameter      | Description                                                                                                                                                        | Values | Default |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|---------|
| `tenancy_ocid` | Tenancy OCID where to create the resources. Required when configuring provider.                                                                                    | OCID   |         |

## General OCI

| Parameter        | Description                                                                                                         | Values | Default |
|------------------|---------------------------------------------------------------------------------------------------------------------|--------|---------|
| `compartment_id` | OCID of the compartment where to create all resources.                                                              | OCID   |         |
| `label_prefix`   | A string that will be prepended to all resources.                                                                   |        | none    |
| `resource_name`  | A string to name all resource. If undefined it will be derived from compartment name.                               |        | n/a     |
| `defined_tags`   | A simple key-value pairs to tag the resources created.                                                              |        |         |
| `tags`           | A simple key-value pairs to tag the resources created.                                                              |        |         |
| `ad_index`       | The index of the availability domain. This is used to identify the availability_domain place the compute instances. |        | 1       |

## Bastion Host

| Parameter                  | Description                                                                                                | Values            | Default                              |
|----------------------------|------------------------------------------------------------------------------------------------------------|-------------------|--------------------------------------|
| `admin_email`              | Admin email used to configure Let's encrypt.                                                               |                   | admin@domain.com                     |
| `bastion_boot_volume_size` | Size of the boot volume.                                                                                   |                   | 50                                   |
| `bootstrap_cloudinit_template`        | Bootstrap script to provision the bastion host.                                                            |                   | n/a                                  |
| `post_bootstrap_config`        | Post Bootstrap script to provision the bastion host.                                                            |                   | n/a                                  |
| `bastion_dns_registration` | Whether to register the bastion host in DNS zone.                                                          | true/false        | true                                 |
| `bastion_enabled`          | Whether to create the bastion host or not.                                                                 | true/false        | false                                |
| `bastion_image_id`         | Provide a custom image id for the bastion host or leave as OEL (Oracle Enterprise Linux).                  | OCID              | OEL                                  |
| `bastion_name`             | A Name portion of bastion host.                                                                            |                   | bastion                              |
| `bastion_os_version`       | Base OS version for the bastion host. This is used to identify the default `bastion_image_id`              |                   | 7.8                                  |
| `bastion_os`               | Base OS for the bastion host. This is used to identify the default `bastion_image_id`                      |                   | Oracle Linux                         |
| `bastion_shape`            | Bootstrap script. If left out, it will use the embedded cloud-init configuration to boot the bastion host. |                   | VM.Standard.E2.1                     |
| `bastion_state`            | Whether bastion host should be either RUNNING or STOPPED state.                                            | RUNNING / STOPPED | RUNNING                              |
| `bastion_subnet`           | List of subnets for the bastion hosts                                                                      |                   | n/a                                  |
| `fail2ban_template`          | Path to a custom fail2ban configuration file                                                               |                   | `fail2ban.template.conf`             |
| `guacadmin_password`       | Guacamole console admin user password. If password is empty it will be auto generate during setup.         |                   | n/a                                  |
| `guacadmin_user`           | Guacamole console admin user                                                                               |                   | guacadmin                            |
| `guacamole_connections`    | Path to a custom guacamole connections SQL script                                                          |                   | `guacamole_connections.template.sql` |
| `guacamole_enabled`        | Whether to configure guacamole or not"                                                                     | true/false        | true                                 |
| `guacamole_user"`          | Guacamole OS user name                                                                                     |                   | avocado                              |
| `hosts_file`               | Content of a custom hosts file which will be appended to `/etc/hosts`                                         |                   | `hosts.template`                     |
| `ssh_public_key`           | Publiy keys for the authorized_keys file, which are used to access the bastion host        |                   | n/a                                  |
| `staging`                  | Set to 1 if you're testing your setup to avoid hitting request limits                                      | 0/1               | 0                                    |

## Trivadis LAB

Specific parameter to configure the Trivadis LAB environment.

| Parameter          | Description                                                                                                                               | Values | Default          |
|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------|--------|------------------|
| `numberOf_labs` | Number of similar lab environments to be created. Default just one environment. This is used to build several identical environments for a training and laboratory environment. |        | 1                |
| `lab_domain`       | The domain name of the LAB environment. This is used to register the public IP address of the bastion host.                               |        | trivadislabs.com |

## Local Variables

| Parameter             | Description                                                                                    | Values | Default |
|-----------------------|------------------------------------------------------------------------------------------------|--------|---------|
| `availability_domain` | Effective name of the availability domain based on region and `var.ad_index`. |        |         |
| `bastion_image_id`    | Tenancy OCID where to create the resources. Required when configuring provider.                |        |         |
| `resource_name`       | Local variable containing either the value of `var.resource_name` or the compartment name.     |        |         |
| `resource_shortname`  | Short, lower case version of the `resource_name` variable.                                     |        |         |
