#!/bin/bash
# Ce fichier a été créé par TheGostOfNight

# Exécutez ce fichier avec l'utilisateur root

# Avant d'exécuter le script, assurez-vous de disposer de :
# Connexion Internet
# Debian 12.x.x ou version ultérieure
# ------------------------------------------------

echo "  _______ _           _____           _    ____   __ _   _ _       _     _   "
echo " |__   __| |         / ____|         | |  / __ \ / _| \ | (_)     | |   | |  "
echo "    | |  | |__   ___| |  __  ___  ___| |_| |  | | |_|  \| |_  __ _| |__ | |_ "
echo "    | |  | '_ \ / _ \ | |_ |/ _ \/ __| __| |  | |  _| . ` | |/ _` | '_ \| __|"
echo "    | |  | | | |  __/ |__| | (_) \__ \ |_| |__| | | | |\  | | (_| | | | | |_ "
echo "    |_|  |_| |_|\___|\_____|\___/|___/\__|\____/|_| |_| \_|_|\__, |_| |_|\__|"
echo "                                                              __/ |          "
echo "                                                             |___/           "

# Demande de l'utilisateur s'il est root
read -p "Êtes-vous root ? (oui/non) : " is_root

if [ "$is_root" != "oui" ]; then
  echo "Ce script doit être exécuté en tant que root."
  exit
fi

# Assurez-vous que le cache des paquets système est à jour
apt update

# Installez le serveur web Apache
apt install apache2

# Assurez-vous que le service Apache2 est démarré
systemctl enable --now apache2

# Assurez-vous que le cache des paquets système est à jour
apt update

# Installez MariaDB 10
apt install mariadb-server

# Assurez-vous que MariaDB est en cours d'exécution
systemctl enable --now mariadb

# Installez le dépôt SURY APT
apt update
apt -y install apt-transport-https lsb-release ca-certificates curl wget gnupg2

wget -qO- https://packages.sury.org/php/apt.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sury-php.gpg

echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Assurez-vous que le cache des paquets système est à jour
apt update

# Installez PHP 7.x
apt install php7.4

# Installez les modules PHP supplémentaires
apt install libapache2-mod-php7.4 php7.4-{mysql,intl,curl,gd,xml,mbstring,zip} -y

# Installez le dépôt ownCloud
echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/server:/10/Debian_12/ /' | tee /etc/apt/sources.list.d/isv:ownCloud:server:10.list
curl -fsSL https://download.opensuse.org/repositories/isv:ownCloud:server:10/Debian_12/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/isv_ownCloud_server_10.gpg > /dev/null
apt update
apt install owncloud-complete-files -y

# Configurez Apache pour ownCloud
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

# Rechargez le fichier de configuration
systemctl reload apache2

# Activez le site OwnCloud
a2ensite owncloud.conf

# Désactivez le site Apache par défaut
a2dissite 000-default.conf

# Activez les modules Apache recommandés supplémentaires
a2enmod rewrite mime unique_id php7.4

# Mettez à jour la propriété du répertoire racine ownCloud
chown -R www-data: /var/www/owncloud

# Redémarrez Apache2
systemctl restart apache2

# Désactivez la connexion à distance en tant que root dans MariaDB
mysql <<EOF
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
FLUSH PRIVILEGES;

# Créez la base de données et l'utilisateur de la base de données pour ownCloud
CREATE DATABASE db_owncloud;
GRANT ALL ON db_owncloud.* TO 'ow_admin'@'localhost' IDENTIFIED BY 'xooL9YjS';
FLUSH PRIVILEGES;
EOF
