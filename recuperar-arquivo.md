# Recuperar arquivos texto

Para recuperar um arquivo texto sabendo parte do seu conteudo:

```
$sudo grep -i -a -B100 -A100 'texto' /dev/sda1 > file.txt
```
O parametro B especifica quantas linhas ANTES da correspondencia devem ser inseridas no arquivo.
O parametro A especifica quantas linhas DEPOIS da correspondencia devem ser inseridas no arquivo.
