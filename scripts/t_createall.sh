
echo -e "\n\033[1;32mProvisioning Jenkins server\033[0m\n"
terraform -chdir="../terraform_config/jenkins" apply --auto-approve
echo -e "\n\033[1;32mProvisioning SonarQube server\033[0m\n"
terraform -chdir="../terraform_config/sonar" apply --auto-approve
echo -e "\n\033[1;32mProvisioning Nexus server\033[0m\n"
terraform -chdir="../terraform_config/nexus" apply --auto-approve
echo -e "\n\033[1;32mProvisioning kubernetes control plane node - \033[1;34mk8smaster\033[0m\n"
terraform -chdir="../terraform_config/master" apply --auto-approve
echo -e "\n\033[1;32mProvisioning kubernetes worker node - \033[1;34mk8snode1\033[0m\n"
terraform -chdir="../terraform_config/node1" apply --auto-approve
echo -e "\n\033[1;32mProvisioned the infrastructure required for the JAVA web application CICD project.\033[0m\n"
