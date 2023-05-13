# cicd-setup
This repository hosts all the configuration files required for the CICD Project 'java-webapp-cicd'
## Overview

This project aims to build an advanced end-to-end DevOps pipeline for a Java web application.  
Our project is divided into two main parts:

1. The initial phase involves the installation and configuration of various tools and servers.
    
2. In the second phase, we will create an advanced end-to-end Jenkins pipeline with multiple stages.
    

## Tools used

1. AWS
    
2. Git
    
3. Gradle
    
4. Ansible
    
5. Terraform
    
6. Jenkins
    
7. SonarQube
    
8. SonaType Nexus Repository Manager
    
9. Kubernetes (kubeadm k8s cluster)
    
10. Helm
    
11. datree.io
    
12. Slack
    

## Prerequisites

1. AWS account
    
2. Terraform and Ansible should be installed and configured on your local computer
    

## **Phase I: Installation and configuration**

* We have used terraform config files to provision AWS resources and ansible playbooks to configure the instances as per our requirement, so you should know how to write terraform config files and ansible playbooks for understanding this phase of the project clearly. If you want to test the project then you can just clone the repo and run the commands which will automatically set up the required AWS resources.
    
* We need five servers to set up our CICD pipeline infrastructure. We have used **Ubuntu** as the base operating system for all our servers.
    
    1. Jenkins Server - `jenkins`
        
        * This will host our jenkins application to implement our CI/CD pipelines.
            
    2. SonarQube Server - `sonar`
        
        * This server will host the SonarQube application. It is used for continuous inspection of code quality to perform automatic reviews with static analysis of code to detect bugs and code smells.
            
    3. Nexus Repository server - `nexus`
        
        * Sonatype **Nexus Repository** Manager provides a central platform for storing build artifacts. This server will host our two private repositories one for storing docker images and another for storing helm charts.
            
    4. Kubernetes control plane node - `k8s-master`
        
        * This server will act as the control plane node for our kubernetes cluster.
            
    5. Kubernetes worker node - `k8s-node1`
        
        * The `k8s-node1` server will act as a worker node for our kubernetes cluster
            
* This concludes the brief description of the servers needed for our project. We can now proceed to **Phase I**.
    

### Setup AWS account for Terraform

1. To be able to set up the AWS resources with Terraform, we need to access AWS using **Access Keys**
    
2. Create a new user with administrator access to the AWS account
    
    * Goto **IAM &gt; Users**, click on **Add users** and enter the user name and click **Next**.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683891310377/713eeff5-b1c2-4aee-ac2f-1e53827e76e2.png align="center")
        
    * On the next page, select **Attach policies directly** and attach the **AdministratorAccess** policy to the user. Click on **Next**, then click on **Create user.**
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683891404598/c37896dd-1412-4ee1-b697-73f7032bcae4.png align="center")
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683891491991/6d48bb61-6804-4064-9a9b-6492eeaa0e8e.png align="center")
        
3. Create an AWS access key for the newly created user.
    
    * Navigate to **IAM &gt; Users &gt; tf-user**, select **Security credentials** and click on **Create access key**, select **Other** and click on **Next**.
        
    * Enter a name for your access key and click on **Create access key** to create the key.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683892022225/bd64e2f0-2655-43bd-a08b-34e866505f12.png align="center")
        
    * Next, you will get an option to download the `.csv` file containing the access key and secret key or you can simply copy and store them in a safe place
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683892196190/40d5ebb7-e492-4ec2-8430-3bba8c6e0765.png align="center")
        
4. Set environment variables on your local system for Terraform to access the AWS access key.
    
    * Create a file called `.envrc` in your home directory and write the commands to export the environment variables in it.
        
        ```bash
        #!/bin/bash
        
        ##Access_keys for AWS Terraform User##
        export TF_VAR_access_key="Enter the aws access key here"
        export TF_VAR_secret_key="Enter the secret access key here"
        ```
        
        Replace the data with your AWS access and secret keys and save the file. We have used the same variables in our terraform config files so make sure the name of the environment variables are exactly as mentioned in the code block above.
        
    * Edit your `.bashrc` file and add this line at the end `source ~/.envrc`  
        save the file and exit.
        

### Clone the Git repository

```bash
git clone https://github.com/mandeepsingh10/cicd-setup.git
```

1. In the git repo, we have three directories.
    
    * **ansible\_config** - contains all the ansible playbooks
        
    * **terraform\_config** - contains all the terraform config files
        
    * **scripts** - contains miscellaneous scripts to automate some tasks
        
