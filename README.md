# DIY Home Server 🏡🖥️

Ce référentiel contient des informations sur la création d'un serveur fait maison en utilisant un NUC recyclé ou tout PC ayant une configuration similaire. Le serveur sera configuré avec Debian pour la virtualisation, l'hébergement web 🌐, un serveur VPN 🔒 et un serveur de fichiers 📁.

## Table des matières 📚

1. [Prérequis](#prérequis) ⚙️
2. [Matériel](#matériel) 💻
3. [IInstallation](#installation-fr) 🛠️
4. [onfiguration](#configuration) 🧰
5. [Utilisation](#tilisation) 🚀
6. [Contributions](#contributions) 🤝
7. [Licence](#licence) 📝

## Prérequis ⚙️

Avant de commencer, assurez-vous d'avoir les connaissances minimales en matière de matériel informatique, de virtualisation, de systèmes Linux Debian et de réseaux.

## Matériel 💻

  [📄 Hardware Specifications]([https://github.com/votreutilisateur/votredépôt/blob/master/specs/hardware-specs.md](https://github.com/TheGostOfNight/DIY_Home_Server/blob/main/hardware_specs.md))

## Installation 🛠️

### Télécharger Proxmox :
1. Visitez la page de téléchargement de [Proxmox](https://www.proxmox.com/de/downloads/proxmox-virtual-environment/iso/proxmox-ve-8-0-iso-installer) et télécharger la version 8.0 ou ultérieur.

### Télécharger Rufus :
1. Visitez la page de téléchargement de [Rufus](https://github.com/pbatard/rufus/releases/download/v4.3/rufus-4.3.exe).

### Créer une clé USB bootable :
1. Insérez une clé USB (8 Go ou plus) dans votre ordinateur.

2. Lancez Rufus (précédemment téléchargé).

3. Dans Rufus, sous "Périphérique," sélectionnez votre clé USB.

4. Sous "Type de démarrage," cliquez sur le bouton "Sélection" et choisissez l'ISO de Proxmox que vous avez téléchargé précédament.

5. Cliquez sur "Démarrer" pour créer la clé USB bootable. Ce processus effacera toutes les données sur la clé USB, alors assurez-vous d'avoir sauvegardé toutes les données importantes.

### Installer Proxmox :
1. Insérez la clé USB bootable dans l'ordinateur.

2. Démarrez l'ordinateur et assurez-vous qu'il démarre à partir de la clé USB. Vous devrez peut-être modifier l'ordre de démarrage dans les paramètres du BIOS/UEFI.

3. Suivez les instructions à l'écran pour installer Proxmox.

4. Lors de la configuration du réseau, changez le nom d'hôte pour quelque chose comme "homeserver.gost.local."

5. Terminez le processus d'installation en suivant les invites.

Une fois Proxmox installer correctement et l'ordinateur redémarer, vous pouvez passer a l'étape de configuration.

## Configuration 🧰
1. Une fois que le pc à redémarer le pc devrait afficher son IP.
2. Sur un autre pc taper l'ip et vous etes connecter à l'interface du proxmox.
3. Ouvrir le shell du serveur puis taper ces commandes 
```
nano /etc/apt/sources.list.d/pve-enterprise.list
```
Puis remplacer :
```
bookworm
```
Par :
```
busterf
```
Au final :
```
deb https://enterprise.proxmox.com/debian/pve buster pve-enterprise
```
Puis :
```
nano /etc/apt/sources.list
```
Tous supprimer dans le fichier puis coller ça
```
deb http://ftp.debian.org/debian bookworm main contrib
deb http://ftp.debian.org/debian bookworm-updates main contrib

# Proxmox VE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

# security updates
deb http://security.debian.org/debian-security bookworm-security main contrib
```
Puis mettre à jour le Proxmox
```
apt-get update && apt upgrade
```



## Utilisation 🚀

Expliquez comment utiliser chaque composant du serveur, y compris comment déployer des machines virtuelles sur Debian, comment gérer le site web 🌐, comment se connecter au serveur VPN 🔒 et comment accéder au serveur de fichiers 📁.

## Contributions 🤝

Les contributions à ce projet sont les bienvenues. Si vous souhaitez contribuer, suivez ces étapes :
1. Clonez le référentiel.
2. Créez une nouvelle branche pour votre contribution.
3. Faites vos modifications et testez-les.
4. Soumettez une demande d'extraction (Pull Request) avec une description détaillée de vos modifications.

## Licence 📝

Ce projet est sous licence [GNU General Public License]. Consultez le fichier LICENSE pour plus de détails.
