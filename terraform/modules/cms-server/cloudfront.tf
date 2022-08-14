resource "aws_cloudfront_distribution" "cms-server" {
  origin {
    domain_name = replace(aws_apigatewayv2_stage.cms-default.invoke_url, "/^https?://([^/]*).*/", "$1")
    origin_id = "apigw"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT"
    ]
    cached_methods = ["GET", "HEAD"]

    target_origin_id = "apigw"

    forwarded_values {
      query_string = true

      headers = [
        "User-Agent",
        "If-None-Match",
      ]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD", "OPTIONS"]
    path_pattern = "/static/*"
    target_origin_id = "apigw"
    viewer_protocol_policy = "redirect-to-https"

    default_ttl = 3600
    max_ttl = 2630000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

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

  comment = "${var.project_name}-server"

}
