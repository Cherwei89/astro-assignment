resource "tls_private_key" "astro-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# module "key_pair" {
#   source = "terraform-aws-modules/key-pair/aws"

#   key_name   = "cgc-key"
#   public_key = tls_private_key.cgc-key.public_key_openssh
# }

resource "aws_key_pair" "astro-key-pair" {
  key_name   = var.key_name
  public_key = tls_private_key.astro-key.public_key_openssh

  tags = {
    Name = "astro-key-pair"
  }
}

resource "local_file" "astro-private-key" {
  content         = tls_private_key.astro-key.private_key_pem
  filename        = "astro-key.pem"
  file_permission = "0600"
}