#!/bin/bash
echo -e "\e[96m"
echo "--------------------------------------------"
echo " Script de auto-instalação 0.12"
echo "--------------------------------------------"
echo " Autor: Tiago Nervis"
echo " Compatível com: Debian 9 e 10"
echo "--------------------------------------------"
echo -e "\e[97m"
echo -n "Pressione uma tecla para iniciar..."
read -n 1

echo -e "\e[92m"
echo -n "1. Configurando repositório do APT..."
sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
echo "OK"

echo -e "\e[92m"
echo "2. Atualizando sistema..."
echo -ne "\e[90m"
apt-get update
apt-get dist-upgrade --yes

echo -e "\e[92m"
echo "3. Instalando drivers proprietários..."
echo -ne "\e[90m"
apt-get install --yes firmware-linux firmware-realtek firmware-ralink firmware-iwlwifi

echo -e "\e[92m"
echo "4. Instalando utilitários do sistema..."
echo -ne "\e[90m"
apt-get install --yes ntfs-3g dcfldd ntp nmap whois dnsutils telnet openssh-client unrar unzip zip bzip2 p7zip-full xz-utils bing net-tools man traceroute wget curl traceroute rsync htop host bash-completion

echo -e "\e[92m"
echo "5. Instalando arquivos do LXDE..."
echo -ne "\e[90m"
apt-get install --yes --no-install-recommends lxde

echo -e "\e[92m"
echo "6. Instalando ambiente gráfico X..."
echo -ne "\e[90m"
apt-get install --yes xserver-xorg lightdm ttf-dejavu ttf-bitstream-vera pulseaudio network-manager-gnome network-manager network-manager-ssh gvfs-fuse gvfs-backends obconf xscreensaver lxtask mesa-utils lxde-icon-theme gnome-icon-theme lxde-common desktop-base gnome-themes-standard xserver-xorg-input-all

echo -e "\e[92m"
echo "7. Instalando aplicativos comuns..."
echo -ne "\e[90m"
apt-get install --yes gimp vlc xfburn pavucontrol gparted evince gnome-screenshot synaptic lxsession-default-apps gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-plugins-good lxhotkey-plugin-openbox numlockx

echo -e "\e[92m"
echo "8. Desabilitando decorador de janela do GTK3..."
echo -ne "\e[90m"
apt-get install --yes gtk3-nocsd

echo -e "\e[92m"
echo -n "9. Personalizando fundo do lxpanel..."
echo "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAaCAIAAADqseFyAAAAT0lEQVQokc3RwQnAAAgDwKboBo7j/jPpQ+0EsVBaqN8jISDc/SAn3U1tZh7Znzq3XGYyg5nRXEQwOxncmAB4u/ML23ZKVTGDqtLc8r9tywXNxyf1gm/HJwAAAABJRU5ErkJggg==" | base64 --decode > /usr/share/lxpanel/images/background.png
echo "OK"

echo -e "\e[92m"
echo -n "10. Configurando auto-completation do bash..."
echo "
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi" >> /etc/bash.bashrc
echo "OK"

echo -e "\e[92m"
echo "11. Instalando Firefox..."
echo -ne "\e[90m"
wget "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=pt-BR" -O firefox.tar.bz2
bzip2 -vd firefox.tar.bz2
tar -xvf firefox.tar
mv firefox /usr/share/
ln -s /usr/share/firefox/firefox /usr/bin/firefox
chmod -R 777 /usr/share/firefox
rm firefox.*
echo "[Desktop Entry]
Name=Mozilla Firefox
GenericName=Web Browser
Comment=Mozilla Firefox
Exec=firefox
Terminal=false
Icon=/usr/share/firefox/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser" > /usr/share/applications/firefox.desktop
chmod 777 /usr/share/applications/firefox.desktop

