# Test network bandwidth

## For test bandwidth beetwen to server can use `iperf3`.

### Local usage
**Pre-config**
- Install package with ` apt install -y iperf3 `
- Allow iptables with ` iptables -A INPUT -p tcp --dport 7575 -j ACCEPT `

**Server**
Command `iperf3 -s -p 7575`

**Client**
Command `iperf3 -c <ip-server> -p 7575`

### Use for test internet speed
Command `iperf3 -c iperf3.moji.fr -p 5205`