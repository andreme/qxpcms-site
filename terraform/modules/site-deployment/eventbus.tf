resource "aws_iam_role" "site-deployment" {
  name = "${var.project_name}-site-deployment"

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}

resource "aws_iam_role_policy" "site-deployment-run-task" {
  name = "run_task"
  role = aws_iam_role.site-deployment.id

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": [
              "${aws_iam_role.cms-site-generator-ecs-execution.arn}",
              "${aws_iam_role.cms-site-generator-ecs-container.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.cms-site-generator.arn, "/:\\d+$/", ":*")}"
        }
    ]
}
DOC
}

resource "aws_cloudwatch_event_target" "deploy-site" {
  target_id = "${var.project_name}-start-site-deployment"
  arn = aws_ecs_cluster.main.arn
  rule = aws_cloudwatch_event_rule.start-site-deployment.name
  role_arn = aws_iam_role.site-deployment.arn

  event_bus_name = var.event_bus

  ecs_target {
    launch_type = "FARGATE"
    task_count = 1
    task_definition_arn = aws_ecs_task_definition.cms-site-generator.arn

    network_configuration {
      subnets = [
        var.subnet,
      ]
      assign_public_ip = true
      security_groups = [
        var.security_group,
      ]
    }
  }

  input_transformer {
    input_paths = {
      site_deployment_id = "$.detail.siteDeploymentId"
    }

    input_template = <<TEMPLATE
{
  "containerOverrides": [
    {
      "name": "generator",
      "environment": [
        { "name": "SITE_DEPLOYMENT_ID", "value": "<site_deployment_id>" }
      ]
    }
  ]
}
TEMPLATE
  }
}

resource "aws_cloudwatch_event_rule" "start-site-deployment" {
  name = "${var.project_name}-start-site-deployment"

  event_bus_name = var.event_bus

  event_pattern = <<EOF
{
  "source": [
    "qxpcms.${var.project_name}"
  ],
  "detail-type": [
    "cms.start-site-deployment"
  ]
}
EOF
}
