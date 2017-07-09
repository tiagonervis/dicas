# Configurar monitor OSD

Procedimento para instalar o utilitário que permite configurar as opções internas dos monitores como brilho, contraste, etc.

* O monitor deve estar ligado diretamente pela porta VGA.

1. Instalação dos pacotes necessários:

```
# apt-get install gddccontrol
```

2. Habilitar modulo do kernel:

```
# modprobe i2c-dev
```

3. Executar ferramenta de configuração:

```
# gddccontrol
```
