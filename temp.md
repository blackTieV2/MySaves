# VLAN Configuration (Netplan)

Once Port-channel2 is up on the switch and LACP is confirmed, configure Netplan to create the bond and VLAN subinterfaces:

1. Backup existing config:
   ```bash
   sudo cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak
   ```
2. Edit `/etc/netplan/50-cloud-init.yaml` to the following:
   ```yaml
   network:
     version: 2
     renderer: networkd

     ethernets:
       eno1:
         dhcp4: true
       eno2:
         dhcp4: true
       eno3:
         dhcp4: true
       eno4:
         dhcp4: true
       enp131s0f0:
         dhcp4: false
       enp131s0f1:
         dhcp4: false

     bonds:
       bond0:
         interfaces:
           - enp131s0f0
           - enp131s0f1
         parameters:
           mode: 802.3ad
           lacp-rate: fast
         dhcp4: false

     vlans:
       bond0.10:
         id: 10
         link: bond0
         dhcp4: true
       bond0.20:
         id: 20
         link: bond0
         dhcp4: true
       bond0.30:
         id: 30
         link: bond0
         dhcp4: true
       bond0.40:
         id: 40
         link: bond0
         dhcp4: true
       bond0.50:
         id: 50
         link: bond0
         dhcp4: true
   ```
3. Apply the new configuration:
   ```bash
   sudo netplan apply
   ```
4. Verify the bond and VLAN interfaces:
   ```bash
   ip -d link show bond0
   ip -d link show bond0.10
   ip -d link show bond0.20
   # etc.
   ```
5. Check IP addresses on each VLAN:
   ```bash
   ip addr show bond0.10
   ip addr show bond0.20
   # etc.
   ```

This will ensure your Ubuntu host trunk matches the Cisco switch’s Port-channel2 and each VLAN interface receives DHCP from the corresponding scope.

## 6. Configure DHCP on the C3850

Because you want the switch to serve DHCP for all VLANs, configure each pool directly on the C3850:

1. Enter global configuration:
   ```
   configure terminal
   ```
2. Define DHCP pool for VLAN 10 (Trusted):
   ```
   ip dhcp pool TRUSTED
     network 192.168.10.0 255.255.255.0
     default-router 192.168.10.1
     dns-server 192.168.50.51
     domain-name trusted.local
   exit
   ```
3. Define DHCP pool for VLAN 20 (Guest):
   ```
   ip dhcp pool GUEST
     network 192.168.20.0 255.255.255.0
     default-router 192.168.20.1
     dns-server 192.168.50.51
     domain-name guest.local
   exit
   ```
4. Define DHCP pool for VLAN 30 (IoT):
   ```
   ip dhcp pool IOT
     network 192.168.30.0 255.255.255.0
     default-router 192.168.30.1
     dns-server 192.168.50.51
     domain-name iot.local
   exit
   ```
5. Define DHCP pool for VLAN 40 (Lab):
   ```
   ip dhcp pool LAB
     network 192.168.40.0 255.255.255.0
     default-router 192.168.40.1
     dns-server 192.168.50.51
     domain-name lab.local
   exit
   ```
6. Define DHCP pool for VLAN 50 (Mgmt):
   ```
   ip dhcp pool MGMT
     network 192.168.50.0 255.255.255.0
     default-router 192.168.50.1
     dns-server 192.168.50.51
     domain-name mgmt.local
   exit
   ```
7. Exclude static addresses if needed (e.g., switch SVI IPs):
   ```
   ip dhcp excluded-address 192.168.10.1
   ip dhcp excluded-address 192.168.20.1
   # etc.
   ```
8. Verify DHCP pools:
   ```
   show ip dhcp pool
   show ip dhcp binding
   ```
9. Save configuration:
   ```
   end
   write memory
   ```

Now your C3850 will hand out IPv4 addresses to each VLAN, and the Ubuntu host bond0.<vlan> interfaces will receive leases accordingly.
