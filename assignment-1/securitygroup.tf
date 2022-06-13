locals {
  ingress_rules = [
    {
      name        = "SSH"
      port        = 22
      description = "SSH Access"
  }]

}

resource "aws_security_group" "astro-web-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "astro-web-sg"
  description = "security group that allows ssh and all egress traffic"
  
  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.astro-web-alb-sg.id]
  }

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "astro-web-sg"
  }
}

resource "aws_security_group" "astro-app-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "astro-app-sg"
  description = "security group that allows ssh and all egress traffic"
  
  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.astro-app-alb-sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "astro-app-sg"
  }
}

resource "aws_security_group" "astro-mysql-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "mysql"
  description = "mysql"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.astro-app-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "mysql"
  }
}

#LoadBalancer sg 
resource "aws_security_group" "astro-app-alb-sg" {
  name = "astro-app-alb-sg"
  vpc_id = "${aws_vpc.main.id}"

  # http access within vpc
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "astro-web-alb-sg" {
  name = "astro-web-alb-sg"
  vpc_id = "${aws_vpc.main.id}"

  # http access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}