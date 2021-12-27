resource "aws_iam_role" "web_role" {
  name               = "web_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "web_s3_access" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect : "Allow",
        Action : "s3:*",
        Resource : "${aws_s3_bucket.web_access_log.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "web_s3_access_policy" {
  name   = "s3_role_policy"
  role   = aws_iam_role.web_role.id
  policy = aws_iam_policy.web_s3_access.policy
}

resource "aws_iam_instance_profile" "web_instances" {
  name = "s3_access_profile"
  role = aws_iam_role.web_role.name
}
