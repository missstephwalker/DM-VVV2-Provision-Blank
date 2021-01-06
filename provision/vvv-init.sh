#!/usr/bin/env bash
# Provision script for Delicious Media WordPress Projects

# Add the bitbucket.org ssh host keys to our known hosts file if it isn't there already
if ! grep -q bitbucket.org ~/.ssh/known_hosts; then
	echo -e "\n Getting BitBucket ssh host keys.\n\n"
    noroot ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts
fi;

# Add the github.com ssh host keys to our known hosts file if it isn't there already
if ! grep -q github.com ~/.ssh/known_hosts; then
	echo -e "\n Getting GitHub ssh host keys.\n\n"
    noroot ssh-keyscan github.com >> ~/.ssh/known_hosts
fi;

# fetch the first host as the primary domain. If none is available, generate a default using the site name
DOMAIN=`get_primary_host "${VVV_SITE_NAME}".test`
SITE_TITLE=`get_config_value 'site_title' "${DOMAIN}"`
WP_VERSION=`get_config_value 'wp_version' 'latest'`
WP_TYPE=`get_config_value 'wp_type' "single"`
DB_NAME=`get_config_value 'db_name' "${VVV_SITE_NAME}"`
DB_NAME=${DB_NAME//[\\\/\.\<\>\:\"\'\|\?\!\*-]/}

# Make a database, if we don't already have one
echo -e "\nCreating database '${DB_NAME}' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Create Nginx log files if missing
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/nginx-error.log
touch ${VVV_PATH_TO_SITE}/log/nginx-access.log

# Install and configure the latest stable version of WordPress
if [[ ! -d "${VVV_PATH_TO_SITE}/public_html" ]]; then

	echo -e "\n Setting up site ${VVV_SITE_NAME}.\n\n"

	# Add the site name to the hosts file
	echo "127.0.0.1 ${VVV_SITE_NAME}.test # vvv-auto" >> "/etc/hosts"

	mkdir -p ${VVV_PATH_TO_SITE}/public_html
	cd ${VVV_PATH_TO_SITE}/public_html

else 
	echo -e "\n Nothing to do for site.\n\n"
fi

#Copy the template across to the conf file
cp -f "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf.tmpl" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