2. To provision AWS instances using Terraform, we need to specify a **public key** to access the resources, we can use our public key for this instead of creating a new pair as it will help us to directly access the `EC2` instances without doing any additional configuration for ssh.
    
3. Copy your **public key** from `~/.ssh` directory to every Terraform configuration directory under `terraform_config` directory in the repository.
    
    ```bash
    cp $HOME/.ssh/id_rsa.pub $HOME/repos/cicd-setup/terraform_config/jenkins/publickey.pub
    
    ```
    
    My repository is present at `$HOME/repos` path, change that path as per your repo path and copy the public key as `publickey.pub` to all the directories `jenkins`, `master`, `nexus`, `node1` and `sonar` under `terraform_config` directory.
    
4. Now we will be able to provision the terraform resources by just running the `terraform apply` command.
    

### Create AWS instances using Terraform

1. First, we need to initialize all the directories where we have our Terraform configuration files.
    
    ```bash
    cd  $HOME/repos/cicd-setup/terraform_config/jenkins
    ➜ terraform init
    ```
    
    We need to initialize all the directories where we have our Terraform configuration files. To do this, navigate to each directory under `cicd/terraform_config` - `jenkins`, `master`, `nexus`, `node1`, and `sonar` - and run the command `terraform init`.
    
2. Next, we can try provisioning any one of the instances to check if our configuration is working as expected. To do this, navigate to the `Jenkins` directory and run the command `terraform plan`. If everything is set up correctly, it should display a message similar to this at the end:
    
    ```bash
    Changes to Outputs:
      + Name                 = "jenkins"
      + ami_id               = "ami-0bcb40eb5cb6d6f9e"
      + instance_id          = (known after apply)
      + keyname              = "jenkins-key"
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + securityGroupDetails = (known after apply)
    ```
    
    This means that our terraform configuration is correct and is working as expected.
    
3. To provision the jenkins server on AWS by running the command  
    `terraform apply --auto-approve` in the `cicd-setup/terraform_config/jenkins` directory.
    
4. Once the server is provisioned, the command will display details about the server, such as the hostname, `ami_id` of the image used, public and private IP addresses, similar to this:
    
    ```bash
    Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    Name = "jenkins"
    ami_id = "ami-0bcb40eb5cb6d6f9e"
    instance_id = "i-09a9d9b364b692fb7"
    keyname = "jenkins-key"
    public_dns = "ec2-3-109-154-107.ap-south-1.compute.amazonaws.com"
    public_ip = "3.109.154.107"
    securityGroupDetails = "sg-02b24f714c8b6b86a"
    ```
    
5. Let's try accessing the `jenkins` server by `ssh` using it's public IP. By default, `ubuntu` user is created on all our servers, as we are using **Ubuntu** ami image.
    
    ```bash
    ssh ubuntu@3.109.154.107
    ubuntu@jenkins:~$ 
    ```
    
    We can access the Jenkins server, which means we are good to go.
    
6. We can create all the resources at once by running the `t_createall.sh` script in the `cicd-setup/scripts` directory. However, I do not recommend doing this because we are using `t2.medium` `EC2` instances for our infrastructure setup. Creating all the resources at once can lead to an unnecessary increase in AWS EC2 charges, which we want to avoid as much as possible.
    
7. Let's move on to our next step, which is configuring our servers using Ansible playbooks. We can refer to this section whenever we need to provision the remaining servers on AWS.
    

### Configure the servers using Ansible

I have created Ansible playbooks to configure all the servers according to the application/service we need to run on them.

