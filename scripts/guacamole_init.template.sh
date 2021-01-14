#!/bin/bash
# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: guacamole_init.template.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.11.22
# Revision...: 
# Purpose....: Template script to initialize the guacamole stack.
# Notes......: --
# Reference..: --
# ---------------------------------------------------------------------------

# - Customization -----------------------------------------------------------
EMAIL="${admin_email}"                      # A valid address is strongly recommended for lets encrypt
HOSTNAME="${host_name}"                     # Hostname for the bastion host
DOMAINNAME="${domain_name}"                 # Domainname for the bastion host
STAGING_ENABLE=${staging}                   # Set to 1 if you're testing your setup to avoid hitting request limits
GUACAMOLE_USER=${guacamole_user}
GUACADMIN_USER="${guacadmin_user}"          # guacadmin user name   
GUACADMIN_PASSWORD="${guacadmin_password}"  # Password for the guacadmin user
GUACAMOLE_ENABLED="${guacamole_enabled}"    # enable guacamole setup
# - End of Customization ----------------------------------------------------

# - Default Values ----------------------------------------------------------
export SCRIPT_NAME=$(basename "$0")
export SCRIPT_BIN="$(cd "$(dirname "$BASH_SOURCE[0]")" ; pwd -P)"
export SCRIPT_BASE="$(dirname $SCRIPT_BIN)"
export GITHUP_REPO="https://github.com/oehrlis/guacamole.git"
export GUACAMOLE_CONSOLE="n/a"
# define logfile and logging
LOG_BASE="/var/log"
TIMESTAMP=$(date "+%Y.%m.%d_%H%M%S")
readonly LOGFILE="$LOG_BASE/$(basename $SCRIPT_NAME .sh)_$TIMESTAMP.log"
# - EOF Default Values ------------------------------------------------------

# - Initialization ----------------------------------------------------------
# Define a bunch of bash option see 
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o nounset          # stop script after 1st cmd failed
set -o errexit          # exit when 1st unset variable found
set -o pipefail         # pipefail exit after 1st piped commands failed

# initialize logfile
touch $LOGFILE 2>/dev/null
exec &> >(tee -a "$LOGFILE")    # Open standard out at `$LOG_FILE` for write.  
exec 2>&1                       # Redirect standard error to standard out 

# - Main --------------------------------------------------------------------
echo "INFO: Start to initialize the guacamole stack at $(date)" 

# get latest release of docker-compose
if ! command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_URL=$(curl -sL https://api.github.com/repos/docker/compose/releases/latest | jq -r '.assets[].browser_download_url'|grep -E "$(uname -s)-$(uname -m)$")
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
    # clone guacamole git repo
    su -l $GUACAMOLE_USER -c "cd /home/$GUACAMOLE_USER ; git clone $GITHUP_REPO"
else
    echo "ERR : /home/$GUACAMOLE_USER/guacamole already exists ..."
    exit 1
fi

# Copy the connection script to the guacamole folder
if [ -f "/home/$GUACAMOLE_USER/02_connections.sql" ]; then
    su -l $GUACAMOLE_USER -c "mv /home/$GUACAMOLE_USER/02_connections.sql /home/$GUACAMOLE_USER/guacamole/config/mysql/02_connections.sql"
fi

echo "GUACAMOLE_ENABLED=$GUACAMOLE_ENABLED"
if [ $GUACAMOLE_ENABLED == "true" ]; then
    echo "INFO: Setup guacamole stack" 
    # setup guacamole 
    su -l $GUACAMOLE_USER -c "\
    export HOSTNAME=$HOSTNAME; \
    export DOMAINNAME=$DOMAINNAME; \
    export EMAIL=$EMAIL; \
    export STAGING_ENABLE=$STAGING_ENABLE; \
    export GUACAMOLE_USER=$GUACAMOLE_USER; \
    export GUACADMIN_USER=$GUACADMIN_USER; \
    export GUACADMIN_PASSWORD=$GUACADMIN_PASSWORD; \
    /home/$GUACAMOLE_USER/guacamole/bin/setup_guacamole.sh"

    # get guacadmin password
    if [ -z "$GUACADMIN_PASSWORD" ]; then
        GUACADMIN_PASSWORD=$(grep -i GUACADMIN_PASSWORD /home/$GUACAMOLE_USER/guacamole/.env |cut -d= -f2)
    fi
    GUACAMOLE_CONSOLE="http://$HOSTNAME.$DOMAINNAME/guacamole"
else    
    echo "INFO: Skip setup of guacamole stack" 
fi

# add a login banner
echo "INFO: Configure login banner"
cp -v /etc/motd /etc/motd.orig
cat << EOF >/etc/motd
--------------------------------------------------------------------
-
- Welcome to the bastion / jump host for the OCI environment
- hostname          :   $HOSTNAME.$DOMAINNAME
- Public IP         :   $(dig +short myip.opendns.com @resolver1.opendns.com)
- Guacamole Console :   $GUACAMOLE_CONSOLE
- Guacamole Admin   :   $GUACADMIN_USER
- Guacamole Password:   $GUACADMIN_PASSWORD

EOF

echo "INFO: Finish the configuration of the guacamole stack at $(date)" 
# --- EOF --------------------------------------------------------------------