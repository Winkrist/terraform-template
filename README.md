# Terraform Templates

## Overview
Terraform templates, made for AWS resources. 

## How to use:
- Use code in each file and copy to a .tf file
- Input variables, e.g. region, access key, secret key, instance AMI, instance type. Save changes. 
- initialise terraform (terraform init)
- Check any errors using (terraform plan)
- If no errors, push to AWS (terraform apply)

# Useful commands
```bash
terraform init #to initialise terraform
terraform plan #to check prior to terraform deploy
terraform apply #push tf to be executed
```