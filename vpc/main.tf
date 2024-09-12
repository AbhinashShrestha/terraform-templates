terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.65.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#VPC
resource "aws_vpc" "custom-vpc" {
  cidr_block = "10.0.0.0/20"
  tags = {
    Name = "custom-vpc"
  }
}

#Private Subnet
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "private-subnet"
  }
}
#Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "public-subnet"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw-tobira" {
  vpc_id = aws_vpc.custom-vpc.id

  tags = {
    Name = "igw-tobira"
  }
}

#Routing Table
resource "aws_route_table" "ore-no-route-table" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tobira.id
  }
  tags = {
    Name = "ore-no-route-table"
  }
}

resource "aws_route_table_association" "public-facing" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.ore-no-route-table.id
}




#EC2 Instance 
resource "aws_instance" "app_server" {
  ami           = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet.id

  tags = {
    Name = "ec2-with-custom-vpc"
  }
}


