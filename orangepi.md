# Compilando boot e kernel para OrangePi

Procedimentos para compilar o u-boot, o kernel e instalar o GNU/Debian num cartão de memória para a placa OrangePiOne

## Instalação

1. Instação de todos os pacotes necessários para compilar o kernel e o u-boot:

```
# apt-get install bc curl gcc git libncurses5-dev lzop make u-boot-tools gcc-arm-linux-gnueabihf device-tree-compiler swig libssl-dev bison flex python3-dev python3-distutils
```

2. Crie 2 partições no cartão de memória:

* BOOT - partição em fat para armazenar o kernel e os arquivos de boot (50MB)
* linux - partição em etx4 para instalar o GNU/Debinan (2GB ou mais)

## Compilando u-boot

1. Obtendo repositório:

```
$ git clone git://git.denx.de/u-boot.git
```

2. Entrando na pasta:

```
$ cd u-boot
```

3. Habilitando a saida hdmi:

```
$ echo "CONFIG_VIDEO_DE2=y" >> configs/orangepi_one_defconfig
```

4. Selecionando configuração da orangepi:

```
$ make CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- orangepi_one_defconfig
```

5. Compilando u-boot:

```
$ make CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- -j4
```

6. Copiando para o cartão de memória:

```
# dd if=u-boot-sunxi-with-spl.bin of=/dev/mmcblk1 bs=1024 seek=8
```

7. Criando um arquivo boot.cmd:

```
fatload mmc 0 0x46000000 zImage
fatload mmc 0 0x49000000 sun8i-h3-orangepi-one.dtb
setenv bootargs console=ttyS0,115200 root=/dev/mmcblk0p2 rootwait ${extra}
bootz 0x46000000 - 0x49000000
```

8. Gerando script do arquivo boot.cmd:

```
$ mkimage -T script -C none -n 'Boot script' -d boot.cmd boot.scr
```

9. Copie o arquivo boot.src para a partição BOOT

## Compilando o kernel

1. Descompactando o código fonte do kernel:

```
$ tar -xvf linux-<versao>
```

2. Entrando na pasta do kernel

```
$ cd linux-<versao>
```

3. Caso tenha patchs para aplicar:

```
$ for i in ../patchs/*.patch; do patch -p1 < $i; done
```

4. Copiando arquivo de configuração:

```
$ cp arch/arm/configs/sunxi_defconfig .config
```

5. Compilando o menu de configuração do kernel:

```
$ make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- menuconfig
```

6. Selecione as opções do kernel no menu:

```
> Device Drivers > 
	Common Clock Framework > 
		[*] Support for the Allwinner SoCs DE2 CCU
		
> Device Drivers > 
	USB support >
		<*> USB Mass Storage support
```

7. Compilando o kernel, os módulos e os arquivos dtb:

```
$ make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- -j4 zImage dtbs modules
```

8. Instalando os módulos e os firmwares na pasta onde será criado o sistema:

```
# make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- modules_install INSTALL_MOD_PATH=../rootfs
# make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- firmware_install INSTALL_FW_PATH=../rootfs/lib/firmware
```

9. Caso queira compilar os cabeçalhos do kernel:

```
# make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- headers_install INSTALL_HDR_PATH=temp/
```
10. Copiando kernel e aquivo dtb para a partição BOOT:

```
# cp arch/arm/boot/zImage <boot>
# cp arch/arm/boot/dts/sun8i-h3-orangepi-one.dtb <boot>
```

## Instalando GNU/Debian

1. Instalando pacotes para gerar instalação:

```
# apt-get install debootstrap qemu-user-static
```

2. Instalando o sistema arquitetura ARM:

```
# debootstrap --foreign --arch armhf <versao> rootfs/ http://ftp.br.debian.org/debian
```

3. Copiando emulador ARM:

```
# cp /usr/bin/qemu-arm-static rootfs/usr/bin/
```

4. Continuando instalação usando emulador ARM:

```
# chroot rootfs/ /debootstrap/debootstrap --second-stage
```

5. Mudando o hostname:

```
# nano rootfs/etc/hostname
```

6. Gravando repositórios em rootfs/etc/apt/sources.list:

``` 
deb http://deb.debian.org/debian stretch main contrib non-free
```

7. Configurando arquivo rootfs/etc/fstab:

```
UUID=xxxxxxxxxxx	/	ext4	errors=remount-ro	0	1
UUID=xxxxxxxxxxx	/boot	vfat	defaults		0	0
```

8. Entrando no sistema:

```
# chroot rootfs/
```

