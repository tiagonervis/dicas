# Servidor de boot via rede

* Procedimentos para instalação e configuração de um servidor de boot via rede (PXE)
* É necessário ter um servidor DHCP previamente configurado

1. Instalando pacotes necessários:

```
# apt-get install tftpd-hpa syslinux
```

2. Inserir configuração no servidor dhcp: /etc/dhcp/dhcpd.conf

```
filename "pxelinux.0";
next-server 10.1.1.1;
```
3. Acessando pasta do servidor TFTP:

```
# cd /srv/tftp
```

4. Copiando arquivos do syslinux para TFTP:

```
# cp /usr/lib/syslinux/modules/bios/ldlinux.c32 .
# cp /usr/lib/syslinux/modules/bios/menu.c32 .
# cp /usr/lib/syslinux/modules/bios/libutil.c32 .
```

5. Obtendo imagem PXE do repositório:

```
# wget http://ftp.br.debian.org/debian/dists/jessie/main/installer-i386/current/images/netboot/pxelinux.0
```

6. Criando pasta para configuração:

```
# mkdir pxelinux.cfg
```

7. Criando o arquivo de configuração: pxelinux.cfg/default

```
default menu.c32
prompt 0
menu title Boot via rede (PXE)

label linux
 menu label ^Linux
 kernel vmlinuz
 append initrd=initrd vga=791 ro quiet

label memtest86
 menu label ^Memtest86+
 kernel memtest86
```