#!/bin/bash
# Run on aio server
# Last modify 2024/03/10
# Version 1.1

## Change user to root
sudo sudo -i

## Add local repository dns record
echo 192.168.5.61 repo.sinacomsys.local >> /etc/hosts

## Change default apt repository to local repository
cp /etc/apt/sources.list /etc/apt/sources.list.org
sed -i "s|http://archive.ubuntu.com/ubuntu|http://repo.sinacomsys.local:9099/repository/apt-hosted/|g" /etc/apt/sources.list
sed -i "s|http://us.archive.ubuntu.com/ubuntu|http://repo.sinacomsys.local:9099/repository/apt-hosted/|g" /etc/apt/sources.list

## Update and install dependency
apt clean all
apt update
apt upgrade -y
apt dist-upgrade
apt install -y bash-completion git

# Add ssh key vm osa-deploy
mkdir -p ~/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7H8SltRUocXfZpA59x+jF3PUgJ0z9gnu4NMnJMJkLb/6vKlJ87vwQ0zwQGJMyITXcyOnmmSVoH748bAnwCIMCz6opF+9xBqYDhzR2mfSRKi1LCAQbs/oS7uQ0yoTu7ehxcyWFR7UpNXy2PTTxemqDAwTrT+rAonByPh/wjOWY8hDXBG1Fxh+8n4AzA1t5dZnHtMqgAGPOEcESrB/AIDLVsgjV/opM4znDC3LjWbBaIpOHsZO6vCRxqB5oRb25yjOPWoUTqjEUJRrnvFxyUf7hMfG9ywBlWjlm0UAXpCesqd+nL0BTdeK7UYNkysrNrnH4vjifxCXbUh3Xtf6rk85I5G3doqXBQUPVwBW68uxqCArZwIeVWhdLQ3MxKSQ3vdtoWnybpA+2VlwNEpZUlj3CuaV5rx9L0KfOZEDIUNTwiP4c2a7bwdsGjt8NDmEewdo8M5D/LHAT6OPC2HHTkLnLreX746dH2TIoDe2eSMTQ65RE51Z1qqZaLPCvqAqEo+8= root@sina-ProLiant-DL380-Gen10 >> ~/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDB5ORR0wgmbxJha63qz+yEo7W/lM4B42ReoIjkc9xRFiqxuT+vYWJVpZO0jmKh4hVxESACDKgiM818180BXXI7RkWgD+qG9BOFdpgAZLjvNCe3mGIcUsRuo0UTOtt5gz6rdmGKCPId+gAX2Gu+Vbo/oAQWpVg0XOW0Y7CiegGLk072HzE32Himw78xzHiHUf6wtJuz5VQsXJyo6ICYy6aqrBgyL1IxCTJt7CL4MdOBf1pkBGRHUH6EIz6V6w4T2aGMCvbYHECGKI8AFmm9MYIGWKx05xoO7iKp5FPcR6SI9kBAp0GeRTeSXteT2XFSrrPWl24IBatF6nZowfH14ugh6vmAv7t49ZUT6MxYBIHP0lakNjO6s9ZuLOeTnZe0cW8DVnpczY7OapPwH/bTcKUI6sgGF+j5RcbC5QB93ivld0gfW+L4bY/kgibrHuWL+JLJiFpcaNja5y9ADDbxUGgBM/tOjN49WojXB92ZoMzJYRvrOb9ty4zJJiq6IUbpJ88= ssinhar@ssinhar >> ~/.ssh/authorized_keys

## Set timezone
timedatectl set-timezone "Asia/Tehran"

## Clone project
git clone -b stable/2023.2 https://opendev.org/openstack/openstack-ansible /opt/openstack-ansible

## Change directory to the /opt/openstack-ansible
cd /opt/openstack-ansible/
scripts/bootstrap-ansible.sh

## Set BOOTSTRAP_OPTS
# multi-node configuration
export BOOTSTRAP_OPTS="bootstrap_host_aio_config=no"
export BOOTSTRAP_OPTS="bootstrap_host_data_disk_device=sdb"
export BOOTSTRAP_OPTS="bootstrap_host_scenarios_expanded=ovs"
export BOOTSTRAP_OPTS="bootstrap_host_scenarios_expanded=ceph"

## Scenario used to bootstrap the host
export SCENARIO='aio_lxc_keystone_glance_nova_horizon_lxb'
export SCENARIO='aio_metal_neutron_cinder_ceph'

## Define project installtion type
cd /opt/openstack-ansible/
scripts/bootstrap-aio.sh


## Override configuration file
cp -r /home/vagrant/openstack_user_config.yml /etc/openstack_deploy/openstack_user_config.yml
cp -r /home/vagrant/user_variables.yml /etc/openstack_deploy/user_variables.yml

## Create inventory file
cd /opt/openstack-ansible
inventory/dynamic_inventory.py --config /etc/openstack_deploy/

## Generate secret file
cd /opt/openstack-ansible
./scripts/pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml

## Run playbooks
cd /opt/openstack-ansible/playbooks
openstack-ansible setup-hosts.yml
openstack-ansible setup-infrastructure.yml
openstack-ansible setup-openstack.yml

## access to horizon
openstack security group create http --description 'Allow HTTP and HTTPS access'
openstack security group rule create http --protocol tcp --dst-port 80 --remote-ip 0.0.0.0/0
openstack security group rule create http --protocol tcp --dst-port 443 --remote-ip 0.0.0.0/0
openstack server add security group $SERVER http

## horizon password
grep keystone_auth_admin_password /etc/openstack_deploy/user_secrets.yml

## Reboot host
echo Reboot VM
init 6
