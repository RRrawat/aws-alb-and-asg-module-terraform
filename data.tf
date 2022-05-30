#Amazon Availability zone 

data "aws_availability_zones" "all" {}

#Amazon Linux AMI

data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}


data "aws_vpc" "vpc" {
  id = var.vpc_id
}

# Amazon subnet ids inside vpc 

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.vpc.id
}


module "tags" {
  source = "./common_tags"

  enviroment = var.enviroment
  additional_tags = var.additional_tags
  
}
