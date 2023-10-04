#!/bin/bash
# Before running the script:
# - Make it executable with: chmod +x yourscript.sh
# - Execute with sudo privileges: sudo ./yourscript.sh

# Install OpenVPN
# Update the system and install curl
sudo apt-get update
sudo apt-get install curl

curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh

AUTO_INSTALL=y ./openvpn-install.sh

# Install Samba for file server
cd /home/
mkdir share
cd share/
mkdir private
mkdir family

# Create users
useradd user01
passwd user01

useradd user02
passwd user02

useradd user03
passwd user03

# Create groups
groupadd family
groupadd private

# Add users to groups
usermod -aG family,user01
usermod -aG private,user01
usermod -aG family,user02
usermod -aG family,user03

# Assign permissions to folders
chown family family/
chown private private/
ls -l

# Create the share
sudo apt-get install samba 
sudo apt-get install smbclient

# Check if smb.conf file exists
if [ -f /etc/samba/smb.conf ]; then
    echo "[share]" | sudo tee -a /etc/samba/smb.conf
    echo "comment = \"Share File\"" | sudo tee -a /etc/samba/smb.conf
    echo "path = /usr/share" | sudo tee -a /etc/samba/smb.conf
    echo "browseable = yes" | sudo tee -a /etc/samba/smb.conf
    echo "valid users = user01,user02,user03" | sudo tee -a /etc/samba/smb.conf
    echo "public = yes" | sudo tee -a /etc/samba/smb.conf
    echo "writable = yes" | sudo tee -a /etc/samba/smb.conf
    echo "printable = no" | sudo tee -a /etc/samba/smb.conf
    service samba restart
    echo "Samba share has been configured successfully."
else
    echo "The smb.conf file does not exist."
fi
