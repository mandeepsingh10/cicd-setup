terraform -chdir="../terraform_config/jenkins" destroy --auto-approve
terraform -chdir="../terraform_config/sonar" destroy --auto-approve
terraform -chdir="../terraform_config/nexus" destroy --auto-approve
terraform -chdir="../terraform_config/master" destroy --auto-approve
terraform -chdir="../terraform_config/node1" destroy --auto-approve
