resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0
# peer_owner_id = var.peer_owner_id --> we are doing same account if we are doing in diff Acc then we have to give
  
  # Accetper
  peer_vpc_id   = data.aws_vpc.default_vpc.id

  # Requester
  vpc_id        = aws_vpc.main.id

  auto_accept = true

   accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-default"
    }
  )
}


resource "aws_route" "public_peering" {
  count = var.is_peering_requried ? 1 : 0
  route_table_id            = aws_route_table.public_rout.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block   #"172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id 
}

resource "aws_route" "private_peering" {
  count = var.is_peering_requried ? 1 : 0
  route_table_id            = aws_route_table.private_rout.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block   
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id 
}

resource "aws_route" "database_peering" {
  count = var.is_peering_requried ? 1 : 0
  route_table_id            = aws_route_table.database_rout.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block   
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id 
}

resource "aws_route" "default_peering" {
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.cidr_block   
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id 
}