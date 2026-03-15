#### modeule for creating VPC ###

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.vpc_final_tags
}

# resource "aws_vpc_ipam" "test" {
#   operating_regions {
#     region_name = data.aws_region.current.region
#   }
# }


### module for craeting IGW ###

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id ### assocating our vpc to this IGW

  tags = local.IGW_final_tags
}


