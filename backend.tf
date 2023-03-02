# Defining backend in Terraform Cloud
terraform {
  backend "remote" {
    organization = "Skillstorm_VetTec-Project3"
    workspaces {
      name = "VetTec-Project3"
    }
  }
}