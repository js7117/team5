# Define availablility zone data
data "aws_availability_zones" "available" {
  state = "available"
}

# Define EC2 instance data
data "aws_ami" "linux2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}