# output "az_info" {
#   value = slice(data.aws_availability_zones.available.name, 0, 2)
# }



output "default_vpc_id" {
  value = data.aws_vpc.default_vpc.id
  description = "The ID of the default VPC"
}