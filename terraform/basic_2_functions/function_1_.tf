
# Create 3 'Public subnets' using function. Instead of manually creating each.

resource "aws_subnet" "PublicSubnet_functions" {
  vpc_id = aws_vpc.DemoBasicVpc.id
  # count  = 3
  # This will create '3' specified resources, Which are 3 subnets.  
  #Indexed would be "0", "1" and "2".
  count = length(var.publicSubnetCidr)
  # The count value will be adjusted depending upon the number of "CIDR" list items you provide.
  # You will provide the 3 CIDR blocks as 'list' type. When assigning to variable value.
  # Terraform will loop( Iterate ) because of 'count' function.
  cidr_block        = element(var.publicSubnetCidr, count.index)
  availability_zone = element(var.az, count.index)
  # "element" is mapping each subnet to a CIDR block based on the index. 
  # 'count.index' -> An automatically increamenting number for each resource instance. Always starts from "0" (zero) and end till == to 'count'. 


  # Since you have 3 subnet's. You will also provide the 3 cidr block in list type. 
  map_public_ip_on_launch = true
  # This will assign an Public IP for every resource in this subnet. 
  tags = {
    "source" = var.tagX
    "Name"   = "${var.vpc_name}-PublicXSubnet-${count.index}"
    #  Anythign in between {} is interpolation, combines all the parts into a single string.
    # var.vpc_name == variable called. "PublicXSubnet" == Static String. "count.index" ==> Auto-increament numbers. 

  }
}


resource "aws_subnet" "PrivateSubnet_function" {
  vpc_id            = aws_vpc.DemoBasicVpc.id
  count             = length(var.privateSubnetCidr)
  cidr_block        = element(var.privateSubnetCidr, count.index)
  availability_zone = element(var.az, count.index)

  tags = {
    "source" = var.tagX
    "Name"   = "${var.vpc_name} PrivateSubNetX ${count.index}"
  }
}

# Here count is "Meta-Argument. other common are -> for_each, depends_on, lifecycle, provider"
