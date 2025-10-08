
output "CMS_BACKEND_URL" {
  value = module.cms-server.CMS_BACKEND_URL
}

output "SITE_GIT_URL" {
  value = aws_codecommit_repository.site.clone_url_http
}

output "SITE_URL" {
  value = module.hosting.SITE_URL
}

output "CMS_FILES_BUCKET" {
  value = module.cms-server.CMS_FILES_BUCKET
}

output "CMS_FILES_BUCKET_ARN" {
  value = module.cms-server.CMS_FILES_BUCKET_ARN
}

output "CMS_TABLE_CMS_ARN" {
  value = module.cms-server.CMS_TABLE_CMS_ARN
}

output "CMS_TABLE_LIST_ARN" {
  value = module.cms-server.CMS_TABLE_LIST_ARN
}

output "EVENTBUS_ARN" {
  value = aws_cloudwatch_event_bus.events.arn
}
