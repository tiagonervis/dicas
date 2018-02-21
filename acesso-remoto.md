# Acesso remoto ao servidor X

1. Instalação do pacote Xnest:

```
# apt-get install xnest
```

2. Liberando acesso externo ao XDMCP:

```
# nano /etc/lightdm/lightdm.conf

[XDMCPServer]
enabled=true
port=177
```

3. Acessando servidor X de outro computador:

```
$ Xnest :1 -query <ip_do_computador> -geometry 1024x768
```
