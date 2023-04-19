#!/bin/bash
# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: guacamole_init.template.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.04.19
# Revision...: 
# Purpose....: Template script to initialize the guacamole stack.
# Notes......: --
# Reference..: --
# ------------------------------------------------------------------------------

# - Customization --------------------------------------------------------------
EMAIL="${admin_email}"                      # A valid address is strongly recommended for lets encrypt
HOSTNAME="${host_name}"                     # Hostname for the bastion host
DOMAINNAME="${domain_name}"                 # Domainname for the bastion host
WEBHOST_NAME="${webhost_name}"              # web host name used configure nginx / dns
PROXYSERVER="${webproxy_name}"              # web proxy name used configure nginx
VPN_PORT=${vpn_port}                        # OpenVPN port to configure 
STAGING_ENABLE=${staging}                   # Set to 1 if you're testing your setup to avoid hitting request limits
GUACAMOLE_USER=${guacamole_user}
GUACADMIN_USER="${guacadmin_user}"          # guacadmin user name   
GUACADMIN_PASSWORD="${guacadmin_password}"  # Password for the guacadmin user
GUACAMOLE_ENABLED="${guacamole_enabled}"    # enable guacamole setup
# - End of Customization -------------------------------------------------------

# - Default Values -------------------------------------------------------------
export SCRIPT_NAME=$(basename "$0")
export SCRIPT_BIN="$(cd "$(dirname "$BASH_SOURCE[0]")" ; pwd -P)"
export SCRIPT_BASE="$(dirname $SCRIPT_BIN)"
export GITHUP_REPO="https://github.com/oehrlis/guacamole.git"
export GUACAMOLE_CONSOLE="n/a"
# define logfile and logging
LOG_BASE="/var/log"
TIMESTAMP=$(date "+%Y.%m.%d_%H%M%S")
readonly LOGFILE="$LOG_BASE/$(basename $SCRIPT_NAME .sh)_$TIMESTAMP.log"
# - EOF Default Values ---------------------------------------------------------

# - Initialization -------------------------------------------------------------
# Define a bunch of bash option see 
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o nounset          # stop script after 1st cmd failed
set -o errexit          # exit when 1st unset variable found
set -o pipefail         # pipefail exit after 1st piped commands failed

# initialize logfile
touch $LOGFILE 2>/dev/null
exec &> >(tee -a "$LOGFILE")    # Open standard out at `$LOG_FILE` for write.  
exec 2>&1                       # Redirect standard error to standard out 

