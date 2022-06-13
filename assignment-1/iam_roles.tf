resource "aws_iam_role" "s3-astro-role" {
  name               = "s3-astro-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "s3-astro-role-instanceprofile" {
  name = "s3-astro-role"
  role = aws_iam_role.s3-astro-role.name
}

resource "aws_iam_role_policy" "s3-astro-role-policy" {
  name = "s3-astro-role-policy"
  role = aws_iam_role.s3-astro-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*",
              "cloudwatch:*",
              "rds:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF

}

