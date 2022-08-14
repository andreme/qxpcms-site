
output "SITE_URL" {
  value = "https://${aws_cloudfront_distribution.site.domain_name}"
}

output "HOSTING_BUCKET" {
  value = aws_s3_bucket.hosting.bucket
}

output "HOSTING_BUCKET_ARN" {
  value = aws_s3_bucket.hosting.arn
}
