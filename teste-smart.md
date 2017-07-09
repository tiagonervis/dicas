# Teste SMART de discos

### Instalação 

Instalação da ferramenta de testes no modo texto sem adicionais:

```
# apt-get install smartmontools --no-install-recommends
```

### Utilização

1. Verificar o status

```
# smartctl -H /dev/sdX
```

2. Iniciar um teste rápido

```
# smartctl --test=short /dev/sdX
```

3. Verificar o progresso do teste

```
# smartctl -a /dev/sdX
```