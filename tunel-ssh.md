# Conexão SSH via tunel

Permite a conexão a um host que está em uma rede bloqueada usando a tecnica de tunelamento reverso

1. Abrindo conexão na local através de uma maquina externa:

```
# ssh usuario@endereco-ip-remoto -p 22 -R 7000:localhost:22
```

2. Acessando da maquina remota:

```
# ssh usuario@localhost -p 7000
```
