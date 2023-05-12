### This script replaces the existing ip address of the k8s-master and k8s-node1 with the dummy values which are required for the add_k8s_ip.sh script.
#!/bin/bash

mip=`grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' master.sh | head -n 1` 
nip=`grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' master.sh | tail -n 1`

if df | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' master.sh;
then 
{
echo "Previously used IPs found"
echo "Replacing previously used IPs of k8s-master and k8s-node1 with dummy variables kmaster-ip & knode1-ip in master.sh and nodes.sh scripts"
sed -i "s/$mip/kmaster-ip/g" master.sh
sed -i "s/$nip/knode1-ip/g" master.sh
sed -i "s/$mip/kmaster-ip/g" nodes.sh
sed -i "s/$nip/knode1-ip/g" nodes.sh
}
else echo "Dummy variables already present";
fi
