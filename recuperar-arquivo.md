# Recuperar arquivos texto

Para recuperar um arquivo texto sabendo parte do seu conteudo:

```
$sudo grep -i -a -B100 -A100 'texto' /dev/sda1 > file.txt
```

Os parametros A e B especificam o número de linhas gravadas antes e depois da correspondencia.
