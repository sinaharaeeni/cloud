#!/bin/bash
# Pre-config openstack node
# Last modify 2024/03/03
# Version 1.2

## Change user to root
sudo sudo -i

## Add local repository dns record
echo 192.168.5.61 repo.sinacomsys.local >> /etc/hosts

## Change default apt repository to local repository
cp /etc/apt/sources.list /etc/apt/sources.list.org
sed -i "s|http://archive.ubuntu.com/ubuntu|http://repo.sinacomsys.local:9099/repository/apt-hosted/|g" /etc/apt/sources.list
sed -i "s|http://us.archive.ubuntu.com/ubuntu|http://repo.sinacomsys.local:9099/repository/apt-hosted/|g" /etc/apt/sources.list

## Add other node address
echo 172.29.236.70 osa-deploy >> /etc/hosts
echo 172.29.236.71 osa-node-1 >> /etc/hosts
echo 172.29.236.72 osa-node-2 >> /etc/hosts
echo 172.29.236.73 osa-node-3 >> /etc/hosts

## Run on deploy server
apt clean all
apt update
apt upgrade -y
apt dist-upgrade -y
apt install -y bridge-utils debootstrap openssh-server tcpdump vlan python3 net-tools bash-completion
apt install -y linux-modules-extra-$(uname -r)
apt autoremove -y

# Add ssh key vm osa-deploy
mkdir -p ~/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1150ONGLxg5Ib8o2m2t6vP6SRN3Vfzd7Y6ohYCU3YrvdJ+hqqk/TpbHzI5/PxQ5IQwaECaJPTyblVfdd8GuOXwzP0VOnLTqAe+dWo78TD/AcO7G2EYEvkrH8Lt1oEyBXisiq+qvsUGrK71jJCWdGmNdS/VTXmeCjfZxhXuf2XawuxKaKspRqvAG+rn0VRQsJ76Rl7VYWeSU6jaznm0M/W5A6pgqlcxrWF4isy6czywELGKtIov/aPTl3pw77hafXMm1PDPAIfBtBCvRZs13N01e8ddfVnc8ng2omEuYHVKaOqiymks4J5w6yAIXAZE0FT+FCvbpF9+xcYg5DDiO0eaOa3k1xugfgwLJi/oMKKmpktaINxAE2E71kl+ZmycQmK7znA10dNAozTQaVM6ZZ9McwIC3yumbZNqfbEensGS3H+nQ+ZiU4kjqKKqKa4h/IqOTM6asYVPIXApeAUdJllicKF5scy4OrmnKI4YZ3tJdiCMu0aFYVnQzvSOh3PmR0= root@osa-deploy >> ~/.ssh/authorized_keys

# Set timezone to Asia/Tehran
timedatectl set-timezone "Asia/Tehran"

# Create LVM group
pvcreate --metadatasize 2048 /dev/sdb
vgcreate cinder-volumes /dev/sdb

# Reboot VM
init 6
