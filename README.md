# example-project

## Creating Demo app to use

See [local demo app](./docs/local_demo_app.md) on the steps taken to create and test example react app.

# Infrastructure

< DIAGRAM GOES HERE >

## Created outside this project

See [subnets](./docs/subnets.md) for terraform examples of creating the public and private subnets aswell as the route tables you should associate with each.

* 1 VPC (main-vpc)
* 1 Internet Gateway
* 2 public subnets in two different AZ's
* 2 private subnets in two different AZ's

## Created inside this project

- [x] 2 NAT gateways, one in each public subnet
    - [x] A Elastic IP for each NAT Gateway
- [x] 2 Routes
    - update each private subnet's route table with a route for all its traffic to go to it's NAT gateway
- [x] EC2 Launch Template
    - [x] Security Group
- [x] Autoscaling group 
    - using the launch template, spin up one EC2 instance in either one of the two private subnets
- [x] 1 ALB, in public subnet