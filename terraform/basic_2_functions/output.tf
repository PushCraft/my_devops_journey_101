#Give me the IDs of ALL subnets created
output "publicsubnetids-Splat" {
  value = aws_subnet.PublicSubnet_functions.*.id
  # "*" ==> Index value. Also called "Splat Expression"
  # "Splat expression" = > Is used to extract attribute from all instances of 
  # a resource creaeting using 'count' or 'for_each'. 
}

# Manually extracting the ID's. Index by index.
#Give me the ID of subnet at index 'X'.
output "PublicSubnet-0" {
  value = aws_subnet.PublicSubnet_functions.0.id
}

output "PublicSubnet-1" {
  value = aws_subnet.PublicSubnet_functions.1.id
}

output "PublicSubnet-2" {
  value = aws_subnet.PublicSubnet_functions.2.id
}


# Output is used to show useful values after Terraform runs. 
# Terraform outputs gets values from Terraform's understanding of the Infra mostly from->
# Terraform state, Provider/API response, data sources , variables/locals. 


output "gettingVpc_id" {
  value = aws_vpc.DemoBasicVpc.id
}