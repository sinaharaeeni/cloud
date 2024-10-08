# Linux Tips

## NFS mount point

**For attach nfs share, do below steps**

- Install package with `apt install nfs-common`
- Create directory `mkdir /home/sina/nfs-share/`
- Add mount point in `nano /etc/fstab`
- Enter with under template

```config
<file system>   <dir>   <type>  <options>   <dump>  <pass>
nfs.sinacomsys.local:/nfs-share/    /home/sina/nfs-share/   nfs defaults    0   0
```

## Allow port in iptables

- Allow port 2223 `iptables -A INPUT -p tcp --dport 2223 -j ACCEPT`
- Allow port 2223 `iptables --append INPUT --source 192.168.1.0/24 --protocol tcp --dport 2223 --jump ACCEPT`
- Save iptables rule `iptables-save > iptables.rules`

## Check log with journalctl

- Check log sshd `journalctl -u sshd --since yesterday`

## Test write speed disk

- Create one big file `dd if=/dev/zero of=testfile bs=1G count=1 oflag=dsync && rm testfile`
- Create a lot small file `dd if=/dev/zero of=testfile bs=100k count=10000 oflag=dsync && rm testfile`
- Create one big file, bypasses the kernel's page cache (memory cache), writing directly to the storage. `dd if=/dev/zero of=testfile bs=1G count=1 oflag=direct && rm testfile`
- Create a lot file, bypasses the kernel's page cache (memory cache), writing directly to the storage. `dd if=/dev/zero of=testfile bs=100k count=10000 oflag=direct && rm testfile`
