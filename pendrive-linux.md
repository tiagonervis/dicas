# Pendrive linux

Procedimento para criação de um pendrive bootavel com o GNU/Linux Debian

## Procedimentos iniciais

Pode-se criar 2 partições no pendrive, uma em fat32 onde pode-se utilizar o espaço para armazenar dados e uma outra partição em ext4 onde será armazenado os arquivos do sistema linux

Importante: caso o pendrive seja criado com 2 partições, a primeira a ser criada deve ser a fat32, caso contrario sistemas como windows não reconhecerão o pendrive.

Instalando pacotes necessários:

```
# apt-get install debootstrap
```

### Instalação do sistema

1. Montando o pendrive:

```
# mount /dev/sdb2 /mnt
```

2. Instalando sistema debian:

```
# debootstrap --foreign --arch amd64 jessie /mnt http://ftp.br.debian.org/debian
```

3. Forçar gravação no pendrive:

```
# sync
```

4. Continuar proxima etapa de instalação:

```
# chroot /mnt/ /debootstrap/debootstrap --second-stage
```

5. Forçar gravação no pendrive:

```
# sync
```

6. Mudar nome do host em /mnt/etc/hostname:

```
# nano /mnt/etc/hostname
```

7. Gravar repositorio em /mnt/etc/apt/sources.list:

```
deb http://ftp.br.debian.org/debian stretch main contrib non-free
deb http://security.debian.org/ stretch/updates main
```

8. Configurar o arquivo /mnt/etc/fstab:

```
# echo "UUID=xxxxxxxxxxxxxxxx	/	ext4	errors=remount-ro	0	1" > /mnt/etc/fstab
```

9. Montar unidades locais:

```
# mount -o bind /dev/ /mnt/dev/
# mount -o bind /proc/ /mnt/proc/
# mount -o bind /sys/ /mnt/sys/
```

10. Entrando como root:

```
# chroot /mnt
```

11. Atualizar o repositorio:

```
# apt-get update
```

12. Configurar zona de horario em: None of the above > UTC

```
# dpkg-reconfigure tzdata
```

13. Instalar pacotes relacionados ao idioma:

```
# apt-get install locales console-data
```

14. Configurar o local para: pt_BR UTF-8

```
# dpkg-reconfigure locales
```

15. Instalar pacotes basicos:

```
# apt-get install dcfldd testdisk nmap linux-image-amd64 grub2 openssh-client ntfs-3g p7zip-full bzip2 unrar unzip wpasupplicant usbutils firmware-linux firmware-ralink firmware-realtek firmware-atheros firmware-iwlwifi firmware-brcm80211 dnsutils clonezilla
```

16. Parar servicos em execução:

```
# /etc/init.d/dbus stop
# /etc/init.d/irqbalance stop
```

17. Não permitir que o grub busque outros sistemas operacionais:

```
# echo "GRUB_DISABLE_OS_PROBER=true" >> /etc/default/grub
```

18. Defina a senha de root e saia:

```
# passwd
# exit
```

19. Desmontar locais e unidade:

```
# sync
# umount /mnt/dev/
# umount /mnt/proc/
# umount /mnt/sys/
# umount /mnt
# eject /dev/sdb
```

## Rodando o sistema

Reinicie o computador e selecione como boot o pendrive, apos iniciar o novo sistema faça login como root para proseguir

1. Atualizar o grub:

```
# update-grub
```

2. Configure a rede local para acesso a internet

Exemplo: 

```
# ifconfig eth0 10.1.1.5/8
# ip route add default via 10.1.1.1
```

3. Instalar ambiente grafico lxde:

```
# apt-get install --no-install-recommends lxde
```

4. Instalar programas essenciais:

```
# apt-get install lightdm ttf-dejavu network-manager-gnome gvfs-fuse gvfs-backends obconf xscreensaver lxtask lxsession mesa-utils memtest86+ cups xsane evince pulseaudio pavucontrol firefox-esr-l10n-pt-br vlc camorama gparted gsmartcontrol hardinfo gnome-screenshot printer-driver-hpijs printer-driver-hpcups hplip gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad
```

5. Criar usuario do sistema:

```
# adduser usuario
```

6. Limpar cache apt e reiniciar:

```
# apt-get autoremove
# apt-get clean
# reboot
```