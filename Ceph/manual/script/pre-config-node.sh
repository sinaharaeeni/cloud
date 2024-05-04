#!/bin/bash
# Pre-config ceph node
# Last modify 2024/03/16
# Version 1.0

## Change user to root
sudo sudo -i

## Add local repository dns record
echo 192.168.5.61 repo.sinacomsys.local >> /etc/hosts
echo 192.168.8.41 ceph-node-1 >> /etc/hosts
echo 192.168.8.42 ceph-node-2 >> /etc/hosts
echo 192.168.8.43 ceph-node-3 >> /etc/hosts

## Change default apt repository to local repository
cp /etc/apt/sources.list /etc/apt/sources.list.org
sed -i "s|http://us.archive.ubuntu.com/ubuntu|http://repo.sinacomsys.local:9099/repository/apt-hosted/|g" /etc/apt/sources.list

## Move netplan config file
mv /home/vagrant/02-static.yaml /etc/netplan/02-static.yaml

## Run on deploy server
apt clean all
apt update
apt upgrade -y
apt dist-upgrade -y
apt install -y python3 tcpdump net-tools bash-completion chrony ncdu ceph cephadm
apt install -y linux-modules-extra-$(uname -r)
apt autoremove -y

# Add ssh key vm ceph-deploy
mkdir -p ~/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7H8SltRUocXfZpA59x+jF3PUgJ0z9gnu4NMnJMJkLb/6vKlJ87vwQ0zwQGJMyITXcyOnmmSVoH748bAnwCIMCz6opF+9xBqYDhzR2mfSRKi1LCAQbs/oS7uQ0yoTu7ehxcyWFR7UpNXy2PTTxemqDAwTrT+rAonByPh/wjOWY8hDXBG1Fxh+8n4AzA1t5dZnHtMqgAGPOEcESrB/AIDLVsgjV/opM4znDC3LjWbBaIpOHsZO6vCRxqB5oRb25yjOPWoUTqjEUJRrnvFxyUf7hMfG9ywBlWjlm0UAXpCesqd+nL0BTdeK7UYNkysrNrnH4vjifxCXbUh3Xtf6rk85I5G3doqXBQUPVwBW68uxqCArZwIeVWhdLQ3MxKSQ3vdtoWnybpA+2VlwNEpZUlj3CuaV5rx9L0KfOZEDIUNTwiP4c2a7bwdsGjt8NDmEewdo8M5D/LHAT6OPC2HHTkLnLreX746dH2TIoDe2eSMTQ65RE51Z1qqZaLPCvqAqEo+8= root@sina-ProLiant-DL380-Gen10 >> ~/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDB5ORR0wgmbxJha63qz+yEo7W/lM4B42ReoIjkc9xRFiqxuT+vYWJVpZO0jmKh4hVxESACDKgiM818180BXXI7RkWgD+qG9BOFdpgAZLjvNCe3mGIcUsRuo0UTOtt5gz6rdmGKCPId+gAX2Gu+Vbo/oAQWpVg0XOW0Y7CiegGLk072HzE32Himw78xzHiHUf6wtJuz5VQsXJyo6ICYy6aqrBgyL1IxCTJt7CL4MdOBf1pkBGRHUH6EIz6V6w4T2aGMCvbYHECGKI8AFmm9MYIGWKx05xoO7iKp5FPcR6SI9kBAp0GeRTeSXteT2XFSrrPWl24IBatF6nZowfH14ugh6vmAv7t49ZUT6MxYBIHP0lakNjO6s9ZuLOeTnZe0cW8DVnpczY7OapPwH/bTcKUI6sgGF+j5RcbC5QB93ivld0gfW+L4bY/kgibrHuWL+JLJiFpcaNja5y9ADDbxUGgBM/tOjN49WojXB92ZoMzJYRvrOb9ty4zJJiq6IUbpJ88= ssinhar@ssinhar >> ~/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnzXW9WB3jbAmc4OiV2HiXXst5vgxWBX8+faaBvqrdmKO4qTk3uu3PukyN2P9nRM72GZR2pTa0fX66i0PMiKCNqFwjX4DksU1KJr6/kVzAdIWSiFI/q+u7W5BoyYV6DVLgMIYz75M84bfz53hDQYWyXsRzfzh+PAruugBwBpsdLKwCfE1SEoB6pOllegTO0aeHr/Dzd0DoTeB4Ianv6Cp45ZJi2K6cbeslLIGRtrlKEniTQspWFcmcODrqLVgkwm2/MNaPdXuuVL2oMzt3Z0XUARMRXlItu2I3A3Hmk19PG7fvqj2XXkpDuhxaOd24Ad1M3uefRUHUyO1CCQJrUV0mpXmg/p6u7X/FgKmLRmUnWfkMdg8aK/l6QvrGSIHBIIx8/TZOC553xQGCUCm367+k8w3lHuVK/8dP1iaHgAVW05IAuWDsLhLFW+NRx4cbKy7a8wCQEiGbipq6XGHOaMSZpJHYuLC7FAfXrnKmdYYQ8TdULxNp1RBcX51yHIJRZTU= root@CE-DH-08 >> ~/.ssh/authorized_keys

# Set timezone to Asia/Tehran
timedatectl set-timezone "Asia/Tehran"

## Config netplan
rm /etc/netplan/50-vagrant.yaml
netplan apply

## Reboot host
echo Reboot VM
init 6
