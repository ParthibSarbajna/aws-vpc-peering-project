# AWS VPC Peering Lab — GitHub Project

A reproducible Terraform implementation of the EWB AWS VPC Peering student workbook.

## What this deploys

- VPC A: `10.10.0.0/16`
  - Public subnet: `10.10.1.0/24` (bastion)
  - Private subnet: `10.10.2.0/24` (App-A)
- VPC B: `10.20.0.0/16`
  - Private subnet: `10.20.1.0/24` (App-B)
- Internet gateway for VPC A
- Explicit route tables, VPC peering, forward and return routes
- Restricted security groups
- Three Amazon Linux 2023 EC2 instances

> **Important:** This repository is infrastructure code, not proof of a completed AWS deployment. The deployment must be run in your own AWS account, and screenshots/test output must come from your actual environment. Do not submit fabricated evidence.

## Prerequisites

1. An AWS account with permission to create VPC, EC2, security groups, route tables, peering connections, and key pairs.
2. AWS CLI credentials configured locally (`aws configure` or an approved AWS SSO profile).
3. Terraform installed.
4. An SSH key pair. This project uses the public key only; keep the private key on your own computer.
5. Your current public IPv4 address in CIDR notation, e.g. `203.0.113.7/32` (replace with your real address).

Use a region you are permitted to use (example: `ap-south-1`). Check current AWS prices and account credits before deploying. EC2 instances, EBS storage, and public IPv4 addresses may incur charges.

## Quick start

From this repository folder:

```bash
cp terraform.tfvars.example terraform.tfvars
```

On Windows PowerShell, use:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set:
- `region`
- `student_name`
- `admin_cidr` to your own public IPv4 `/32`
- `public_key_path` to the path of your SSH **public** key (for example `C:/Users/YourUser/.ssh/id_ed25519.pub`)

Then run:

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
```

Review the plan and estimated costs. If it is correct and you accept the charges, deploy:

```bash
terraform apply
```

Terraform will ask for confirmation. Type `yes` only after reviewing the plan.

## Connect

After deployment, Terraform prints the bastion public IP and the private IPs.

For OpenSSH, from a terminal on your laptop (replace paths/IPs with your own outputs):

```bash
ssh -i ~/.ssh/id_ed25519 ec2-user@BASTION_PUBLIC_IP
```

To connect to App-A through the bastion:

```bash
ssh -i ~/.ssh/id_ed25519 -J ec2-user@BASTION_PUBLIC_IP ec2-user@10.10.2.10
```

To connect to App-B through the bastion:

```bash
ssh -i ~/.ssh/id_ed25519 -J ec2-user@BASTION_PUBLIC_IP ec2-user@10.20.1.10
```

The bastion and application instances use the public key supplied in `terraform.tfvars`. Do not upload private keys, `terraform.tfstate`, `.pem` files, credentials, or `terraform.tfvars` to GitHub.

## Validation checklist

Run tests only after `terraform apply` completes and instances are running.

1. **Baseline evidence:** The workbook asks for a failed App-A-to-App-B ping before peering/routes. This Terraform implementation creates peering and routes as one deployment, so the baseline must be captured using a separate staged deployment or documented as not captured. Do not claim a baseline test was performed if it was not.
2. From App-A, run `ping -c 4 10.20.1.10`; expected: replies after peering routes and ICMP rules are in place.
3. From App-B, run `ping -c 4 10.10.2.10`; expected: replies after routes and ICMP rules are in place.
4. Confirm neither App-A nor App-B has a public IPv4 address.
5. Test SSH to App-B through the bastion.
6. For the controlled failure, temporarily remove the App-B inbound ICMP rule sourced from `10.10.2.10/32`, repeat the ping from App-A, then restore the rule and repeat. Capture your own output/screenshots.

If ping does not work, check the peering status, both private route tables, the public route table's route to VPC B, security-group ICMP rules, instance state, and actual IP addresses.

## Cleanup — avoid ongoing charges

After saving your real evidence, destroy only the resources created by this Terraform project:

```bash
terraform destroy
```

Review the destroy plan carefully and type `yes` only if it contains only this lab's resources. Check the AWS console for leftover EBS volumes, public IPv4 allocations, and other billable resources.

## Repository safety

The `.gitignore` excludes local state, variable files, SSH private keys, and Terraform working directories. Never commit AWS access keys or secrets.
