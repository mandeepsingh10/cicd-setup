#!/bin/bash
#### Store public IP addresses of the AWS EC2 instances ####
jenkins_public_ip=`terraform -chdir="../terraform_config/jenkins" output | grep public_ip |awk '{print $3}' | tr -d '"'`
sonar_public_ip=`terraform -chdir="../terraform_config/sonar" output | grep public_ip |awk '{print $3}' | tr -d '"'`
nexus_public_ip=`terraform -chdir="../terraform_config/nexus" output | grep public_ip |awk '{print $3}' | tr -d '"'`
master_public_ip=`terraform -chdir="../terraform_config/master" output | grep public_ip |awk '{print $3}' | tr -d '"'`
node1_public_ip=`terraform -chdir="../terraform_config/node1" output | grep public_ip |awk '{print $3}' | tr -d '"'`

echo -e "\n\033[1mThe following details can be used to access the resources.\033[0m\n"
echo -e "\033[1mJenkins: \033[1;34mhttp://$jenkins_public_ip:8080\033[0m\n"
echo -e "\033[1mSonarQube: \033[1;34mhttp://$sonar_public_ip:9000\033[0m\n"
echo -e "\033[1mNexus Repository Manager: \033[1;34mhttp://$nexus_public_ip:8081\033[0m\n"
echo -e "\033[1mKubernetes Cluster control plane (k8s-master): \033[1;34m$master_public_ip\033[0m\n"
echo -e "\033[1mKubernetes Worker node (k8s-node1): \033[1;34m$node1_public_ip\033[0m\n"

