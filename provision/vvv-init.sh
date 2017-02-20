#!/usr/bin/env bash
source ../config/site-vars.sh

# Provision WordPress Stable
echo "Commencing $site_name Site Setup"

# Make a database, if we don't already have one
echo "Creating $site_name database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS $database"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON $database.* TO $dbuser@localhost IDENTIFIED BY '$dbpass';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

# Install and configure the latest stable version of WordPress
if [[ ! -d "${VVV_PATH_TO_SITE}/public_html" ]]; then

  echo "Downloading WordPress Stable, see http://wordpress.org/"
  cd ${VVV_PATH_TO_SITE}
  curl -L -O "https://wordpress.org/latest.tar.gz"
  noroot tar -xvf latest.tar.gz
  mv wordpress public_html
  rm latest.tar.gz
  cd ${VVV_PATH_TO_SITE}/public_html

  echo "Configuring WordPress Stable..."
  noroot wp core config --dbname=$database --dbuser=$dbuser --dbpass=$dbpass --quiet --extra-php < ../config/wp-constants
PHP

    if ${subdomain};

    then
        echo "Installing WordPress Multisite with subdomains..."
        noroot wp core multisite-install --url="$domain" --subdomains --quiet --title="$site_name" --admin_name="$admin_user" --admin_email="$admin_email" --admin_password="$admin_pass"
    else
        echo "Installing WordPress Multisite with subdirectory..."
        noroot wp core multisite-install --url="$domain" --quiet --title="$site_name" --admin_name="$admin_user" --admin_email="$admin_email" --admin_password="$admin_pass"
    fi

    # Install all plugins in the plugins file using CLI
    if [ -f ../config/plugins ]

    echo "Installing Plugins"

    then
        while IFS='' read -r line || [ -n "$line" ]
        do
            if [ "#" != ${line:0:1} ]
            then
                wp plugin install $line
            fi
        done < ../config/plugins
    fi

    echo "Uninstalling Plugins..."
    noroot wp plugin uninstall hello
    noroot wp plugin uninstall akismet

else

  echo "Updating WordPress Stable..."
  cd ${VVV_PATH_TO_SITE}/public_html
  noroot wp core update

fi
