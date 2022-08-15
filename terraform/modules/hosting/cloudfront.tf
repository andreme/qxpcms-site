resource "aws_cloudfront_distribution" "site" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.hosting.website_endpoint
    origin_id = "s3"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "s3"

    cache_policy_id = aws_cloudfront_cache_policy.default.id

    compress = true

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.certificate_arn == ""
    acm_certificate_arn = var.certificate_arn
    ssl_support_method = var.certificate_arn == "" ? null : "sni-only"
    minimum_protocol_version = var.certificate_arn == "" ? "TLSv1" : "TLSv1.2_2019"
  }

//  logging_config {
//    bucket = aws_s3_bucket.cf_main.bucket_domain_name
//    prefix = "logs/"
//  }

  custom_error_response {
    error_code = 504
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code = 502
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code = 404
    error_caching_min_ttl = 0
  }

  tags = {
    Project = var.project_name
  }

  wait_for_deployment = false

  comment = "${var.project_name}-site"

}

resource "aws_cloudfront_cache_policy" "default" {
  name = "${var.project_name}-default"
  default_ttl = 60
  min_ttl = 60

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip = true
  }
}

//resource "aws_route53_record" "main" {
//  name = local.app_domain
//  type = "A"
//  zone_id = data.aws_route53_zone.main.zone_id
//
//  alias {
//    evaluate_target_health = false
//    name = aws_cloudfront_distribution.site.domain_name
//    zone_id = aws_cloudfront_distribution.site.hosted_zone_id
//  }
//}

//resource "aws_s3_bucket" "cf_main" {
//  bucket = "palletwatch-${var.name}-cloudfront"
//
//  lifecycle {
//    ignore_changes = [grant]
//  }
//}


// TODO set cf policies once supported by terraform: https://aws.amazon.com/about-aws/whats-new/2020/07/cloudfront-cache-key-policy/