1. **Jenkins server**
    
    * Let's start with the `jenkins` server, but first, we need to populate our Ansible inventory file with the public IP addresses of our AWS instances so that we can run our Ansible playbooks. To do so, run the `generate_ansible_inventory.sh` from the `cicd-setup/scripts` directory.
        
        ```bash
        ~/repo/cicd-setup/scripts$
        ➜ ./generate_ansible_inventory.sh
        
        Creating inventory file for ansible ....
        
        Populating inventory file for ansible ....
        
        Done!!!
        ```
        
        Check the newly created inventory file under `ansible_config` directory.
        
        ```bash
        ~/repo/cicd-setup$
        ➜ cat ansible_config/inventory
        jenkins ansible_host=3.109.154.107 ansible_user=ubuntu ansible_connection=ssh
        sonar ansible_host= ansible_user=ubuntu ansible_connection=ssh
        nexus ansible_host= ansible_user=ubuntu ansible_connection=ssh
        k8s-master ansible_host= ansible_user=ubuntu ansible_connection=ssh
        k8s-node1 ansible_host= ansible_user=ubuntu ansible_connection=ssh
        ```
        
        We can see that the file is generated with the details required by Ansible to connect to the `jenkins` server. As we haven't provisioned the remaining servers yet, the IP details are empty for them.
        
    * Now, to configure the `jenkins` server as per our requirements for this project, simply run the Ansible playbook located at `ansible_config/jenkins/jenkins.yml`. You can check the Ansible playbook to understand how we are configuring the `jenkins`server. The playbook output shows us what all tasks are being performed.
        
        ```yaml
        ~/repos/cicd-setup/ansible_config$ 
        ➜ ansible-playbook -i inventory jenkins/jenkins.yaml
        
        PLAY [Install and start Jenkins] ********************************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [jenkins]
        
        TASK [ensure the jenkins apt repository key is installed] *******************************************************************************************************************
        changed: [jenkins]
        
        TASK [ensure the repository is configured] **********************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Ensure java is installed] *********************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [ensure jenkins is installed] ******************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [ensure jenkins is running] ********************************************************************************************************************************************
        ok: [jenkins]
        
        PLAY [Install Helm and datree.io helm plugin] *******************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [jenkins]
        
        TASK [Check if Helm is installed] *******************************************************************************************************************************************
        fatal: [jenkins]: FAILED! => {"changed": false, "cmd": "helm version", "delta": "0:00:00.002648", "end": "2023-05-12 18:31:45.516957", "msg": "non-zero return code", "rc": 127, "start": "2023-05-12 18:31:45.514309", "stderr": "/bin/sh: 1: helm: not found", "stderr_lines": ["/bin/sh: 1: helm: not found"], "stdout": "", "stdout_lines": []}
        ...ignoring
        
        TASK [Download Helm script] *************************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Install Helm] *********************************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Install unzip] ********************************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Check if Datree plugin exists] ****************************************************************************************************************************************
        ok: [jenkins]
        
        TASK [Install Datree plugin] ************************************************************************************************************************************************
        changed: [jenkins]
        
        PLAY [Install Docker] *******************************************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [jenkins]
        
        TASK [Install required packages] ********************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Add Docker GPG key] ***************************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Add Docker repository] ************************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Install Docker] *******************************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Add jenkins to sudo group] ********************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Add jenkins to docker group] ******************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Add jenkins to sudoers file] ******************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Install kubectl] ******************************************************************************************************************************************************
        changed: [jenkins]
        
        TASK [Create kubectl alias for root user] ***********************************************************************************************************************************
        changed: [jenkins]
        
        PLAY RECAP ******************************************************************************************************************************************************************
        jenkins                    : ok=23   changed=17   unreachable=0    failed=0    skipped=0    rescued=0    ignored=1 
        ```
        
    * If the playbook is executed without any errors, we should be able to access the Jenkins application from your browser using the public IP address followed by port `8080`.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683926674347/eacbd437-7ac0-40dd-960f-ad0c88c3a95e.png align="center")
        
    * Enter the `initial admin password` and click on `continue`.
        
    * Select `Installed suggested plugins`.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683927643846/4323b18a-1167-4b3a-b49b-d4e8c593f017.png align="center")
        
    * Now jenkins will install the suggested plugins, it will take 5-10 minutes for this to complete.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683927715907/0739a4d9-4458-4e5c-aacd-7c551481e59b.png align="center")
        
    * Once the suggested plugins are installed, you will be prompted to create a user. Create the user according to your preferences.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683927845150/6431505d-3c53-4402-a71e-7e02aabb7316.png align="center")
        
    * Next, you will see this screen, click on `Save and Finish` and then click on `Start using Jenkins` on the next screen.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683927939348/bfd0c9de-f351-4bcb-9cb9-87e5392a45e1.png align="center")
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683928024864/37b44993-3c20-4d84-8a79-7ac348769655.png align="center")
        
    * Finally, you will see the Jenkins dashboard, setup is completed.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683928078410/14f5598c-7a29-4907-853a-716b01e51d00.png align="center")
        
