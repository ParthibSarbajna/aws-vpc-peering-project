# AWS VPC Peering Project Report

> Complete this report with your own AWS resource IDs, screenshots, and actual command output. Do not present expected results as observed results.

## Cover Page

- **Project:** AWS VPC Peering — Connect Two VPCs
- **Student:** [Your name]
- **Batch:** [Your batch]
- **AWS Region:** [Actual region]
- **Completion date:** [Date]

## 1. Objective

To establish private IPv4 connectivity between two non-overlapping VPCs using AWS VPC Peering, explicit route tables, restricted security groups, and a bastion host for administration.

## 2. Architecture and Address Plan

| Resource | CIDR / IP | Actual AWS ID |
|---|---|---|
| VPC A | `10.10.0.0/16` | [Fill in] |
| Public subnet A | `10.10.1.0/24` | [Fill in] |
| Private subnet A | `10.10.2.0/24` | [Fill in] |
| VPC B | `10.20.0.0/16` | [Fill in] |
| Private subnet B | `10.20.1.0/24` | [Fill in] |
| Bastion | `10.10.1.10` + public IPv4 | [Fill in] |
| App-A | `10.10.2.10`, no public IP | [Fill in] |
| App-B | `10.20.1.10`, no public IP | [Fill in] |
| VPC peering | Active | [Fill in] |

## 3. Implementation

Describe the actual steps completed:
1. Created two VPCs with non-overlapping CIDRs.
2. Created the three subnets and explicitly associated route tables.
3. Attached an internet gateway to VPC A and configured the bastion's public route.
4. Created restricted security groups for SSH and ICMP.
5. Launched three EC2 instances using the lab SSH key.
6. Created and activated VPC peering.
7. Added routes in both directions and a peering route to the public subnet route table.

Attach screenshots from your own AWS console for each stage.

## 4. Route Tables

| Route table | Destination | Target | Evidence |
|---|---|---|---|
| `ewb-rt-a-public` | `10.10.0.0/16` | local | [Screenshot] |
| `ewb-rt-a-public` | `0.0.0.0/0` | internet gateway | [Screenshot] |
| `ewb-rt-a-public` | `10.20.0.0/16` | peering connection | [Screenshot] |
| `ewb-rt-a-private` | `10.10.0.0/16` | local | [Screenshot] |
| `ewb-rt-a-private` | `10.20.0.0/16` | peering connection | [Screenshot] |
| `ewb-rt-b-private` | `10.20.0.0/16` | local | [Screenshot] |
| `ewb-rt-b-private` | `10.10.0.0/16` | peering connection | [Screenshot] |

## 5. Validation Evidence

Paste actual output and screenshots. Mark each test as **Pass**, **Fail**, or **Not performed**.

### Baseline ping before peering/routes
- Host:
- Command: `ping -c 4 10.20.1.10`
- Actual output:
- Result:

### Forward path after peering/routes
- Host: App-A
- Command: `ping -c 4 10.20.1.10`
- Actual output:
- Result:

### Reverse path after peering/routes
- Host: App-B
- Command: `ping -c 4 10.10.2.10`
- Actual output:
- Result:

### SSH through bastion
- Command: `ssh -i <private-key-path> -J ec2-user@<bastion-public-ip> ec2-user@10.20.1.10`
- Actual output:
- Result:

### Controlled ICMP failure and recovery
Temporarily remove only the App-B inbound ICMP rule from `10.10.2.10/32`, test the forward ping, restore the rule, and test again.
- Output with rule removed:
- Output after restoration:
- Result:

## 6. Troubleshooting

Document any actual issue and its resolution. Check peering status, route-table associations, forward and return routes, actual instance IPs, and security-group rules.

## 7. Security and Cost Controls

- App-A and App-B have no public IPv4 addresses.
- Bastion SSH ingress is restricted to the administrator's public IPv4 `/32`.
- SSH to private hosts is allowed from the bastion private IP.
- No NAT gateway is deployed.
- State whether cleanup was completed and include evidence.

## 8. Conclusion

[Summarize what was successfully built and tested. Only claim tests that were actually performed.]
