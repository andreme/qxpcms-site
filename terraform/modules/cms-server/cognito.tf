resource "aws_cognito_user_pool" "cms" {
  name = var.project_name
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  schema {
    attribute_data_type = "String"
    name = "email"
    required = true
    string_attribute_constraints {
      min_length = "4"
      max_length = "2048"
    }
  }

  schema {
    attribute_data_type = "String"
    name = "family_name"
    required = true
    string_attribute_constraints {
      min_length = "2"
      max_length = "2048"
    }
    mutable = true
  }

  schema {
    attribute_data_type = "String"
    name = "given_name"
    required = true
    string_attribute_constraints {
      min_length = "2"
      max_length = "2048"
    }
    mutable = true
  }

  password_policy {
    require_symbols = false
    minimum_length = 8
    require_lowercase = true
    require_numbers = true
    require_uppercase = true
    temporary_password_validity_days = 7
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  tags = {
    Project = var.project_name
  }

}

resource "aws_cognito_user_pool_client" "cms" {
  name = "cms"

  user_pool_id = aws_cognito_user_pool.cms.id

  prevent_user_existence_errors = "ENABLED"

  generate_secret = false

  supported_identity_providers = ["COGNITO"]
  explicit_auth_flows = ["ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]

  allowed_oauth_flows = ["implicit", "code"]
  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_scopes = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]

  callback_urls = ["http://localhost:3000", "https://${aws_cloudfront_distribution.cms-server.domain_name}"]
  logout_urls = ["http://localhost:3000", "https://${aws_cloudfront_distribution.cms-server.domain_name}"]
}

resource "aws_cognito_user_pool_domain" "cms" {
  domain = var.project_name
  user_pool_id = aws_cognito_user_pool.cms.id
}

resource "aws_cognito_user_group" "main" {
  name = "admin"
  user_pool_id = aws_cognito_user_pool.cms.id
  precedence = 5
}