2. **SonarQube Server**
    
    * Follow the steps mentioned in **Create AWS instances using Terraform** section to provision the **SonarQube** server - `sonar`.
        
    * Once the server is provisioned, we need to repopulate the Ansible inventory file before running the playbook to configure sonarqube server.
        
        Run the script `cicd-setup/scripts/generate_ansible_inventory.sh`.
        
    * Run the Ansible playbook located at `ansible_config/sonar/sonar.yaml`.
        
        ```yaml
        ~/repos/cicd-setup/ansible_config$ 
        ➜ ansible-playbook -i inventory sonar/sonar.yaml
        
        PLAY [Install Docker and SonarQube] *****************************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [sonar]
        
        TASK [Install required packages] ********************************************************************************************************************************************
        changed: [sonar]
        
        TASK [Add Docker GPG key] ***************************************************************************************************************************************************
        changed: [sonar]
        
        TASK [Add Docker repository] ************************************************************************************************************************************************
        changed: [sonar]
        
        TASK [Install Docker] *******************************************************************************************************************************************************
        changed: [sonar]
        
        TASK [Start SonarQube container] ********************************************************************************************************************************************
        changed: [sonar]
        
        PLAY RECAP ******************************************************************************************************************************************************************
        sonar                      : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
        ```
        
    * We have deployed our SonarQube application on a docker container and exposed it on `9000` port. We should be able to access the Jenkins application from your browser using the public IP address followed by port `9000`.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683929751575/19fdc15a-8b99-49d4-80e1-9087ad986081.png align="center")
        
    * The default username is `admin` and password is also `admin`.
        
    * Next you will be promted to set a new password for the SonarQube application, set the new password and click on `update`.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683929961354/a98b0901-6bd8-4742-97e6-cef3b30eba41.png align="center")
        
    * Now you will see the SonarQube dashboard, setup is complete.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683930049739/d34807d7-e2a0-4cc0-9f95-1ff6176abf01.png align="center")
        
3. **SonaType Nexus Server**
    
    * Follow the steps mentioned in **Create AWS instances using Terraform** section to provision the **Nexus Repository Manager** server - `nexus`.
        
    * Once the server is provisioned, we need to repopulate the Ansible inventory file before running the playbook to configure nexus server.
        
        Run the script `cicd-setup/scripts/generate_ansible_inventory.sh`.
        
    * Run the Ansible playbook located at `ansible_config/nexus/nexus.yaml`.
        
        ```yaml
        ~/repos/cicd-setup/ansible_config$ 
        ➜ ansible-playbook -i inventory nexus/nexus.yaml
        
        PLAY [Install Nexus] ********************************************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [nexus]
        
        TASK [Install Java 8] *******************************************************************************************************************************************************
        changed: [nexus]
        
        TASK [Download Nexus] *******************************************************************************************************************************************************
        changed: [nexus]
        
        TASK [Extract Nexus] ********************************************************************************************************************************************************
        changed: [nexus]
        
        TASK [Start Nexus] **********************************************************************************************************************************************************
        changed: [nexus]
        
        PLAY RECAP ******************************************************************************************************************************************************************
        nexus                      : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
        ```
        
    * Nexus takes some time to load so wait for 2-3 minutes and then access it using the public IP address followed by port `8081`.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683931377652/8a48d8c8-89d1-457b-b99a-dc476b61bcdb.png align="center")
        
    * Click on "Sign In" and follow the on-screen instructions to get the initial admin password for Nexus. You will be prompted to set a new password for **Nexus**. Make sure to store this password as we will need it in Phase II of our project where we integrate different applications together.
        
    * On the next screen make sure `Enable anonymous access` is selected and then click on `Next`.
        
        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1683932180954/ec61b9f8-c258-4083-9ae7-58d907715640.png align="center")
        
    * Click on `Finish`, the setup is completed.
        
