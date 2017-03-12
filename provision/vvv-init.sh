#!/usr/bin/env bash
# Provision WordPress Stable

# Make a database, if we don't already have one
echo -e "\nCreating database 'example_dev' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS example_dev"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON example_dev.* TO wp@localhost IDENTIFIED BY 'wp';"
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
  noroot wp core config --dbname=example_dev --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
// Match any requests made via xip.io.
if ( isset( \$_SERVER['HTTP_HOST'] ) && preg_match('/^(example.)\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(.xip.io)\z/', \$_SERVER['HTTP_HOST'] ) ) {
    define( 'WP_HOME', 'http://' . \$_SERVER['HTTP_HOST'] );
    define( 'WP_SITEURL', 'http://' . \$_SERVER['HTTP_HOST'] );
}

define( 'WP_DEBUG', true );
define( 'WP_DEBUG_DISPLAY', false );
define( 'WP_DEBUG_LOG', true );
define( 'SCRIPT_DEBUG', true );
define( 'JETPACK_DEV_DEBUG', true );
PHP

  echo "Installing WordPress Multisite..."
  noroot wp core multisite-install --url=example.dev --quiet --title="Example" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password"

  # Install all plugins in the plugins file using CLI
#  noroot wp plugin install debug-bar
#  noroot wp plugin install host-analyticsjs-local
#  noroot wp plugin install jetpack
#  noroot wp plugin install regenerate-thumbnails
#  noroot wp plugin install theme-check
#  noroot wp plugin install w3-total-cache
#  noroot wp plugin install wp-force-login

#  echo "Uninstalling Plugins..."
#  noroot wp plugin uninstall hello
#  noroot wp plugin uninstall akismet

else

  echo "Updating WordPress Stable..."
  cd ${VVV_PATH_TO_SITE}/public_html
  noroot wp core update

fi
