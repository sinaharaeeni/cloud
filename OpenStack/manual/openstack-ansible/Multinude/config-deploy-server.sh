#!/bin/bash
# Run on deploy server
# Last modify 2024/03/03
# Version 1.2

## Update and install dependency
sudo sudo -i
apt clean all
apt update
apt upgrade -y
apt dist-upgrade
apt install -y build-essential git chrony openssh-server python3-dev sudo vagrant virtualbox bash-completion

## Reboot host after update
init 6

## Set timezone
timedatectl set-timezone "Asia/Tehran"

## Clone project
git clone -b 28.0.0 https://opendev.org/openstack/openstack-ansible /opt/openstack-ansible

## Change directory to the /opt/openstack-ansible
cd /opt/openstack-ansible
scripts/bootstrap-ansible.sh

## Copy environment configuration
cp -r /opt/openstack-ansible/etc/openstack_deploy /etc/openstack_deploy

## Config and run Vagrant
export VAGRANT_EXPERIMENTAL="disks"
vagrant up

## Override configuration file
cp -r openstack_user_config.yml /etc/openstack_deploy/openstack_user_config.yml
cp -r user_variables.yml /etc/openstack_deploy/user_variables.yml

## Create inventory file
cd /opt/openstack-ansible
inventory/dynamic_inventory.py --config /etc/openstack_deploy/

## Generate secret file
cd /opt/openstack-ansible
./scripts/pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml

## Generate a Ceph cluster fsid
# Put output in file user_variables.yml as a fsid
# Maybe can run this part automatically
python3 -c 'import uuid; print(str(uuid.uuid4()))'

## Run playbooks
cd /opt/openstack-ansible/playbooks
openstack-ansible setup-everything.yml

## Verify the database cluster
ansible galera_container -m shell -a "mysql -h localhost -e 'show status like \"%wsrep_cluster_%\";'"

## Export horizon password
grep keystone_auth_admin_password /etc/openstack_deploy/user_secrets.yml
