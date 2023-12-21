# terraform base

Here are a few common .tf files you need for a project that uses terraform to create infrastructure.

* main.tf
    - includes the configuration for terraform and aws provider
    - if storing terraform statefiles remotely in S3 bucket, this file includes backend config for that as well
* variables.tf
    - every project will, or atleast should, utilize input variables which will be defined in here
* locals.tf
    - most projects also include local variables (variables that are defined within terraform and not expected to be provided by user at the time of executing terraform)

## main.tf

```hcl
terraform {
  # Terraform core should be pinned to a minor version
  required_version = "= 1.5.6"
  required_providers {
    # Providers should be pinned to a major version
    # The provider source should always be specified
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.14.0"
    }
  }
  # storing terraform statefile in S3 bucket
  # leave this part out if you wish to store state files locally.
  backend "s3" {
    region = "us-east-1"
    bucket = "<BUCKET_NAME"
    key    = "<PATH_OF_CHOICE>/terraform.tfstate" 
    # common to see key = "terraform/<PROJECT_NAME>/terraform.tfstate"
  }
}

# define the provider resource terraform can use 
provider "aws" {
  # Update with your desired region
  region = local.default_region
}
```

## variables.tf

```hcl
variable "vpc_id" {
  type = string
  description = "main VPC ID"
  default = "vpc-123abc123abc"
}
```

## locals.tf

```hcl
locals = {
    module_name = "my-first-module"
}
```
