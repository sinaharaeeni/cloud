# To do list after download zabbix appliance to get ready

## Steps for get ready

* Update and install package

```bash 
yum clean all
yum update -y
yum install -y open-vm-tools \
nano \
net-tools \
chrony \
net-snmp \
net-snmp-utils \
bash-completion \
yum-utils \
traceroute \
telnet
```

* Start and enable vmtools service
```bash
systemctl start vmtoolsd.service
systemctl enable vmtoolsd.service
```

* Edit ssh config
```bash
nano /etc/ssh/sshd_config
```

* Restart service sshd
```bash
systemctl restart sshd
```

* Set hostname
```bash
hostnamectl set-hostname zabbix-server
```

* Set time zone
```bash 
timedatectl set-timezone "Asia/Tehran"
```

* Extend hard disk
```bash
fdisk -l
parted /dev/sda

## run below command in parted
	print free
	resizepart 5 100%

xfs_growfs /dev/sda5
fdisk -l
```

# make static ip
```bash
nano /etc/sysconfig/network-scripts/ifcfg-eth0
```

	DEVICE="eth0"
	BOOTPROTO=static
	NM_CONTROLLED="no"
	PERSISTENT_DHCLIENT=1
	ONBOOT="yes"
	TYPE=Ethernet
	DEFROUTE=yes
	PEERDNS=yes
	PEERROUTES=yes
	IPV4_FAILURE_FATAL=yes
	NAME="eth0"
	IPADDR=192.168.78.132
	NETMASK=255.255.255.0
	GATEWAY0=192.168.78.2
	DNS1=1.1.1.1

```
systemctl restart network.service
```


# Set ntp server
```bash
nano /etc/chrony.conf
systemctl restart chronyd.service
```

# Check snmp access
```bash
snmpwalk -v 2c -c sinacomsys 192.168.100.11
```

# Show zabbix-server logs
```bash
tail -f /var/log/zabbix/zabbix_server.log
```

# Add ssh key
```bash
mkdir -p .ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVUrJyZ2gaXan7KgSkdIhAg5CNOlgBiPTZuc3UmrwiRaNav3OS0PiRQbyiuD5EUvZ2Ok3XzsVU8N9uponLdx6yh6IXx/RrU8rjazs+h9/BIGIwrbJBhXO7AcHnw0m0qhepeD+od6TzBKl$" >> .ssh/authorized_keys
```
