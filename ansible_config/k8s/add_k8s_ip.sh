### This script replaces the dummy values present in the master.sh and node.sh scripts with the private ips of the k8s-master and k8s-node1 servers.
### This will work first time on it's own after that if you need to recreate instances and change their ips then first run replace_k8s_ip.sh and then run this script.
#!/bin/bash

mip=`grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' master.sh | head -n 1`
nip=`grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' master.sh | tail -n 1`

if df | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' master.sh;
then
{
echo "Previously used IPs found"
#echo "Replaced previously used IPs of k8s-master and k8s-node1 with dummy variables kmaster-ip & knode1-ip in master.sh and nodes.sh scripts"
sed -i "s/$mip/kmaster-ip/g" master.sh
sed -i "s/$nip/knode1-ip/g" master.sh
sed -i "s/$mip/kmaster-ip/g" nodes.sh
sed -i "s/$nip/knode1-ip/g" nodes.sh
}
else echo "Dummy variables already present";
fi

echo "Adding IPs of k8s-master and k8s-node1 to the master.sh and nodes.sh scripts"
master_private_ip=`terraform -chdir="../../terraform_config/master" output | grep private_ip |awk '{print $3}' | tr -d '"'`
node1_private_ip=`terraform -chdir="../../terraform_config/node1" output | grep private_ip |awk '{print $3}' | tr -d '"'`

sed -i "s/kmaster-ip/$master_private_ip/g" master.sh
sed -i "s/knode1-ip/$node1_private_ip/g" master.sh
sed -i "s/kmaster-ip/$master_private_ip/g" nodes.sh
sed -i "s/knode1-ip/$node1_private_ip/g" nodes.sh

