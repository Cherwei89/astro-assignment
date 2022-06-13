# resource "aws_instance" "astro-web" {
#   ami           = var.AMIS[var.AWS_REGION]
#   instance_type = "t2.micro"

#   # the VPC subnet
#   subnet_id = aws_subnet.astro-public-1.id

#   # the security group
#   vpc_security_group_ids = [aws_security_group.astro-test-sg.id]

#   # the public SSH key
#   key_name = aws_key_pair.astro-key-pair.key_name

#   tags = {
#     Name = "astro-web"
#   }
# }