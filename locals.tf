locals {
  common_tags ={
    Project = var.project
    Environment = var.environment
    Terraform = true
  }
  vpc_final_tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    },
    var.vpc_tags

  )
  IGW_final_tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    },
    var.IGW_tags

  )
  az_names = slice(data.aws_availability_zones.available.names, 0, 2)
#   pub-sub_final_tags = merge(
#     local.common_tags,
#     # roboshop-public-useast-1
#     var.pub_subnet_tags

#   ) 
  

}