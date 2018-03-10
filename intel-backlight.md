# Habilitando ajuste de brilho pelas teclas

1. Instando dependencias
```
# apt-get install acpid
```

2. Criar regra para pemissão da alteração do brilho sem ser root
```
# nano /etc/udev/rules.d/backlight.rules

ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

3. Habilitando acpi no boot do kernel
```
#nano /etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="quiet acpi_osi=Linux"
```

4. Criando script para alteração do brilho
```
#nano /etc/acpi/intel-backlight.sh

#!/bin/bash

maximo=$(cat /sys/class/backlight/intel_backlight/max_brightness)
atual=$(cat /sys/class/backlight/intel_backlight/actual_brightness)

if [ $1 = "mais" ];
then
novo=$((atual + (maximo / 10)))
else
novo=$((atual - (maximo / 10)))
fi

if [ $novo -lt $maximo ]; 
then
echo $novo > /sys/class/backlight/intel_backlight/brightness
else
echo $maximo > /sys/class/backlight/intel_backlight/brightness
fi
```

5. Definindo evento para tecla de aumentar brilho:
```
# nano /etc/acpi/events/backlight-mais

event=video/brightnessup BRTUP 00000086 00000000
action=/etc/acpi/intel-backlight.sh mais
```

6. Definindo evento para tecla de diminuir brilho:
```
# nano /etc/acpi/events/backlight-menos

event=video/brightnessdown BRTDN 00000087 00000000
action=/etc/acpi/intel-backlight.sh menos
```

Obs: Para descobrir qual evento equivale a tecla utilize o comando acpi_listen.
