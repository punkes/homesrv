#!/bin/bash
# This file was created by TheGostOfNight

# Run this file with the root user

# Before running the script, make sure you have:
# Internet connection
# Debian 12.x.x or later
# ------------------------------------------------

echo "                                   ▀███                      "
echo "                                     ██                      "
echo "   ▀████████▄▀███  ▀███ ▀████████▄   ██  ▄██▀  ▄▄█▀██ ▄██▀███"
echo "     ██   ▀██  ██    ██   ██    ██   ██ ▄█    ▄█▀   ████   ▀▀"
echo "     ██    ██  ██    ██   ██    ██   ██▄██    ██▀▀▀▀▀▀▀█████▄"
echo "     ██   ▄██  ██    ██   ██    ██   ██ ▀██▄  ██▄    ▄█▄   ██"
echo "     ██████▀   ▀████▀███▄████  ████▄████▄ ██▄▄ ▀█████▀██████▀"
echo "     ██                                                      "
echo "   ▄████▄                                                    "

# Request if user is root
read -p "Are you a root (yes/no) : " is_root

if [ "$is_root" != "oui" ]; then
  echo "This script must be run as root."
  exit
fi

# Ensure the system package cache is up to date
apt update

# Install the Apache web server
apt install apache2

# Ensure Apache2 service is started
systemctl enable --now apache2

# Ensure the system package cache is up to date
apt update

# Install MariaDB 10
apt install mariadb-server

# Ensure MariaDB is running
systemctl enable --now mariadb

# Install the SURY APT repository
apt update
apt -y install apt-transport-https lsb-release ca-certificates curl wget gnupg2

wget -qO- https://packages.sury.org/php/apt.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sury-php.gpg

echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Ensure the system package cache is up to date
apt update

# Install PHP 7.x
apt install php7.4

# Install additional PHP modules
apt install libapache2-mod-php7.4 php7.4-{mysql,intl,curl,gd,xml,mbstring,zip} -y

# Install the ownCloud repository
echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/server:/10/Debian_12/ /' | tee /etc/apt/sources.list.d/isv:ownCloud:server:10.list
curl -fsSL https://download.opensuse.org/repositories/isv:ownCloud:server:10/Debian_12/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/isv_ownCloud_server_10.gpg > /dev/null
apt update
apt install owncloud-complete-files -y

# Configure Apache for ownCloud
cat > /etc/apache2/sites-available/owncloud.conf << 'EOL'
Alias / "/var/www/owncloud/"

<Directory /var/www/owncloud/>
  Options +FollowSymlinks
  AllowOverride All

  <IfModule mod_dav.c>
    Dav off
  </IfModule>

  SetEnv HOME /var/www/owncloud
  SetEnv HTTP_HOME /var/www/owncloud
</Directory>
EOL

# Reload the configuration file
systemctl reload apache2

# Enable the OwnCloud site
a2ensite owncloud.conf

# Disable the default Apache site
a2dissite 000-default.conf

# Enable additional recommended Apache modules
a2enmod rewrite mime unique_id php7.4

# Update ownership of the ownCloud root directory
chown -R www-data: /var/www/owncloud

# Restart Apache2
systemctl restart apache2

# Disable remote root login in MariaDB
mysql <<EOF
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
FLUSH PRIVILEGES;

# Create the database and database user for ownCloud
CREATE DATABASE db_owncloud;
GRANT ALL ON db_owncloud.* TO 'ow_admin'@'localhost' IDENTIFIED BY 'xooL9YjS';
FLUSH PRIVILEGES;
EOF
