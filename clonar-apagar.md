# Operações com discos e unidades

## Clonar um disco ou arquivo

* Clonar um partição:

```
dcfldd if=/dev/hdc1 of=/dev/sda1 bs=4096 conv=noerror
```

* Clonar MBR + tabela de partições:

```
dd if=/dev/hda of=/dev/hdb bs=512 count=1
```

* Clonar apenas MBR:

```
dd if=/dev/hda of=/dev/hdb bs=446 count=1
```


## Apagar um disco ou unidade

Digite o comando abaixo como root para destruir todos os dados da unidade:

```
# shred -n 2 -z -v /dev/sdX

```