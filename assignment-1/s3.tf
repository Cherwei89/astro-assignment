module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "astro-s3-bucket-${random_string.random.result}"
  acl    = "private"

  versioning = {
    enabled = true
  }

}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}