# - Main -----------------------------------------------------------------------
echo "INFO: Start to initialize the guacamole stack at $(date)" 
# set the bootstrap config status to running
echo "running" >/etc/boostrap_config_status
# get latest release of docker-compose
if ! command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_URL=$(curl -sL https://api.github.com/repos/docker/compose/releases/latest | jq -r '.assets[].browser_download_url'|grep -iE "$(uname -s)-$(uname -m)$")
    DOCKER_COMPOSE_RELEASE=$(echo $DOCKER_COMPOSE_URL|sed -e 's/.*\([[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\).*/\1/')
    curl -L "$DOCKER_COMPOSE_URL" -o /usr/local/bin/docker-compose
    curl -L "https://raw.githubusercontent.com/docker/compose/$DOCKER_COMPOSE_RELEASE/contrib/completion/bash/docker-compose" -o /etc/bash_completion.d/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /bin/docker-compose
    docker-compose --version
fi

# fix permisions
echo "INFO: Change permissions for /home/$GUACAMOLE_USER to $GUACAMOLE_USER" 
chown -R $GUACAMOLE_USER:$GUACAMOLE_USER /home/$GUACAMOLE_USER

# check if we do have the git repo
if [ ! -d "/home/$GUACAMOLE_USER/guacamole" ]; then
    if [ -z "$WEBHOST_NAME" ]; then 
        WEBHOST_NAME=$HOSTNAME
    fi
    if [ -z "$PROXYSERVER" ]; then 
        PROXYSERVER="www.$DOMAINNAME"
    fi
    # clone guacamole git repo
    su -l $GUACAMOLE_USER -c "cd /home/$GUACAMOLE_USER ; git clone $GITHUP_REPO"
    sed -i "s|^NGINX_HOST=.*|NGINX_HOST=$WEBHOST_NAME|" /home/$GUACAMOLE_USER/guacamole/.env
    sed -i "s|^NGINX_DOMAIN=.*|NGINX_DOMAIN=$DOMAINNAME|" /home/$GUACAMOLE_USER/guacamole/.env
    sed -i "s|^NGINX_PROXYSERVER=.*|NGINX_PROXYSERVER=$PROXYSERVER|" /home/$GUACAMOLE_USER/guacamole/.env
    sed -i "s|^OPENVPN_PORT=.*|OPENVPN_PORT=$VPN_PORT|" /home/$GUACAMOLE_USER/guacamole/.env
else
    echo "ERR : /home/$GUACAMOLE_USER/guacamole already exists ..."
    # set the bootstrap config status to error
    echo "error" >/etc/boostrap_config_status
    exit 1
fi

# Copy the connection script to the guacamole folder
if [ -f "/home/$GUACAMOLE_USER/02_connections.sql" ]; then
    su -l $GUACAMOLE_USER -c "cp -v /home/$GUACAMOLE_USER/02_connections.sql /home/$GUACAMOLE_USER/guacamole/config/mysql/02_connections.sql"
fi

echo "GUACAMOLE_ENABLED=$GUACAMOLE_ENABLED"
if [ $GUACAMOLE_ENABLED == "true" ]; then
    echo "INFO: Setup guacamole stack" 
    # setup guacamole 
    su -l $GUACAMOLE_USER -c "\
    export HOSTNAME=$WEBHOST_NAME; \
    export DOMAINNAME=$DOMAINNAME; \
    export EMAIL=$EMAIL; \
    export STAGING_ENABLE=$STAGING_ENABLE; \
    export GUACAMOLE_USER=$GUACAMOLE_USER; \
    export GUACADMIN_USER=$GUACADMIN_USER; \
    export GUACADMIN_PASSWORD=$GUACADMIN_PASSWORD; \
    export OPENVPN_PORT=$VPN_PORT; \
    /home/$GUACAMOLE_USER/guacamole/bin/setup_guacamole.sh"

    # get guacadmin password
    if [ -z "$GUACADMIN_PASSWORD" ]; then
        GUACADMIN_PASSWORD=$(grep -i GUACADMIN_PASSWORD /home/$GUACAMOLE_USER/guacamole/.env |cut -d= -f2)
    fi
    GUACAMOLE_CONSOLE="http://$WEBHOST_NAME.$DOMAINNAME/guacamole"
else    
    echo "INFO: Skip setup of guacamole stack" 
fi

echo "INFO: Add Accenture SSH configuration" 
# accenture ssh config
cat << EOF >/etc/ssh/Banner

This system is the property of Accenture, and is to be used in accordance with
applicable Accenture Policies.Unauthorized access or activity is a violation of
Accenture Policies and may be a violation of law. Use of this system constitutes
consent to monitoring or unauthorized use, in accordance with Accenture Policies,
local laws, and regulations. Unauthorized use may result in penalties including,
but not limited to, reprimand, dismissal, financial penalties, and legal action

EOF
sed -i 's/.*MaxAuthTries.*/MaxAuthTries 5/g' /etc/ssh/sshd_config
sed -i 's/.*HostBasedAuthentication.*/HostBasedAuthentication no/gi' /etc/ssh/sshd_config
sed -i 's/.*PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's|.*Banner.*|Banner /etc/ssh/Banner|g' /etc/ssh/sshd_config
systemctl reload sshd

# add a login banner
echo "INFO: Configure login information"

cat << EOF >/etc/profile.d/login-info.sh
#! /usr/bin/env bash

# Basic info
HOSTNAME=\$(uname -n)
ROOT=\$(df -Ph | grep root| awk '{print \$4}' | tr -d '\n')

# System load
MEMORY1=\$(free -t -m | grep Total | awk '{print \$3" MB";}')
MEMORY2=\$(free -t -m | grep "Mem" | awk '{print \$2" MB";}')
LOAD1=\$(cat /proc/loadavg | awk {'print \$1'})
LOAD5=\$(cat /proc/loadavg | awk {'print \$2'})
LOAD15=\$(cat /proc/loadavg | awk {'print \$3'})
PUBLIC_IP=\$(dig +short myip.opendns.com @resolver1.opendns.com)
export PRIVATE_IP=\$(hostname -I |cut -d' ' -f1)

# cloud-init status information
BOOTSTRAP_STATUS1=\$((sudo cloud-init status 2>/dev/null|| echo "n/a")|cut -d' ' -f2|sed 's/ //g')
BOOTSTRAP_STATUS2=\$(cat /etc/boostrap_config_status 2>/dev/null|| echo "n/a")

echo "
===============================================================================
- Welcome to the bastion / jump host for the OCI environment
-------------------------------------------------------------------------------
- Hostname..........: \$HOSTNAME.$DOMAINNAME
- Public IP.........: \$PUBLIC_IP
- Private IP........: \$PRIVATE_IP
-------------------------------------------------------------------------------
- Disk Space........: \$ROOT remaining
- CPU usage.........: \$LOAD1, \$LOAD5, \$LOAD15 (1, 5, 15 min)
- Memory used.......: \$MEMORY1 / \$MEMORY2
- Swap in use.......: \$(free -m | tail -n 1 | awk '{print \$3}') MB
-------------------------------------------------------------------------------
- Bootstrap Status..: \$BOOTSTRAP_STATUS1
- Config Status.....: \$BOOTSTRAP_STATUS2
-------------------------------------------------------------------------------
- Guacamole Console : $GUACAMOLE_CONSOLE
- Guacamole Admin   : $GUACADMIN_USER
- Guacamole Password: $GUACADMIN_PASSWORD
===============================================================================
"
EOF

# remove failing bash completion for docker-compose
rm -vf /etc/bash_completion.d/docker-compose

# check if we do have an error in the log file
if [ $(grep -iE 'error|err' $LOGFILE|wc -l) -ne 0 ]; then 
    echo "error" >/etc/boostrap_config_status
else
    echo "done" >/etc/boostrap_config_status
fi

# set the bootstrap config status to done
echo "INFO: Finish the configuration of the guacamole stack at $(date)" 
# --- EOF -----------------------------------------------------------------------