Voici le texte Markdown sans les icônes et avec toutes les parties anglaises suivies de toutes les parties françaises :

### Download Proxmox:
1. Visit the Proxmox download page at [Proxmox Download](https://www.proxmox.com/de/downloads/proxmox-virtual-environment/iso/proxmox-ve-8-0-iso-installer).
2. Téléchargez l'ISO de Proxmox en cliquant sur le lien de téléchargement approprié pour la version 8.0.

### Download Rufus:
1. Visit the Rufus download page at [Rufus Download](https://github.com/pbatard/rufus/releases/download/v4.3/rufus-4.3.exe).
2. Téléchargez le logiciel Rufus en cliquant sur le lien de téléchargement.

### Create a Bootable USB Drive:
1. Insert a USB flash drive (8GB or larger) into your computer.

2. Run Rufus (téléchargé précédemment).

3. In Rufus, under "Device," select your USB drive.

4. Under "Boot selection," click the "Select" button and choose the Proxmox ISO you downloaded.

5. Configure the options as needed, ensuring the Partition Scheme is set to "MBR" or "UEFI" depending on your system.

6. Click "Start" to create the bootable USB drive. This process will erase all data on the USB drive, so make sure you've backed up any important data.

### Install Proxmox:
1. Insert the bootable USB drive into the target computer.

2. Start the computer, and ensure it boots from the USB drive. You may need to change the boot order in the BIOS/UEFI settings.

3. Follow the on-screen instructions to install Proxmox.

4. During the network configuration, change the hostname to something like "homeserver.gost.local."

5. Complete the installation process by following the prompts.

Une fois Proxmox est installé, vous pouvez y accéder via un navigateur web et commencer à configurer vos machines virtuelles.