4. **Kubernetes Cluster**
    
    * In this section we will setup and configure a kubernetes cluster on AWS using kubeadm tool.
        
    * We will be deploying two k8s nodes, one control plane node `k8s-master` and one worker node `k8s-node1`
        
    * Follow the steps mentioned in **Create AWS instances using Terraform** section to provision the `k8s-master` and `k8s-node1` servers for our kubernetes cluster.
        
    * Once both the servers are provisioned, we need to repopulate the Ansible inventory file before running the playbook to setup and configure our kubernetes cluster.
        
        Run the script `cicd-setup/scripts/generate_ansible_inventory.sh`.
        
    * Run the Ansible playbook located at `ansible_config/k8s/k8s_cluster_setup.yaml`.
        
        ```yaml
        ~/repos/cicd-setup/ansible_config$ 
        ➜ ansible-playbook -i inventory k8s/k8s_cluster_setup.yaml
        
        PLAY [Add private IP of k8s instances to init scripts] **********************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [localhost]
        
        TASK [Run add_k8s_ip.sh] ****************************************************************************************************************************************************
        changed: [localhost]
        
        PLAY [Setup k8s Control Plane (master) node] ********************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [k8s-master]
        
        TASK [Copy master.sh script to remote server] *******************************************************************************************************************************
        changed: [k8s-master]
        
        TASK [Configure Control Plane (master) node] ********************************************************************************************************************************
        changed: [k8s-master]
        
        TASK [Get kubeadm join command] *********************************************************************************************************************************************
        changed: [k8s-master]
        
        TASK [Generate token to join the k8s cluster] *******************************************************************************************************************************
        changed: [k8s-master]
        
        TASK [Create join_cluster.sh] ***********************************************************************************************************************************************
        changed: [k8s-master -> localhost]
        
        TASK [Create kubectl alias] *************************************************************************************************************************************************
        changed: [k8s-master]
        
        PLAY [Configure kubectl for ubuntu user] ************************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [k8s-master]
        
        TASK [Create .kube directory for ubuntu user] *******************************************************************************************************************************
        changed: [k8s-master]
        
        TASK [Copy admin.conf to ubuntu's .kube directory] **************************************************************************************************************************
        changed: [k8s-master]
        
        TASK [Change ownership of .kube/config file] ********************************************************************************************************************************
        ok: [k8s-master]
        
        TASK [Create kubectl alias for ubuntu] **************************************************************************************************************************************
        changed: [k8s-master]
        
        PLAY [Setup k8s worker node] ************************************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [k8s-node1]
        
        TASK [Copy nodes.sh script to remote server] ********************************************************************************************************************************
        changed: [k8s-node1]
        
        TASK [Configure Worker node] ************************************************************************************************************************************************
        changed: [k8s-node1]
        
        TASK [Copy join_cluster.sh] *************************************************************************************************************************************************
        changed: [k8s-node1]
        
        TASK [Join k8s cluster] *****************************************************************************************************************************************************
        changed: [k8s-node1]
        
        PLAY [Copy the kubeconfig form k8s-master] **********************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [k8s-master]
        
        TASK [Fetch the file from the k8s-master to localhost] **********************************************************************************************************************
        changed: [k8s-master]
        
        PLAY [Jenkins User kubectl Setup] *******************************************************************************************************************************************
        
        TASK [Gathering Facts] ******************************************************************************************************************************************************
        ok: [jenkins]
        
        TASK [create directory and set ownership of .kube directory for jenkins user] ***********************************************************************************************
        changed: [jenkins]
        
        TASK [Copy the file from localhost to jenkins] ******************************************************************************************************************************
        changed: [jenkins]
        
        PLAY RECAP ******************************************************************************************************************************************************************
        jenkins                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
        k8s-master                 : ok=14   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
        k8s-node1                  : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
        localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
        ```
        
    * Once the playbook is successfully executed, we can login to our master nodes to verify the setup and configuration of our k8s cluster.
        
        ```bash
        ssh ubuntu@65.0.21.196
        
        ubuntu@k8s-master:~$ kubectl get nodes
        NAME         STATUS   ROLES           AGE     VERSION
        k8s-master   Ready    control-plane   11m     v1.27.1
        k8s-node1    Ready    <none>          9m39s   v1.27.1
        
        ubuntu@k8s-master:~$ kubectl get pods -n kube-system
        NAME                                 READY   STATUS    RESTARTS      AGE
        coredns-5d78c9869d-blhx8             1/1     Running   0             21m
        coredns-5d78c9869d-tfzj6             1/1     Running   0             21m
        etcd-k8s-master                      1/1     Running   0             21m
        kube-apiserver-k8s-master            1/1     Running   0             21m
        kube-controller-manager-k8s-master   1/1     Running   0             21m
        kube-proxy-qsp48                     1/1     Running   0             19m
        kube-proxy-rv87l                     1/1     Running   0             21m
        kube-scheduler-k8s-master            1/1     Running   0             21m
        weave-net-mx4lj                      2/2     Running   0             19m
        weave-net-zddmr                      2/2     Running   1 (20m ago)   21m
        ```
        
    * We can see that both the nodes are in **Ready** state, our k8s cluster is functional.
        

#### With this we have successfully completed Phase I of our project, the required infrastructure for the CICD pipeline is successfully provisioned and configured.
