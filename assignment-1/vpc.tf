### VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.5.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "astro-vpc"
  }
}

### Subnets
resource "aws_subnet" "astro-public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.5.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "astro-public-1"
  }
}

resource "aws_subnet" "astro-public-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.5.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name = "astro-public-2"
  }
}

resource "aws_subnet" "astro-private-db-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.5.10.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "astro-private-db-1"
  }
}

resource "aws_subnet" "astro-private-db-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.5.20.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name = "astro-private-db-2"
  }
}

resource "aws_subnet" "astro-private-app-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.5.11.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "astro-private-app-1"
  }
}

resource "aws_subnet" "astro-private-app-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.5.21.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name = "astro-private-app-2"
  }
}

# Internet GW
resource "aws_internet_gateway" "astro-main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "astro-main-gw"
  }
}

# NAT Gateway
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["AmazonProvidedDNS"]
}

# associate dhcp with vpc
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}

resource "aws_eip" "astro-nat-eip" {
  vpc = true
  depends_on = [aws_internet_gateway.astro-main-gw, aws_vpc_dhcp_options_association.dns_resolver]
  tags = {
    Name = "astro-nat-eip"
  }
}

resource "aws_nat_gateway" "astro-nat-gateway" {
  allocation_id = aws_eip.astro-nat-eip.id
  subnet_id     = aws_subnet.astro-public-1.id
  depends_on = [aws_internet_gateway.astro-main-gw]
  tags = {
    Name = "astro-nat-gateway"
  }
}

# route tables
resource "aws_route_table" "astro-main-public-rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.astro-main-gw.id
  }

  tags = {
    Name = "astro-main-public-rtb"
  }
}

# route associations public
resource "aws_route_table_association" "astro-main-public-1" {
  subnet_id      = aws_subnet.astro-public-1.id
  route_table_id = aws_route_table.astro-main-public-rtb.id
}

resource "aws_route_table_association" "astro-main-public-2" {
  subnet_id      = aws_subnet.astro-public-2.id
  route_table_id = aws_route_table.astro-main-public-rtb.id
}

