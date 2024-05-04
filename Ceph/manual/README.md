### Use Vagrant
For use Vagrant to provide node VM, first need install below package.
```bash
apt install -y vagrant virtualbox
```
Next need to change directory to any project folder, for example `Ceph/manual` and then run command :
```bash
export VAGRANT_EXPERIMENTAL="disks"
vagrant up
```