echo -e "\e[92m"
echo "12. Instalando LibreOffice..."
echo -ne "\e[90m"
echo -n "Obtendo última versão..."
versao=$(curl --silent "http://tdf.c3sl.ufpr.br/libreoffice/stable/?C=M;O=D" | grep -o '[0-9].[0-9].[0-9]' | head -1)
echo $versao
apt-get install --yes libglu1-mesa
wget "http://tdf.c3sl.ufpr.br/libreoffice/stable/"$versao"/deb/x86_64/LibreOffice_"$versao"_Linux_x86-64_deb_langpack_pt-BR.tar.gz"
wget "http://tdf.c3sl.ufpr.br/libreoffice/stable/"$versao"/deb/x86_64/LibreOffice_"$versao"_Linux_x86-64_deb.tar.gz"
gzip -vd LibreOffice_*.tar.gz
cat LibreOffice_*.tar | tar -xvf - -i
dpkg -i LibreOffice_*/DEBS/*.deb
rm -R LibreOffice_*

echo -e "\e[95m"
echo "Opcionais:"

echo -e "\e[95m"
echo "Instalar utilitários para notebook? [s/n]"
read -rsn1 tecla
if [ $tecla = "s" ]; then
  echo -ne "\e[90m"
  apt-get install --yes blueman xserver-xorg-input-synaptics
  apt-get install --yes camorama
fi

echo -e "\e[95m"
echo "Instalar suporte a impressão? [s/n]"
read -rsn1 tecla
if [ $tecla = "s" ]; then
  echo -ne "\e[90m"
  apt-get install --yes cups system-config-printer xsane
fi

echo -e "\e[95m"
echo "Instalar servidor samba? [s/n]"
read -rsn1 tecla
if [ $tecla = "s" ]; then
  echo -ne "\e[90m"
  apt-get install --yes samba
fi

echo -e "\e[95m"
echo "Instalar utilitários para filmes? [s/n]"
read -rsn1 tecla
if [ $tecla = "s" ]; then
  echo -ne "\e[90m"
  apt-get install --yes handbrake transmission
fi

echo -e "\e[95m"
echo "Instalar Java JDK 8 e suporte a smart-cards? [s/n]"
read -rsn1 tecla
if [ $tecla = "s" ]; then
  echo -ne "\e[90m"
  apt-get install --yes dirmngr pcscd libpcsclite-dev
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
  apt-get update
  apt-get install --yes --allow-unauthenticated oracle-java8-installer
fi

echo -e "\e[95m"
echo "Instalar servidor nginx com PHP? [s/n]"
read -rsn1 tecla
if [ $tecla = "s" ]; then
  echo -ne "\e[90m"
  apt-get install --yes nginx php-fpm php-pgsql php-mysql php-curl php-json php-mbstring php-soap php-simplexml php-zip php-intl php-bz2 php-redis php-memcached php-xdebug
fi

echo -e "\e[95m"
echo "Instalar utilitários de desenvolvedor? [s/n]"
read -rsn1 tecla
if [ $tecla = "s" ]; then
  echo -ne "\e[90m"
  apt-get install --yes git meld filezilla pgadmin3
  curl -sL https://deb.nodesource.com/setup_12.x | bash - apt-get install -y nodejs
  wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add -
  echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list
  apt-get update
  apt-get install --yes atom
  curl -sL https://deb.nodesource.com/setup_10.x | bash -
  apt-get install -y nodejs  
fi

echo -e "\e[95m"
echo "Instalar Firefox Developer? [s/n]"
read -rsn1 tecla
if [ $tecla = "s" ]; then
  echo -ne "\e[90m"
  wget "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=pt-BR" -O firefox-dev.tar.bz2
  bzip2 -vd firefox-dev.tar.bz2
  tar -xvf firefox-dev.tar
  mv firefox /usr/share/firefox-dev
  ln -s /usr/share/firefox-dev/firefox /usr/bin/firefox-dev
  chmod -R 777 /usr/share/firefox-dev
  rm firefox*
  echo "[Desktop Entry]
  Name=Firefox Developer
  GenericName=Web Browser
  Comment=Firefox Developer
  Exec=firefox-dev
  Terminal=false
  Icon=/usr/share/firefox-dev/browser/chrome/icons/default/default128.png
  Type=Application
  Categories=Network;WebBrowser" > /usr/share/applications/firefox-dev.desktop
  chmod 777 /usr/share/applications/firefox-dev.desktop
fi

echo -e "\e[97m"
echo "Limpando arquivos desnecessários..."
echo -ne "\e[90m"
apt-get remove --yes exim4-base sugar-browse-activity hv3
apt-get autoremove --yes
apt-get clean

echo -e "\e[97m"
echo -n "Criando script de update..."
echo "
#!/bin/bash
apt-get update
apt-get dist-upgrade --yes
apt-get autoremove --yes
apt-get clean
" > /root/update.sh
chmod +x /root/update.sh
echo "OK"

echo -e "\e[97m"
echo -n "Ajustando interfaces de rede..."
sed -i 's/allow-hotplug enp/#allow-hotplug enp/g' /etc/network/interfaces
sed -i 's/iface enp/#iface enp/g' /etc/network/interfaces
echo "OK"

echo -e "\e[97m"
echo -n "Instalação finalizada! Deseja reiniciar? [s/n]"
read -rsn1 tecla
if [ $tecla = "s" ]; then
  echo "Reiniciando..."
  systemctl reboot
fi
echo -e "\e[39m"
exit