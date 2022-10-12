
resource "aws_acm_certificate" "site" {
  count = length(var.domains) > 0 && var.certificate_arn == "" ? 1 : 0
  domain_name = var.domains[0]
  validation_method = "DNS"

  subject_alternative_names = slice(var.domains, 1, length(var.domains))

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.us-east-1
}
