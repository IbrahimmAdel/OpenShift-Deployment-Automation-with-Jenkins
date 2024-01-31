#!/bin/bash
# Provision Terraform infrastructure and configure EC2 instance with Ansible

# Set path to Terraform and Ansible directories
terraform_dir="./Terraform"
ansible_dir="./Ansible"

# Function to run Terraform
run_terraform() {
    cd "${terraform_dir}"
    echo "Running Terraform..."
    terraform init
    terraform apply -auto-approve
    echo "Terraform execution completed."
}

# Function to get public IP of EC2 instance
get_ip() {
    echo "Getting EC2 public IP..."
    ec2_public_ip=$(terraform output ec2_public_ip)
    echo "EC2 public IP is: ${ec2_public_ip}"
    cd ..
}

# Function to update Ansible inventory file with new public IP
update_inventory() {
    cd "$ansible_dir" 
    echo "Updating Ansible inventory file..."
    echo -e "ec2 ansible_host=${ec2_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ivolve" > "./inventory.ini"
    echo "Ansible inventory updated with new EC2 public IP: $ec2_public_ip"
}

# Function to run Ansible playbook
run_ansible() {
    echo "Running Ansible playbook..."
    export ANSIBLE_HOST_KEY_CHECKING=False
    ansible-playbook -i inventory.ini playbook.yml
    echo "Ansible execution completed."
}

# Main script
run_terraform
get_ip
update_inventory
run_ansible

