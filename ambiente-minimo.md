# Ambiente gráfico minimo

1. Instalação dos pacotes necessários:

```
# apt-get install xinit openbox xterm feh firefox-esr firefox-esr-l10n-pt-br gtk-theme-switch gtk2-engines alsa-utils
```

2. Configurando inicio automático:

```
# echo "export HOME=/root/" >> /etc/rc.local 
# echo "xinit /root/.xinitrc" >> /etc/rc.local
```

3. Definindo aplicação a ser executada pelo X:

```
# echo "openbox-session" >> /root/.xinitrc
```

4. Definindo papel de parede para openbox:

```
# echo "feh --bg-scale /root/wallpaper.png &" >> /root/.config/openbox/autostart
```

O firefox pode ser iniciado automaticamente:

```
# echo "firefox &" >> /root/.config/openbox/autostart
```