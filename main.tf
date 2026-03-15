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

### module for creating subnets ###


#### Public_subnet ####

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cider)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cider[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

    tags = merge(
    local.common_tags,
    # roboshop-public-us-east-1a
    {
      Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
    },
    var.pub_subnet_tags

  )
}


#### Private_subnet ####

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cider)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cider[count.index]
  availability_zone = local.az_names[count.index]
  

    tags = merge(
    local.common_tags,
    # roboshop-private-useast-1
    {
      Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
    },
    var.private_subnet_tags

  )

}


#### Database_subnet ####

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cider)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cider[count.index]
  availability_zone = local.az_names[count.index]
  

    tags = merge(
    local.common_tags,
    # roboshop-dev-database-useast-1
    {
      Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
    },
    var.database_subnet_tags

  )

}

#### 


