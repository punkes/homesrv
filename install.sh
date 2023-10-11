#!/bin/bash

# Demande de l'utilisateur s'il est root
read -p "Êtes-vous root ? (oui/non) : " is_root

if [ "$is_root" != "oui" ]; then
  echo "Ce script doit être exécuté en tant que root."
  exit
fi

# Installation d'OpenVPN
sudo apt-get update
sudo apt-get install curl
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
AUTO_INSTALL=y ./openvpn-install.sh

# Installation de Samba
sudo apt-get update
sudo apt-get install -y samba smbclient

# Configuration de Samba
echo "Configuration de Samba..."

if [ -f /etc/samba/smb.conf ]; then
    echo "[share]" | sudo tee -a /etc/samba/smb.conf
    echo "comment = \"Partage de fichiers\"" | sudo tee -a /etc/samba/smb.conf
    echo "path = /usr/share" | sudo tee -a /etc/samba/smb.conf
    echo "browseable = yes" | sudo tee -a /etc/samba/smb.conf
    echo "valid users = user01,user02,user03" | sudo tee -a /etc/samba/smb.conf
    echo "public = yes" | sudo tee -a /etc/samba/smb.conf
    echo "writable = yes" | sudo tee -a /etc/samba/smb.conf
    echo "printable = no" | sudo tee -a /etc/samba/smb.conf
    sudo service smbd restart
    echo "Le partage Samba a été configuré avec succès."
else
    echo "Le fichier smb.conf n'existe pas."
fi

# Demande du nom d'utilisateur et du mot de passe pour les utilisateurs
while true; do
    read -p "Nom de l'utilisateur (ou 'xstop' pour terminer) : " username
    if [ "$username" = "xstop" ]; then
        break
    fi
    read -p "Mot de passe de l'utilisateur : " password
    sudo useradd $username -m -s /bin/false
    echo -e "$password\n$password" | sudo smbpasswd -a -s $username
done

# Demande du nom de la famille pour chaque utilisateur
declare -A user_to_group
while true; do
    read -p "Nom de l'utilisateur (ou 'xstop' pour terminer) : " username
    if [ "$username" = "xstop" ]; then
        break
    fi
    read -p "Nom de la famille pour $username : " family
    user_to_group["$username"]=$family
done

# Création des dossiers avec le nom des familles
for family in "${!user_to_group[@]}"; do
    folder_name="${user_to_group[$family]}"
    sudo mkdir -p /srv/samba/$folder_name
    sudo chown -R $family:$family /srv/samba/$folder_name
done

# Attribution des autorisations aux dossiers
for family in "${!user_to_group[@]}"; do
    folder_name="${user_to_group[$family]}"
    sudo chmod 775 /srv/samba/$folder_name
done

# Création des partages de fichiers dans smb.conf
echo "Création des partages de fichiers dans smb.conf..."
for family in "${!user_to_group[@]}"; do
    folder_name="${user_to_group[$family]}"
    echo "[$family]
    path = /srv/samba/$folder_name
    valid users = @$family
    read only = no" | sudo tee -a /etc/samba/smb.conf
done

# Redémarrage du service Samba
echo "Redémarrage du service Samba..."
sudo systemctl restart smbd

# Installation d'Apache
sudo apt-get install -y apache2

# Demande du nom du site au utilisateur
read -p "Entrez le nom du site (sans espaces, caractères spéciaux, ni accents) : " site_name

# Vérification que le site_name n'est pas vide
if [ -z "$site_name" ]; then
  echo "Le nom du site ne peut pas être vide."
  exit 1
fi

# Répertoire de site web
web_dir="/var/www/$site_name"
config_dir="/etc/apache2/sites-available"

# Création du répertoire du site
mkdir -p "$web_dir"

# Création d'un fichier HTML de démonstration
echo "<html><head><title>$site_name</title></head><body><h1>Bienvenue sur $site_name</h1></body></html>" > "$web_dir/index.html"

# Configuration du site dans Apache
cat <<EOF > "$config_dir/$site_name.conf"
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $site_name
    DocumentRoot $web_dir
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Ajout de l'entrée au fichier /etc/hosts
echo "127.0.0.1 $site_name" >> /etc/hosts

# Redémarrage d'Apache pour appliquer les modifications
systemctl restart apache2

# Vérification du statut d'Apache
if systemctl is-active --quiet apache2; then
  echo "Apache est en cours d'exécution."
else
  echo "Une erreur s'est produite lors du démarrage d'Apache."
fi

# Activation du site
a2ensite "$site_name"

# Redémarrage d'Apache pour appliquer les modifications
systemctl reload apache2

echo "Le script d'installation est terminé."
