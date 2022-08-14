resource "aws_s3_bucket" "private" {
  bucket = "${var.project_name}-private"

  force_destroy = false
}

resource "aws_s3_bucket_versioning" "private" {
  bucket = aws_s3_bucket.private.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.private.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
