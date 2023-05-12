
terraform -chdir="../terraform_config/jenkins" apply --auto-approve
terraform -chdir="../terraform_config/sonar" apply --auto-approve
terraform -chdir="../terraform_config/nexus" apply --auto-approve
terraform -chdir="../terraform_config/master" apply --auto-approve
terraform -chdir="../terraform_config/node1" apply --auto-approve
