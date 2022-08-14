
resource "aws_s3_bucket" "cms-files" {
  bucket = "${var.project_name}-cms-files"

  object_lock_enabled = true

  force_destroy = false
}

resource "aws_s3_bucket_policy" "cms-files" {
  bucket = aws_s3_bucket.cms-files.bucket

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${aws_s3_bucket.cms-files.arn}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket_versioning" "cms-files" {
  bucket = aws_s3_bucket.cms-files.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "cms-files" {
  bucket = aws_s3_bucket.cms-files.bucket

  cors_rule {
    allowed_headers = [
      "*",
    ]
    allowed_methods = [
      "GET",
      "HEAD",
      "PUT",
    ]
    allowed_origins = [
      "*",
    ]
    expose_headers = [
      "ETag",
    ]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "cms-files" {
  bucket = aws_s3_bucket.cms-files.id

  block_public_acls = true
  block_public_policy = false
  ignore_public_acls = true
  restrict_public_buckets = false
}
