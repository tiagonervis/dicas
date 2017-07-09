# Criptografar um disco

### Instalação

1. Instalação dos pacotes necessários:

```
# apt-get install cryptsetup
```

2. Ativar modulos do kernel:

```
# modprobe dm_crypt
```

### Configuração

1. Criar uma partição criptografada:

```
# cryptsetup -y luksFormat /dev/sdX1
```

2. Abrir a partição criptografada:

```
# cryptsetup luksOpen /dev/sdX1 crypt1
```
3. Formatar a partição:

```
# mkfs.ext4 /dev/mapper/crypt1 
```

4. Montar a partição criptografada:

```
# mount /dev/mapper/crypt1 /mnt4
```

### Montagem automática

1. Criar um arquivo aleatório:

```
# dd if=/dev/random of=/etc/keys.luks bs=4k count=1
````

2. Adicionar o arquivo aleatório como chave da partição:

```
# cryptsetup luksAddKey /dev/sdX1 /etc/keys.luks
```

3. Adicionar no arquivo /etc/crypttab:

```
crypt1 /dev/sdX1 /etc/keys.luks luks
````

4. Adicionar no arquivo /etc/fstab:

```
/dev/mapper/crypt1 /protegido ext4 defaults 0 0
```

