## Configurando arquivo de swap

```
# fallocate -l 1G /swapfile
# chmod 600 /swapfile
# mkswap /swapfile
# swapon /swapfile
# echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
```
