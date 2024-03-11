## Run on deploy server
sudo su -i
apt clean all
apt update
apt upgrade -y
apt install python3-dev libffi-dev gcc libssl-dev python3-pip python3-virtualenv

timedatectl set-timezone "Asia/Tehran"
## Create virtual environment
python3 -m venv golinux
source golinux/bin/activate
pip install -U pip

pip install 'ansible<5.0'

pip install kolla-ansible
mkdir -p /etc/kolla
chown $USER:$USER /etc/kolla
cp -r /home/$USER/golinux/share/kolla-ansible/etc_examples/kolla/* /etc/kolla/
cp /home/$USER/golinux/share/kolla-ansible/ansible/inventory/* /etc/kolla/
mkdir /etc/ansible
# Copy ansible.cfg file to location
nano /etc/ansible/ansible.cfg
# Copy globals.yml file to location
nano /etc/kolla/globals.yml

kolla-genpwd
kolla-ansible install-deps
kolla-ansible -i /etc/kolla/multinode bootstrap-servers
kolla-ansible -i /etc/kolla/multinode prechecks
kolla-ansible -i /etc/kolla/multinode deploy

# Run if mariadb have problem or re-run deploy stage
kolla-ansible -i /etc/kolla/multinode mariadb_recovery

# Install openstack cli
pip install python-openstackclient
kolla-ansible post-deploy  /etc/kolla/admin-openrc.sh
source /etc/kolla/admin-openrc.sh
cd /home/user1/golinux/share/kolla-ansible
ls
./init-runonce
grep keystone_admin_password /etc/kolla/passwords.yml