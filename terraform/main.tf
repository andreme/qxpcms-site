module "cms-server" {
  source = "./modules/cms-server"

  project_name = var.project_name

  api_key = var.cms_server_api_key

  event_bus = aws_cloudwatch_event_bus.events.name
  event_bus_arn = aws_cloudwatch_event_bus.events.arn

  tz = var.tz
}

module "site-generator" {
  source = "./modules/site-generator"

  project_name = var.project_name

  site_git_url = aws_codecommit_repository.site.clone_url_http
  site_repository_arn = aws_codecommit_repository.site.arn

  log_group_arn = module.cms-server.BUILD_SITE_GENERATOR_LOG_GROUP_ARN
  log_group = module.cms-server.BUILD_SITE_GENERATOR_LOG_GROUP

  event_bus_arn = aws_cloudwatch_event_bus.events.arn
}

module "site-deployment" {
  source = "./modules/site-deployment"

  project_name = var.project_name

  site_generator_repository_url = module.site-generator.REPOSITORY_URL

  cms_url = module.cms-server.CMS_URL
  cms_server_api_key = var.cms_server_api_key

  hosting_bucket = module.hosting.HOSTING_BUCKET
  hosting_bucket_arn = module.hosting.HOSTING_BUCKET_ARN

  event_bus_arn = aws_cloudwatch_event_bus.events.arn
  event_bus = aws_cloudwatch_event_bus.events.name

  subnet = var.site_deployment_subnet
  security_group = var.site_deployment_security_group

  log_group_arn = module.cms-server.SITE_DEPLOYMENT_LOG_GROUP_ARN
  log_group = module.cms-server.SITE_DEPLOYMENT_LOG_GROUP

}

module "hosting" {
  source = "./modules/hosting"

  project_name = var.project_name

  domains = var.hosting_domains

  certificate_arn = var.hosting_certificate_arn

  redirect_from_naked_to_www = var.hosting_redirect_from_naked_to_www

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}
