# Configurando um servidor de IRC

* Procedimentos para instalação e configuração de um servidor de IRC com o prosody
* Um servidor IRC permite que usuários troquem mensagem através de um programa cliente IRC

## Instalação e configuração

1. Instalação dos pacotes:

```
# apt-get install prosody
```

2. Acessar pasta de configurações:

```
# cd /etc/prosody/conf.avail/
```

3. Copiar arquivo de configuração:

``` 
# cp -a example.com.cfg.lua dominio.cfg.lua
```

4. Configurar dominio no arquivo: dominio.cfg.lua

```
VirtualHost "intranet.dominio.com.br"

        -- Assign this host a certificate for TLS, otherwise it would use the o$
        -- set in the global section (if any).
        -- Note that old-style SSL on port 5223 only supports one certificate, $
        -- use the global one.
        ssl = {
                key = "/etc/prosody/certs/dominio.key";
                certificate = "/etc/prosody/certs/dominio.crt";
                }
```

5. Criar uma chave RSA:

```
# openssl genrsa -out /etc/prosody/certs/domonio.key 2048
```

6. Criar um certificado com a chave criada:

```
# openssl req -new -x509 -key /etc/prosody/certs/domonio.key -out /etc/prosody/certs/dominio.cert -days 1095
```

7. Criar um link simbólico da configuração:

```
#ln -sf /etc/prosody/conf.avail/dominio.cfg.lua /etc/prosody/conf.d/dominio.cfg.lua
```

8. Reiniciar serviço do prosody:

```
# /etc/init.d/prosody restart
```

## Adicionando novos usuários

Para adicionar um novo usuario do servidor IRC basta executar o seguinte comando:

```
# prosodyctl adduser usuario@intranet.dominio.com.br
```
