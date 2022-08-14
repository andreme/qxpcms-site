
output "CMS_BACKEND_URL" {
  value = "https://${aws_cloudfront_distribution.cms-server.domain_name}/ui"
}

output "CMS_URL" {
  value = aws_apigatewayv2_stage.cms-default.invoke_url
}

output "COGNITO_USER_POOL_ID" {
  value = aws_cognito_user_pool.cms.id
}

output "COGNITO_USER_POOL_WEB_CLIENT_ID" {
  value = aws_cognito_user_pool_client.cms.id
}

output "BUILD_SITE_GENERATOR_LOG_GROUP" {
  value = aws_cloudwatch_log_group.build-site-generator.name
}

output "BUILD_SITE_GENERATOR_LOG_GROUP_ARN" {
  value = aws_cloudwatch_log_group.build-site-generator.arn
}

output "SITE_DEPLOYMENT_LOG_GROUP_ARN" {
  value = aws_cloudwatch_log_group.site-deployment.arn
}

output "SITE_DEPLOYMENT_LOG_GROUP" {
  value = aws_cloudwatch_log_group.site-deployment.name
}
