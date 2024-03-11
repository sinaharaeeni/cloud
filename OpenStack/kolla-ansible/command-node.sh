## Run on deploy server
sudo su -i
apt clean all
apt update
apt upgrade -y
apt install python3 ntp

# Add ssh-key CE-DH-08
mkdir -p ~/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnzXW9WB3jbAmc4OiV2HiXXst5vgxWBX8+faaBvqrdmKO4qTk3uu3PukyN2P9nRM72GZR2pTa0fX66i0PMiKCNqFwjX4DksU1KJr6/kVzAdIWSiFI/q+u7W5BoyYV6DVLgMIYz75M84bfz53hDQYWyXsRzfzh+PAruugBwBpsdLKwCfE1SEoB6pOllegTO0aeHr/Dzd0DoTeB4Ianv6Cp45ZJi2K6cbeslLIGRtrlKEniTQspWFcmcODrqLVgkwm2/MNaPdXuuVL2oMzt3Z0XUARMRXlItu2I3A3Hmk19PG7fvqj2XXkpDuhxaOd24Ad1M3uefRUHUyO1CCQJrUV0mpXmg/p6u7X/FgKmLRmUnWfkMdg8aK/l6QvrGSIHBIIx8/TZOC553xQGCUCm367+k8w3lHuVK/8dP1iaHgAVW05IAuWDsLhLFW+NRx4cbKy7a8wCQEiGbipq6XGHOaMSZpJHYuLC7FAfXrnKmdYYQ8TdULxNp1RBcX51yHIJRZTU= root@CE-DH-08 >> ~/.ssh/authorized_keys

# Set timezone
timedatectl set-timezone "Asia/Tehran"

# Create LVM group
pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb
