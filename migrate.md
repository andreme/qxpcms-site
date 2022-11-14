## Version 0.0.8
```
terraform> terraform apply
```

## Version 0.0.0

Copy `main.tf`, `outputs.tf`, `.terraform.lock.hcl` and `versions.tf` into `terraform/`

Remove archive from `tfconfig.tf` and clear `.terraform/modules` and `.terraform/providers`

Update `main.tf` with values from `env.tf`

Remove cms terraform files (including `env.tf`)

Add `terraform/.terraform/modules/modules.json` to outer .gitignore

```
site> yarn add qxpcms-site

terraform> terraform init

terraform state mv aws_cloudfront_distribution.cms-server module.qxpcms.module.cms-server.aws_cloudfront_distribution.cms-server
terraform state mv aws_s3_bucket.cms-files module.qxpcms.module.cms-server.aws_s3_bucket.cms-files
terraform state mv aws_s3_bucket_cors_configuration.cms-files module.qxpcms.module.cms-server.aws_s3_bucket_cors_configuration.cms-files
terraform state mv aws_s3_bucket_policy.cms-files module.qxpcms.module.cms-server.aws_s3_bucket_policy.cms-files
terraform state mv aws_s3_bucket_public_access_block.cms-files module.qxpcms.module.cms-server.aws_s3_bucket_public_access_block.cms-files
terraform state mv aws_s3_bucket_versioning.cms-files module.qxpcms.module.cms-server.aws_s3_bucket_versioning.cms-files
terraform state mv aws_lambda_function.server module.qxpcms.module.cms-server.aws_lambda_function.server
terraform state mv aws_lambda_permission.cms module.qxpcms.module.cms-server.aws_lambda_permission.cms
terraform state mv aws_iam_role_policy_attachment.server-AWSLambdaBasicExecutionRole module.qxpcms.module.cms-server.aws_iam_role_policy_attachment.server-AWSLambdaBasicExecutionRole
terraform state mv aws_iam_role_policy.cms-server-access module.qxpcms.module.cms-server.aws_iam_role_policy.cms-server-access
terraform state mv aws_iam_role.cms-server module.qxpcms.module.cms-server.aws_iam_role.cms-server
terraform state mv aws_dynamodb_table.list module.qxpcms.module.cms-server.aws_dynamodb_table.list
terraform state mv aws_dynamodb_table.cms module.qxpcms.module.cms-server.aws_dynamodb_table.cms
terraform state mv aws_cognito_user_pool_domain.cms module.qxpcms.module.cms-server.aws_cognito_user_pool_domain.cms
terraform state mv aws_cognito_user_pool_client.cms module.qxpcms.module.cms-server.aws_cognito_user_pool_client.cms
terraform state mv aws_cognito_user_pool.cms module.qxpcms.module.cms-server.aws_cognito_user_pool.cms
terraform state mv aws_cognito_user_group.main module.qxpcms.module.cms-server.aws_cognito_user_group.main
terraform state mv aws_cloudwatch_log_group.server module.qxpcms.module.cms-server.aws_cloudwatch_log_group.server
terraform state mv aws_cloudwatch_log_group.qxpcms-system module.qxpcms.module.cms-server.aws_cloudwatch_log_group.qxpcms-system
terraform state mv aws_apigatewayv2_stage.cms-default module.qxpcms.module.cms-server.aws_apigatewayv2_stage.cms-default
terraform state mv aws_apigatewayv2_route.cms module.qxpcms.module.cms-server.aws_apigatewayv2_route.cms
terraform state mv aws_apigatewayv2_integration.cms module.qxpcms.module.cms-server.aws_apigatewayv2_integration.cms
terraform state mv aws_apigatewayv2_api.cms module.qxpcms.module.cms-server.aws_apigatewayv2_api.cms
terraform state mv aws_s3_bucket_versioning.private module.qxpcms.aws_s3_bucket_versioning.private
terraform state mv aws_s3_bucket_public_access_block.private module.qxpcms.aws_s3_bucket_public_access_block.private
terraform state mv aws_s3_bucket.private module.qxpcms.aws_s3_bucket.private
terraform state mv aws_iam_role_policy.trigger-build-site-generator module.qxpcms.module.site-generator.aws_iam_role_policy.trigger-build-site-generator
terraform state mv aws_iam_role_policy.build-site-generator module.qxpcms.module.site-generator.aws_iam_role_policy.build-site-generator
terraform state mv aws_iam_role.trigger-build-site-generator module.qxpcms.module.site-generator.aws_iam_role.trigger-build-site-generator
terraform state mv aws_iam_role.build-site-generator module.qxpcms.module.site-generator.aws_iam_role.build-site-generator
terraform state mv aws_ecr_repository.main module.qxpcms.module.site-generator.aws_ecr_repository.main
terraform state mv aws_ecr_lifecycle_policy.main module.qxpcms.module.site-generator.aws_ecr_lifecycle_policy.main
terraform state mv aws_codebuild_project.build-site-generator module.qxpcms.module.site-generator.aws_codebuild_project.build-site-generator
terraform state mv aws_cloudwatch_log_group.build-site-generator module.qxpcms.module.site-generator.aws_cloudwatch_log_group.build-site-generator
terraform state mv aws_cloudwatch_event_target.site-generator-trigger-build module.qxpcms.module.site-generator.aws_cloudwatch_event_target.site-generator-trigger-build
terraform state mv aws_cloudwatch_event_rule.site-generator-trigger-build module.qxpcms.module.site-generator.aws_cloudwatch_event_rule.site-generator-trigger-build
terraform state mv aws_codecommit_repository.site module.qxpcms.aws_codecommit_repository.site
terraform state mv aws_cloudwatch_log_resource_policy.log-system-event module.qxpcms.module.cms-server.aws_cloudwatch_log_resource_policy.log-system-event
terraform state mv aws_cloudwatch_event_target.log-system-event module.qxpcms.module.cms-server.aws_cloudwatch_event_target.log-system-event
terraform state mv aws_cloudwatch_event_rule.log-system-event module.qxpcms.module.cms-server.aws_cloudwatch_event_rule.log-system-event
terraform state mv aws_cloudwatch_event_bus.events module.qxpcms.aws_cloudwatch_event_bus.events
terraform state mv aws_iam_role_policy.site-deployment-run-task module.qxpcms.module.site-deployment.aws_iam_role_policy.site-deployment-run-task
terraform state mv aws_iam_role_policy.cms-site-generator-ecs-execution module.qxpcms.module.site-deployment.aws_iam_role_policy.cms-site-generator-ecs-execution
terraform state mv aws_iam_role_policy.cms-site-generator-ecs-container module.qxpcms.module.site-deployment.aws_iam_role_policy.cms-site-generator-ecs-container
terraform state mv aws_iam_role.site-deployment module.qxpcms.module.site-deployment.aws_iam_role.site-deployment
terraform state mv aws_iam_role.cms-site-generator-ecs-execution module.qxpcms.module.site-deployment.aws_iam_role.cms-site-generator-ecs-execution
terraform state mv aws_iam_role.cms-site-generator-ecs-container module.qxpcms.module.site-deployment.aws_iam_role.cms-site-generator-ecs-container
terraform state mv aws_efs_mount_target.cms-site-generator module.qxpcms.module.site-deployment.aws_efs_mount_target.cms-site-generator
terraform state mv aws_efs_file_system.cms-site-generator module.qxpcms.module.site-deployment.aws_efs_file_system.cms-site-generator
terraform state mv aws_efs_access_point.cms-site-generator-public module.qxpcms.module.site-deployment.aws_efs_access_point.cms-site-generator-public
terraform state mv aws_efs_access_point.cms-site-generator-cache module.qxpcms.module.site-deployment.aws_efs_access_point.cms-site-generator-cache
terraform state mv aws_ecs_task_definition.cms-site-generator module.qxpcms.module.site-deployment.aws_ecs_task_definition.cms-site-generator
terraform state mv aws_ecs_cluster.main module.qxpcms.module.site-deployment.aws_ecs_cluster.main
terraform state mv aws_cloudwatch_log_group.ecs-cms-site-generator module.qxpcms.module.site-deployment.aws_cloudwatch_log_group.ecs-cms-site-generator
terraform state mv aws_cloudwatch_event_target.deploy-site module.qxpcms.module.site-deployment.aws_cloudwatch_event_target.deploy-site
terraform state mv aws_cloudwatch_event_rule.start-site-deployment module.qxpcms.module.site-deployment.aws_cloudwatch_event_rule.start-site-deployment
terraform state mv aws_s3_bucket_website_configuration.hosting module.qxpcms.module.hosting.aws_s3_bucket_website_configuration.hosting
terraform state mv aws_s3_bucket_policy.hosting module.qxpcms.module.hosting.aws_s3_bucket_policy.hosting
terraform state mv aws_s3_bucket.hosting module.qxpcms.module.hosting.aws_s3_bucket.hosting
terraform state mv aws_cloudfront_distribution.site module.qxpcms.module.hosting.aws_cloudfront_distribution.site
terraform state mv aws_cloudfront_cache_policy.default module.qxpcms.module.hosting.aws_cloudfront_cache_policy.default
terraform state mv aws_resourcegroups_group.site module.qxpcms.aws_resourcegroups_group.site
terraform state mv module.qxpcms.module.site-generator.aws_cloudwatch_log_group.build-site-generator module.qxpcms.module.cms-server.aws_cloudwatch_log_group.build-site-generator
terraform state mv module.qxpcms.module.site-deployment.aws_cloudwatch_log_group.ecs-cms-site-generator module.qxpcms.module.cms-server.aws_cloudwatch_log_group.site-deployment

```

Optional:
```
terraform state mv aws_acm_certificate.main module.qxpcms.module.hosting.aws_acm_certificate.site[0]

terraform state mv aws_cloudfront_function.redirect-naked-to-www module.qxpcms.module.hosting.aws_cloudfront_function.redirect-naked-to-www[0]
```
