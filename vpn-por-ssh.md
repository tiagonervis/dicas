# Configuração de VPN por SSH usando NetworkManager

1. Baixar pacote do network-manager para vpn via ssh:

```
# apt-get install network-manager-ssh
```

2. No servidor permitir tunel via ssh editando /etc/ssh/sshd_config:

```
PermitTunnel yes
```

3. Ainda no servidor editar /etc/network/interfaces:

```
post-up echo 1 > /proc/sys/net/ipv4/ip_forward
post-up iptables -t nat -A POSTROUTING -o enp0s7 -j MASQUERADE
```

A configuração do tunel pode ser feita diretamente pelo NetworkManager, o parametro Gateway é o IP do servidor ssh.
Para conexão na rede local utilizar a opção TAP service.
