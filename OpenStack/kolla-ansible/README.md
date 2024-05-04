### Use Vagrant
For use Vagrant to provide deploy and node VM, first need install below package.
```bash
apt install -y vagrant virtualbox
```
Next need to change directory to any project folder, for example `OpenStack-Ansible/AIO/` and then run command :
```bash
export VAGRANT_EXPERIMENTAL="disks"
vagrant up
```

# Run if mariadb have problem or re-run deploy stage
kolla-ansible -i /etc/kolla/multinode mariadb_recovery

