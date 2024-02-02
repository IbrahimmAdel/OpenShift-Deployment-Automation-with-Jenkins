# OpenShift Deployment Automation with Jenkins

> Comprehensive documentation for deploying a Java web app on OpenShift using Terraform, Ansible, Jenkins, and more.

## Overview

- This project automates the deployment of a Java web application on an OpenShift cluster. The process involves infrastructure provisioning with Terraform, configuration with Ansible, and continuous integration continuous delivery with Jenkins.

- Tools: Bash scripting, Git, SonarQube, Docker, Terraform, AWS, Ansible, Jenkins, and OpenShift.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Manual Testing, Building, and Running Procedures](#manual-testing-building-and-running-procedures)
3. [Infrastructure Provisioning with Terraform](#infrastructure-provisioning-with-terraform)
4. [Ansible Playbook for Configuration](#ansible-playbook-for-configuration)
5. [infra.sh](#infrash)
6. [OpenShift Deployment](#openshift-deployment)
7. [Jenkins Pipeline](#jenkins-pipeline)
8. [Monitoring and Logging OpenShift Cluster](#monitoring-and-logging-openshift-cluster)

---

## Prerequisites

Before you begin, ensure you have the following tools installed:

- Terraform
- Ansible
- OpenShift CLI 'OC'

---

## Manual Testing, Building, and Running Procedures

> This document provides a comprehensive guide outlining the manual steps before automating the process.

#### 1. Execute Unit Tests

```bash
./gradlew test
```
![unit-test-manual-run](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/unit-test-manual-run.png)

##### Access Test Results:
Navigate to the following path and open the index.html file:
```
cd build/reports/tests/test/
```
![unit-test-manual-index.html](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/unit-test-manual-index.html.png)

#### 2. Perform SonarQube Analysis

##### Prerequisites:
Ensure SonarQube project is configured with the necessary project key and login token.
```bash
./gradlew sonar \
-Dsonar.projectKey= <project_key> \
-Dsonar.host.url= <host_server_url> \
-Dsonar.login= <login_token> \
-Dsonar.scm.provider= git 
```

![sonarqube-run-test-locally](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/sonarqube-run-test-locally.png)

##### View Results:
Review the analysis on the SonarQube page
![sonarqube-page-report-after-run-test-locally](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/sonarqube-page-report-after-run-test-locally.png)


#### 3. Build and Run Application

##### Build Application:

```
./gradlew build --stacktrace
```
![app-manual-build](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/app-manual-build.png)


##### Run Application:
```
java -jar demo.jar
```
![app-manual-run](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/app-manual-run.png)

##### Access Application Locally:
Visit http://localhost:8081
![app-run-open-locally](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/app-run-open-locally.png)

#### 4. Build Docker Image and Run Container

###### Build Docker Image
```
docker build -t <image_name> .
```
![docker-image-test](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/docker-image-test.png)

###### Run Docker Continer
```
docker run --name=<container_name> -d -p 8081:8081 <image_name>
```
![docker-container-test](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/docker-container-test.png)

---

## Infrastructure Provisioning with Terraform

> This document provides comprehensive instructions for deploying infrastructure using Terraform. The project encompasses four modules: vpc, subnet, ec2, and cloudwatch. The objective is to establish an environment comprising network infrastructure with subnet and Internet Gateway, an EC2 instance for running Jenkins and SonarQube, and CloudWatch for monitoring with alarms sent via SNS.

### Overview

1. **[main.tf](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Terraform/main.tf)**
   - **Purpose:** Configure and define the cloud provider, Call terraform modules.
     
2. **[variables.tf](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Terraform/variables.tf)**
   - **Purpose:** Set variables that need to be defined in terraform.tfvar file.
   
3. **[terraform.tfvars](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Terraform/terraform.tfvars)**
   - **Purpose:** Define values for the needed variables.

4. **[Remote Backend](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Terraform/remote_backend.tf)**
   - **Purpose:** Store Terraform state remotely using S3 and DynamoDB.
     
![aws-s3-remote-state](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-s3-remote-state.png)
![aws-dynamodc-lock](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-dynamodc-lock.png)

5. **[VPC Module](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Terraform/vpc):**
   - **Purpose:** Provision a Virtual Private Cloud (VPC) with internet gateway for public access.
   - **Files:** `vpc/main.tf`, `vpc/variables.tf`, `vpc/outputs.tf`
     
![aws-vpc](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-vpc.png)
![aws-internet-gateway](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-internet-gateway.png)

6. **[Subnet Module](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Terraform/subnet):**
   - **Purpose:** Define public subnet, route table.
   - **Files:** `subnet/main.tf`, `subnet/variables.tf`, `subnet/outputs.tf`
     
![aws-subnet](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-subnet.png)
![aws-route-table](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-route-table.png)

7. **[EC2 Module](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Terraform/ec2):**
   - **Purpose:** Create an EC2 instance with necessary security group.
   - **Files:** `ec2/main.tf`, `ec2/variables.tf`, `ec2/outputs.tf`
     
![aws-ec2-instance](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-ec2-instance.png)
![aws-ec2-key-pair](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-ec2-key-pair.png)

8. **[CloudWatch Module](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Terraform/cloudwatch):**
   - **Purpose:** Set up CloudWatch resources for monitoring and SNS resources for sending mails for alarems.
   - **Files:** `cloudwatch/main.tf`, `cloudwatch/variables.tf`, `cloudwatch/outputs.tf`
     
![aws-cloudwatch](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-cloudwatch.png)
![aws-sns-gmail](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/aws-sns-gmail.jpeg)

### Usage

1. Update values in [terraform.tfvars](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Terraform/terraform.tfvars) file
- **region:**  AWS region where infrastructure will be created, default is 'us-east-1'.
- **vpc_cidr:**  IP range for VPC, default is '10.0.0.0/16'.
- **subnet_cidr:**  IP sub-range for subnet, default is '10.0.0.0/24'.
- **availability_zone:**  AZ where subnet will be created in VPC, default is 'us-east-1a'.
- **public_key_path:**  Path to generated key to access EC2 via SSH, To generate a new key:
  
```
ssh-keygen -f <path_to_file>
```
```
chmod 400 <path_to_file>
```
  
- **ec2_ami_id:**  choose EC2 image, default is 'Ubutu'.
- **ec2_type:**  The size type of EC2, default is 'm5.large'.
- **sns_email:**  Email that will received alarms.

2. Initialize and apply Terraform configurations:

```bash
terraform init
```
 ```bash
terraform apply
```

3. Follow on-screen prompts to provision infrastructure.

4. Destroy the infrastructure
```
terraform destroy
```

---

## Ansible Playbook for Configuration

> This document provides an overview of the Ansible playbook for installing and configuring Jenkins on an EC2 instance, along with additional roles for SonarQube, PostgreSQL, and Docker.

### Roles Structure and Details

[Prerequisite Role](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Ansible/roles/prerequisite)
   - **Purpose:** Install required packages on the EC2 instance.

[Postgres Role](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Ansible/roles/postgres)
   - **Purpose:** Install and configure Postgres for SonarQube.

[SonarQube Role](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Ansible/roles/SonarQube)
   - **Purpose:** Install and configure SonarQube on the EC2 instance.
   - **Resourses:** https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server/introduction/

[Git Role](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Ansible/roles/Git)
   - **Purpose:** Install Git on the EC2 instance.

[Jenkins Role](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Ansible/roles/Jenkins)
   - **Purpose:** Install Jenkins on the EC2 instance, Configure the initial password and admin username and password for login, Install necessary plugins that will be used in the project on jenkins such as 'OpenShift Client Plugin', 'SonarQube Scanner', and more.
   - After executing this role, Jenkins will be 100% ready to be used, There is no need to enter the initial password or set user info or install any plugins.
   - Note: you need to configure jenkins admin credentials in [vars.yml](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Ansible/roles/Jenkins/vars/main.yaml) file.
```
jenkins_user: ''
jenkins_password: ''
jenkins_fullname: ''
jenkins_email: ''
```

[Docker Role](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/tree/master/Ansible/roles/Docker)
   - **Purpose:** Install and configure Docker on the EC2 instance, Configure jenkins user to run docker commands.

### Usage
1. Update 'ansible_host & 'ansible_ssh_private_key_file' in **[inventory.ini](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Ansible/inventory.ini)**.
2. Update 'Jenkins admin credentials' in **[ansible/roles/jenkins/vars/main.yml](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Ansible/roles/Jenkins/vars/main.yaml)**.
3. Run Ansible playbook
    ```bash
    ansible-playbook -i inventory.ini playbook.yml
    ```
4. Ensure EC2 instance is configured as expected.
   ![ansible-post-roles-tasks](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/ansible-post-roles-tasks.png)
   ![ansible-host-services](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/ansible-host-services.png)
   ![ansible-ec2-jenkins](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/ansible-ec2-jenkins.png)
   ![ansible-ec2-sonarqube](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/ansible-ec2-sonarqube.png)

---

## [infra.sh](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/infra.sh)

> This Bash script is designed to streamline the setup of the project's infrastructure. It accomplishes this by executing 'Terraform' commands, updating the 'ansible_host' in the inventory.ini file with EC2 puplic IP, and finally running the Ansible playbook on the EC2 instance.

## Usage

### 1. Update terraform and ansible directories paths
```
vim infra.sh
```
and update
   - terraform_dir="./Terraform"
   - ansible_dir="./Ansible"

### 2. Make script executable

```
chmod +x infra.sh
```

### 3. Run script
```
./infra.sh
```

---

## OpenShift Deployment

> This document demonstrates the deployment of a Java web application on OpenShift. The orchestrated process includes setting up a deployment configuration for efficient scaling, establishing an internal service, implementing network policies for enhanced security, configuring routes for external access, and utilizing persistent volume claims to ensure data persistence and storage reliability.


### OpenShift Manifests

1. **[Deployment](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/OpenShift/deployment.yaml):**
   - **Purpose:** Define the deployment configuration for Java web-app.
   - **File:** `openshift/deployment.yml`

2. **[Service](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/OpenShift/service.yaml):**
   - **Purpose:** Expose the application within the OpenShift cluster.
   - **File:** `openshift/service.yml`

3. **[Network Policy](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/OpenShift/networkpolicy.yaml):**
   - **Purpose:** Define network policies for secure communication.
   - **File:** `openshift/networkpolicy.yml`

4. **[Route](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/OpenShift/route.yaml):**
   - **Purpose:** Expose the application externally.
   - **File:** `openshift/route.yml`

5. **[Persistent Volume Claim (PVC)](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/OpenShift/pvc.yaml):**
   - **Purpose:** Manage persistent storage for the application.
   - **File:** `openshift/pvc.yml`

### Usage

1. Navigate to OpenShift directory
 ```bash
cd OpenShift
 ```
2. Apply OpenShift deployment configurations:

 ```bash
 oc apply -f .
 ```
3. Verify the deployment status.
   ![Final-Deployment](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/Jenkins-final-deploy-openshift.png)

---

## Jenkins Pipeline

> This documentation provides detailed steps to set up and configure Jenkins for orchestrating an OpenShift deployment automation pipeline using jenkins shared library. The setup includes configuring Jenkins credentials, making the Shared Library available globally, managing SonarQube integration, and creating a new pipeline job.

## Prerequisite

### 1. Jenkins Shared Library
   **Purpose:** GitHub Repo files contain reusable functions for Jenkins pipeline.

- **[checkoutRepo.groovy](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Jenkins%20Shared%20Library/checkoutRepo.groovy):** Ckeck GitHub source coude.

- **[runUnitTests.groovy](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Jenkins%20Shared%20Library/runUnitTests.groovy):** run unit test command.

- **[runSonarQubeAnalysis.groovy](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Jenkins%20Shared%20Library/runSonarQubeAnalysis.groovy):** run sonarqube command.

- **[buildandPushDockerImage.groovy](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Jenkins%20Shared%20Library/buildandPushDockerImage.groovy):** Build docker image and push it to DockerHub, Function argument: DockerHub credentials ID, Image name.

- **[deployOnOpenShift.groovy](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Jenkins%20Shared%20Library/deployOnOpenShift.groovy):** login to OpenShift cluster and deploy files, Function argument: OpenShift Credentials ID 'could be KubeConfig file or Service account token', OpenShift Cluster url, OpenShift Project name, Image name.
  

### 2. OpenShift Service Account

#### Objective:
Create a service account for Jenkins with the necessary permissions to access the OpenShift cluster for deployment process.

#### Steps:
1. In OpenShift, create a service account for Jenkins.
```
oc create sc <serviceaccount_name> -n <project_name>
```

2. Assign the required roles and permissions to the service account.
```
oc create clusterrolebinding <rolebinding_name> --clusterrole=edit --serviceaccount=<project_name>:<serviceaccount_name>
```

3. Capture the token associated with the service account for authentication in Jenkins.
```
oc get secrets -n <project_name> -o jsonpath='{.items[?(@.metadata.annotations.kubernetes\.io/service-account\.name=="<serviceaccount_name>")].data.token}' | base64 -d
```

![jenkins-openshit-service-account](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/jenkins-openshit-service-account.png)


### 3. SonarQube Project

#### Objective:
Create a SonarQube project.

#### Steps:
1. Log in to SonarQube.
2. Navigate to Project.
3. Configure new project manually.


### 4. SonarQube Token:

#### Objective:
Generate a secure user token for SonarQube to be used by Jenkins during the execution of tests.

#### Steps:
1. Log in to SonarQube.
2. Navigate to Administration, Choose security, Then Users, Lastly Tokens.
3. Generate a new token with the necessary permissions for code analysis.

![jenkins-sonarqube-token](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/jenkins-sonarqube-token.png)

## Usage

### 1. Set Jenkins Credentials

#### Objective:
Configure Jenkins credentials for various services:

- GitHub
- DockerHub
- SonarQube Token
- OpenShift Token, Can be either 'Kubeconfig' file or 'service account' token and 'server URL'

Note: to get server URL, run:
```
oc cluster-info
```
![openshift_serverurl](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/get-openshift-apiserver.png)


#### Steps:
1. In Jenkins, navigate to Manage Jenkins, then Manage Credentials.
2. Add credentials for each service with the corresponding authentication details.

![jenkins-credentials](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/jenkins-credentials.png)

### 2. Make Shared Library Available Globally

#### Objective:
Push the shared library file to a separate GitHub repository and configure it to be globally available in Jenkins.

#### Steps:
1. Create a new GitHub repository for your Jenkins Shared Library.
2. Push your Shared Library code to the repository.
3. In Jenkins, go to Manage Jenkins, Then Configure System.
4. In the Global Pipeline Libraries section, add your GitHub repository details.

![jenkins-sharedLibrary-available](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/jenkins-sharedLibrary-available.png)

### 3. Manage SonarQube from Manage Jenkins

#### Objective:
Configure SonarQube settings from the "Manage Jenkins" section in Jenkins to integrate it seamlessly into the CI/CD pipeline.

#### Steps:
1. In Jenkins, navigate to Manage Jenkins, Then Configure System.
2. Scroll down to the SonarQube Servers section.
3. Add a new SonarQube server with the server URL and the previously generated SonarQube token.

![jenkins_add_sonarqube_plugin](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/jenkins-sonarqube-plugin-configuration.png)

### 4. Open Jenkins and Create a New Pipeline Job

#### Objective:
Set up a new pipeline job in Jenkins to orchestrate the deployment and testing processes.

#### Steps:
1. Open Jenkins in your browser.
2. Click on New Item to create a new pipeline job.
3. Configure the pipeline settings, including the pipeline script from your repository.


### 5. Update Variables in [Jenkinsfile](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Jenkinsfile)

#### Objective:
Customize the Jenkinsfile by updating variables to match the specifics of your project and environment.

#### Steps:
1. Open Jenkinsfile in your repository.
2. Update these variables:
   - **dockerHubCredentialsID:** DockerHub credentials ID.
   - **imageName:** DockerHub repo/image name.
   - **openshiftCredentialsID:** service account token credentials ID or KubeConfig credentials ID.
   - **openshiftClusterURL:** OpenShift Cluser URL.
   - **openshifProject:** OpenShift project name.
	    

### 6. Configure the Pipeline with the [Jenkinsfile]() in Your Repository

#### Objective:
Set up the pipeline configuration to use the Jenkinsfile in your project repository.

#### Steps:
1. In your Jenkins job configuration, specify the location of your Jenkinsfile in the repository.

### 7. Trigger the Pipeline:

#### Objective:
Initiate the execution of the pipeline to perform the defined stages, including infrastructure provisioning, configuration, and deployment.

#### Steps:
1. Manually trigger the pipeline in Jenkins or set up automatic triggers based on events in your version control system.

![jenkins-pipeline-final-run](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/jenkins-pipeline-final-run.png)
![dockerhub-image](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/Dockerhub-image-pushed.png)
![openshft-final-apply](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/Jenkins-final-deploy-openshift.png)

---

## Monitoring and Logging OpenShift Cluster

> This document highlights the Logging Operator, a Golang-based tool tailored for orchestrating EFK (Elasticsearch, Fluentd, and Kibana) clusters in Kubernetes and Openshift. The operator efficiently manages individual components of the EFK stack, simplifying deployment and maintenance in containerized environments.

### Usage

The aim and purpose of creating this Logging Operator to provide an easy and extensible interface to setting up logging stack such as EFK(Elasticsearch, Fluentd, and Kibana). It helps in setting up different nodes of elasticsearch cluster, fluentd as a log shipper and kibana for visualization.

## Setup using Helm tool 

#### 1. Add the helm chart

```
helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
```

#### 2. Deploy the Logging Operator

```
helm upgrade logging-operator ot-helm/logging-operator --install --namespace ot-operators
```

#### 3. Testing Operator

```
helm test logging-operator --namespace ot-operators
```

#### 4. List the pod and status of logging-operator
```
oc get pods -n ot-operators -l name=logging-operator
```
![Logging_operator](https://github.com/IbrahimmAdel/OpenShift-Deployment-Automation-with-Jenkins/blob/master/Screenshots/Logging_operator.png)


## Elasticsearch Setup

#### 1. Adding helm repository
```
helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
```

#### 2. Updating ot-helm repository

```
helm repo update
```

#### 3. Install the helm chart of Elasticsearch
```
helm install elasticsearch ot-helm/elasticsearch --namespace ot-operators \
--set esMaster.storage.storageClass=do-block-storage \
--set esData.storage.storageClass=do-block-storage
```

#### 4. Verify the status of the pods

```
oc get pods --namespace ot-operators -l 'role in (master,data,ingestion,client)'
```
#### 5. Verify the secret value
```
oc get secrets -n ot-operators elasticsearch-password -o jsonpath="{.data.password}" | base64 -d
```

#### 6. Elasticsearch cluster can be listed and verify using oc as well.
```
oc get elasticsearch -n ot-operators
```

## References
 - https://ot-logging-operator.netlify.app/docs/overview/
 - https://ot-logging-operator.netlify.app/docs/getting-started/installation/
 - https://ot-logging-operator.netlify.app/docs/getting-started/elasticsearch-setup/
 - https://ot-logging-operator.netlify.app/docs/configuration/elasticsearch-config/

---

## By following these detailed steps, you will establish a comprehensive CI/CD pipeline integrating Jenkins, SonarQube, Docker, and OpenShift.

---

