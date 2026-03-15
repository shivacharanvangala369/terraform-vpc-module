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



#### module for creating routes table for public subnet ####

resource "aws_route_table" "public_rout" {
  vpc_id = aws_vpc.main.id

  # # Add a route for all internet traffic (0.0.0.0/0) directed to the Internet Gateway
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.main.id
  # }

  tags = merge(
    local.common_tags,
    # roboshop-dev-public
    {
      Name = "${var.project}-${var.environment}-public"
    },
    var.pub_route_tags

  )
}

#### module for creating routes table for private subnet ####

resource "aws_route_table" "private_rout" {
  vpc_id = aws_vpc.main.id

  # # Add a route for all internet traffic (0.0.0.0/0) directed to the Internet Gateway
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.main.id
  # }

  tags = merge(
    local.common_tags,
    # roboshop-dev-private
    {
      Name = "${var.project}-${var.environment}-private"
    },
    var.private_route_tags

  )
}

#### module for creating route table for database subnet ####

resource "aws_route_table" "database_rout" {
  vpc_id = aws_vpc.main.id

  # # Add a route for all internet traffic (0.0.0.0/0) directed to the Internet Gateway
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.main.id
  # }

  tags = merge(
    local.common_tags,
    # roboshop-dev-database
    {
      Name = "${var.project}-${var.environment}-database"
    },
    var.database_route_tags

  )
}


##### assignng route for pblic subnet #####

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public_rout
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}


#### cearting elatsic ip ####
resource "aws_eip" "nat_E_ip" {
  domain                    = "vpc"
  tags = merge(
    local.common_tags,
    # roboshop-dev-database
    {
      Name = "${var.project}-${var.environment}-nat"
    },
    var.nat_E_ip_tags

  )

}


### creating Nat_GW #####

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_E_ip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    local.common_tags,
    # roboshop-dev-nat-gw
    {
      Name = "${var.project}-${var.environment}-nat-gw"
    },
    var.nat_tags

  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}


##### assignng route for private subnet #####

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private_rout
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

##### assignng route for database subnet #####

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database_rout
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main
}

