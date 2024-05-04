#!/bin/bash
# Pre-config openstack deploy
# Last modify 2024/03/12
# Version 1.1

## Change user to root
sudo sudo -i

## Add local repository dns record
echo 192.168.5.61 repo.sinacomsys.local >> /etc/hosts
echo 192.168.9.71 ka-node-1 >> /etc/hosts
echo 192.168.9.72 ka-node-2 >> /etc/hosts
echo 192.168.9.73 ka-node-3 >> /etc/hosts

## Change default apt repository to local repository
cp /etc/apt/sources.list /etc/apt/sources.list.org
sed -i "s|http://us.archive.ubuntu.com/ubuntu|http://repo.sinacomsys.local:9099/repository/apt-hosted/|g" /etc/apt/sources.list

## Run on deploy server
apt clean all
apt update
apt upgrade -y
apt dist-upgrade -y
apt install -y python3-dev libffi-dev gcc libssl-dev python3-pip python3-virtualenv net-tools bash-completion python3-venv
apt install -y linux-modules-extra-$(uname -r)
apt autoremove -y

## Add ssh key vm ka-deploy
mkdir -p ~/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7H8SltRUocXfZpA59x+jF3PUgJ0z9gnu4NMnJMJkLb/6vKlJ87vwQ0zwQGJMyITXcyOnmmSVoH748bAnwCIMCz6opF+9xBqYDhzR2mfSRKi1LCAQbs/oS7uQ0yoTu7ehxcyWFR7UpNXy2PTTxemqDAwTrT+rAonByPh/wjOWY8hDXBG1Fxh+8n4AzA1t5dZnHtMqgAGPOEcESrB/AIDLVsgjV/opM4znDC3LjWbBaIpOHsZO6vCRxqB5oRb25yjOPWoUTqjEUJRrnvFxyUf7hMfG9ywBlWjlm0UAXpCesqd+nL0BTdeK7UYNkysrNrnH4vjifxCXbUh3Xtf6rk85I5G3doqXBQUPVwBW68uxqCArZwIeVWhdLQ3MxKSQ3vdtoWnybpA+2VlwNEpZUlj3CuaV5rx9L0KfOZEDIUNTwiP4c2a7bwdsGjt8NDmEewdo8M5D/LHAT6OPC2HHTkLnLreX746dH2TIoDe2eSMTQ65RE51Z1qqZaLPCvqAqEo+8= root@sina-ProLiant-DL380-Gen10 >> ~/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDB5ORR0wgmbxJha63qz+yEo7W/lM4B42ReoIjkc9xRFiqxuT+vYWJVpZO0jmKh4hVxESACDKgiM818180BXXI7RkWgD+qG9BOFdpgAZLjvNCe3mGIcUsRuo0UTOtt5gz6rdmGKCPId+gAX2Gu+Vbo/oAQWpVg0XOW0Y7CiegGLk072HzE32Himw78xzHiHUf6wtJuz5VQsXJyo6ICYy6aqrBgyL1IxCTJt7CL4MdOBf1pkBGRHUH6EIz6V6w4T2aGMCvbYHECGKI8AFmm9MYIGWKx05xoO7iKp5FPcR6SI9kBAp0GeRTeSXteT2XFSrrPWl24IBatF6nZowfH14ugh6vmAv7t49ZUT6MxYBIHP0lakNjO6s9ZuLOeTnZe0cW8DVnpczY7OapPwH/bTcKUI6sgGF+j5RcbC5QB93ivld0gfW+L4bY/kgibrHuWL+JLJiFpcaNja5y9ADDbxUGgBM/tOjN49WojXB92ZoMzJYRvrOb9ty4zJJiq6IUbpJ88= ssinhar@ssinhar >> ~/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnzXW9WB3jbAmc4OiV2HiXXst5vgxWBX8+faaBvqrdmKO4qTk3uu3PukyN2P9nRM72GZR2pTa0fX66i0PMiKCNqFwjX4DksU1KJr6/kVzAdIWSiFI/q+u7W5BoyYV6DVLgMIYz75M84bfz53hDQYWyXsRzfzh+PAruugBwBpsdLKwCfE1SEoB6pOllegTO0aeHr/Dzd0DoTeB4Ianv6Cp45ZJi2K6cbeslLIGRtrlKEniTQspWFcmcODrqLVgkwm2/MNaPdXuuVL2oMzt3Z0XUARMRXlItu2I3A3Hmk19PG7fvqj2XXkpDuhxaOd24Ad1M3uefRUHUyO1CCQJrUV0mpXmg/p6u7X/FgKmLRmUnWfkMdg8aK/l6QvrGSIHBIIx8/TZOC553xQGCUCm367+k8w3lHuVK/8dP1iaHgAVW05IAuWDsLhLFW+NRx4cbKy7a8wCQEiGbipq6XGHOaMSZpJHYuLC7FAfXrnKmdYYQ8TdULxNp1RBcX51yHIJRZTU= root@CE-DH-08 >> ~/.ssh/authorized_keys

## Set timezone to Asia/Tehran
timedatectl set-timezone "Asia/Tehran"

## Add private key
mv /home/vagrant/id_rsa.ppk ~/.ssh/id_rsa

## Copy ansible.cfg file to location
mkdir -p /etc/ansible/
mv /home/vagrant/ansible.cfg /etc/ansible/ansible.cfg

## Create virtual environment
python3 -m venv golinux
source golinux/bin/activate
pip install -U pip

## install ansible
pip install 'ansible-core>=2.14,<2.16'

## Config kolla-ansible
pip install kolla-ansible
mkdir -p /etc/kolla

## Copy globals.yml file to location
mv /home/vagrant/globals.yml /etc/kolla/globals.yml
mv /home/vagrant/multinode /etc/kolla/multinode
mv /home/vagrant/passwords.yml /etc/kolla/passwords.yml

## Install Ansible Galaxy requirements
kolla-ansible install-deps

## deployment phase
kolla-ansible -i /etc/kolla/multinode bootstrap-servers
kolla-ansible -i /etc/kolla/multinode prechecks
kolla-ansible -i /etc/kolla/multinode pull
kolla-ansible -i /etc/kolla/multinode deploy

# Install openstack cli
pip install python-openstackclient
kolla-ansible post-deploy  /etc/kolla/admin-openrc.sh
source /etc/kolla/admin-openrc.sh
cd /root/golinux/share/kolla-ansible
./init-runonce
cat /etc/kolla/passwords.yml | grep keystone_admin_password

## Reboot host
echo Reboot VM
init 6
