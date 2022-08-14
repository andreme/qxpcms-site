
output "CMS_BACKEND_URL" {
  value = module.cms-server.CMS_BACKEND_URL
}

output "COGNITO_USER_POOL_ID" {
  value = module.cms-server.COGNITO_USER_POOL_ID
}

output "COGNITO_USER_POOL_WEB_CLIENT_ID" {
  value = module.cms-server.COGNITO_USER_POOL_WEB_CLIENT_ID
}

output "SITE_GIT_URL" {
  value = aws_codecommit_repository.site.clone_url_http
}

output "SITE_URL" {
  value = module.hosting.SITE_URL
}
