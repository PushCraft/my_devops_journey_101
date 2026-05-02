region            = "ca-central-1"
vpc_name          = "Polaris"
vpc_cidr          = "10.80.0.0/16"
publicSubnetCidr  = ["10.80.1.0/24", "10.80.2.0/24", "10.80.3.0/24"]
privateSubnetCidr = ["10.80.10.0/24", "10.80.20.0/24", "10.80.30.0/24"]
az                = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
tagX              = "Terraform-Testing"
Pushing_from      = "vsCode_P14s_ThinkPad_Station"