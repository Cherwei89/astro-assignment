variable "AWS_REGION" {
  default = "ap-southeast-1"
}

# variable "PATH_TO_PRIVATE_KEY" {
#   default = "mykey"
# }

# variable "PATH_TO_PUBLIC_KEY" {
#   default = "mykey.pub"
# }

variable "AMIS" {
  type = map(string)
  default = {
    ap-southeast-1 = "ami-0adfdaea54d40922b"
  }
}

variable "RDS_PASSWORD" {
    default = "Welcome01!"
}

variable "key_name" {
  default = "astro-key"
}