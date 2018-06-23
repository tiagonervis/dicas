# Comandos úteis

### Executar uma tarefa em segundo plano

```
$ nohup (tarefa ou comando) &
```

### Consultar resolução do DNS

```
$ dig www.google.com +trace
```

### Executar programas gráficos via SSH

```
$ ssh (ip do servidor) -u (usuario) -XC
```

### Cria um arquivo 7z protegido por senha

```
$ 7z a -p -m0=Copy out.7z /diretorio/para/adicionar
```

### Exibir placas de rede detectadas

```
$ cat /proc/net/dev
```

### Monitorar uso CPU, memoria

```
# apt-get install htop
$ htop
```

### Monitorar trafego da rede

```
# apt-get install bmon
$ bmon
```
