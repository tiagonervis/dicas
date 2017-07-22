#!/bin/bash
echo "Script de autoinstalacao 0.9"

echo "--------------------------------------------"
echo "Adicionar repositorios contrib e non-free..."
echo "--------------------------------------------"
nano /etc/apt/sources.list

echo "--------------------------------------------"
echo "Atualizando..."
echo "--------------------------------------------"
apt-get update
apt-get dist-upgrade

echo "--------------------------------------------"
echo "Instalando drivers proprietarios..."
echo "--------------------------------------------"
apt-get install --yes firmware-linux firmware-realtek firmware-ralink firmware-iwlwifi

echo "--------------------------------------------"
echo "Instalando utilitarios..."
echo "--------------------------------------------"
apt-get install --yes ntfs-3g dcfldd ntp nmap whois dnsutils telnet openssh-client unrar unzip zip bzip2 p7zip-full xz-utils bing net-tools man

echo "--------------------------------------------"
echo "Instalando arquivos do LXDE..."
echo "--------------------------------------------"
apt-get install --yes --no-install-recommends lxde

echo "--------------------------------------------"
echo "Instalando ambiente grafico X..."
echo "--------------------------------------------"
apt-get install --yes xserver-xorg lightdm ttf-dejavu ttf-bitstream-vera pulseaudio network-manager-gnome network-manager gvfs-fuse gvfs-backends obconf xscreensaver lxtask mesa-utils lxde-icon-theme gnome-icon-theme lxde-common desktop-base gnome-themes-standard xserver-xorg-input-all

echo "--------------------------------------------"
echo "Instalando aplicativos comuns..."
echo "--------------------------------------------"
apt-get install --yes gimp vlc xfburn pavucontrol gparted evince gnome-screenshot synaptic cups system-config-printer lxsession-default-apps gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-plugins-good lxhotkey-plugin-openbox xsane

echo "--------------------------------------------"
echo "Desabilitar decorador de janela do GTK3..."
echo "--------------------------------------------"
apt-get install --yes gtk3-nocsd

echo "--------------------------------------------"
echo "Instalando Libreoffice..."
echo "--------------------------------------------"
apt-get install --yes libglu1-mesa
tar -xf libreoffice.tar
dpkg -i libreoffice/*
rm -R libreoffice/

echo "--------------------------------------------"
echo "Instalando Firefox..."
echo "--------------------------------------------"
bzip2 -dk $(find -name 'firefox-[0-9][0-9].[0-9].tar.bz2')
tar -xf $(find -name 'firefox-[0-9][0-9].[0-9].tar')
mv firefox /usr/share/
ln -s /usr/share/firefox/firefox /usr/bin/firefox
chmod -R 777 /usr/share/firefox
rm -R $(find -name 'firefox-[0-9][0-9].[0-9].tar')

echo "--------------------------------------------"
echo "Criando atalho para Firefox..."
echo "--------------------------------------------"
echo "[Desktop Entry]
Name=Mozilla Firefox
GenericName=Web Browser
Comment=Mozilla Firefox
Exec=firefox
Terminal=false
Icon=firefox
Type=Application
Categories=Network;WebBrowser" > /usr/share/applications/firefox.desktop
chmod 777 /usr/share/applications/firefox.desktop

echo "--------------------------------------------"
echo "Instalando fundo do menu..."
echo "--------------------------------------------"
cp background.png /usr/share/lxpanel/images/background.png

echo "--------------------------------------------"
echo "Adicionando repositorios do java..."
echo "--------------------------------------------"
apt-get install dirmngr --yes 
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update

echo "--------------------------------------------"
echo "Instalando Java 8..."
echo "--------------------------------------------"
apt-get install oracle-java8-installer --yes --allow-unauthenticated

echo "--------------------------------------------"
echo "Instalando aplicativos extras..."
echo "--------------------------------------------"
apt-get install filezilla mariadb-client pcscd libpcsclite-dev minicom transmission numlockx handbrake

echo "--------------------------------------------"
echo "Instalando aplicativos para notebook..."
echo "--------------------------------------------"
apt-get install blueman camorama xserver-xorg-input-synaptics

echo "--------------------------------------------"
echo "Instalando servidor samba..."
echo "--------------------------------------------"
apt-get install samba

echo "--------------------------------------------"
echo "Limpando cache e aplicativos ignorados..."
echo "--------------------------------------------"
apt-get remove --yes exim4-base sugar-browse-activity
apt-get autoremove --yes
apt-get clean

echo "--------------------------------------------"
echo "Remover interfaces de rede..."
echo "--------------------------------------------"
nano /etc/network/interfaces

echo "--------------------------------------------"
echo "Adicionar usuario em autologin..."
echo "--------------------------------------------"
nano /etc/lightdm/lightdm.conf

echo "--------------------------------------------"
echo "Reiniciando..."
echo "--------------------------------------------"
reboot