9. Atualizando o repositório:

```
# apt-get update
```

10. Configurar zona de horário:

```
# dpkg-reconfigure tzdata
```


11. Instalando local pt_BR UTF-8:

```
# apt-get install locales
# dpkg-reconfigure locales
```

12. Instalando pacotes básicos:

```
# apt-get install ntp openssh-server usbutils bzip2
```

13. Parando serviços em execução:

```
# /etc/init.d/ssh stop
```

14 Definir uma senha do root e sair:

```
# passwd
# exit
```

15. Copiar rootfs para o cartão de memória:

```
# mount /dev/mmcblk1p2 /mnt
# cp -Rvp rootfs/* /mnt
# sync
```

Finalizadas as configurações já é possível dar boot diretamente pela placa.

## Suporte ao Simple Framebuffer (obsoleto) 

1. Inserir codigo no final do arquivo u-boot/drivers/video/sunxi/sunxi_de2.c:

```
/*
 * Simplefb support.
 */

#include <fdtdec.h>
#include <fdt_support.h>

int sunxi_simplefb_setup(void *blob)
{
	struct udevice *de2, *hdmi;
	struct video_priv *de2_priv;
	struct video_uc_platdata *de2_plat;
	int mux;
	int offset, ret;
	u64 start, size;
	const char *pipeline = NULL;

	debug("Setting up simplefb\n");

	if (IS_ENABLED(CONFIG_MACH_SUNXI_H3_H5))
		mux = 0;
	else
		mux = 1;

	/* Skip simplefb setting if DE2 / HDMI is not present */
	ret = uclass_find_device_by_name(UCLASS_VIDEO,
					 "sunxi_de2", &de2);
	if (ret) {
		debug("DE2 not present\n");
		return 0;
	}

	ret = uclass_find_device_by_name(UCLASS_DISPLAY,
					 "sunxi_dw_hdmi", &hdmi);
	if (ret) {
		debug("HDMI not present\n");
		return 0;
	}

	if(mux == 0)
		pipeline = "mixer0-lcd0-hdmi";
	else
		pipeline = "mixer1-lcd1-hdmi";

	de2_priv = dev_get_uclass_priv(de2);
	de2_plat = dev_get_uclass_platdata(de2);

	/* Find a prefilled simpefb node, matching out pipeline config */
	offset = fdt_node_offset_by_compatible(blob, -1,
					       "allwinner,simple-framebuffer");
	while (offset >= 0) {
		ret = fdt_stringlist_search(blob, offset, "allwinner,pipeline",
					    pipeline);
		if (ret == 0)
			break;
		offset = fdt_node_offset_by_compatible(blob, offset,
					       "allwinner,simple-framebuffer");
	}
	if (offset < 0) {
		eprintf("Cannot setup simplefb: node not found\n");
		return 0; /* Keep older kernels working */
	}

	start = gd->bd->bi_dram[0].start;
	size = de2_plat->base - start;
	ret = fdt_fixup_memory_banks(blob, &start, &size, 1);
	if (ret) {
		eprintf("Cannot setup simplefb: Error reserving memory\n");
		return ret;
	}

	ret = fdt_setup_simplefb_node(blob, offset, de2_plat->base,
			de2_priv->xsize, de2_priv->ysize,
			(1 << de2_priv->bpix) / 8 * de2_priv->xsize,
			"x8r8g8b8");

	eprintf("Cannot setup simplefb: Error reserving memory\n");

	if (ret)
		eprintf("Cannot setup simplefb: Error setting properties\n");

	return ret;
}
```

2. Inserir no final do arquivo u-boot/include/configs/sunxi-common.h (antes do último '#endif'):

```
#ifdef CONFIG_VIDEO_DE2
#define CONFIG_VIDEO_DT_SIMPLEFB
#endif
```

3. Modificar o arquivo dts do kernel arch/arm/boot/dts/sun8i-h3.dsti:

```
	chosen {
		#address-cells = <1>;
		#size-cells = <1>;
		ranges;

		framebuffer@0 {
			compatible = "allwinner,simple-framebuffer",
				     "simple-framebuffer";
			allwinner,pipeline = "mixer0-lcd0-hdmi";
			clocks = <&ccu CLK_BUS_TCON0>, <&ccu CLK_BUS_DE>,
				 <&ccu CLK_BUS_HDMI>, <&ccu CLK_DE>,
				 <&ccu CLK_TCON0>, <&ccu CLK_HDMI>;
			status = "disabled";
		};
	};
```

4. Recompilar o u-boot e o kernel.
