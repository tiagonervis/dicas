# Dicas de configurações para notebooks

## Habilitar touchpad

* Instalar o pacote synaptics:

```
# apt-get install xsever-xorg-input-synaptics
```

* Adicionar junto com a inicialização:

```
synclient TapButton1=1
```

* Ou pode ser adicionado no arquivo: /usr/share/X11/xorg.conf.d/50-synaptics.conf

```
Option "TapButton1" "1"
```

## Controle do brilho em bios UEFI

Incluia no grub, nos argumentos do linux a linha:

```
acpi_osi='!Windows 2012'
```

OBS: Este comando funciona em alguns notebooks cujo sistema original instalado era Windows.