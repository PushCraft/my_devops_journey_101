provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket         = "polaris-state-store-bucketxyz"
    key            = "polaris-basic.tfstate"
    region         = "ca-central-1"
  }
}






