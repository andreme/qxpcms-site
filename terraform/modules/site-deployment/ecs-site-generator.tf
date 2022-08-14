
resource "aws_ecs_task_definition" "cms-site-generator" {
  family = "${var.project_name}-cms-site-generator"
  execution_role_arn = aws_iam_role.cms-site-generator-ecs-execution.arn
  task_role_arn = aws_iam_role.cms-site-generator-ecs-container.arn
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu = 1024
  memory = 2048
  container_definitions = <<DEFINITION
[
  {
    "cpu": 1024,
    "essential": true,
    "image": "${var.site_generator_repository_url}:latest",
    "environment": [
        {"name": "CMS_URL", "value": "${var.cms_url}"},
        {"name": "CMS_API_KEY", "value": "${var.cms_server_api_key}"},
        {"name": "SITE_BUCKET", "value": "${var.hosting_bucket}"},
        {"name": "PROJECT_NAME", "value": "${var.project_name}"},
        {"name": "NO_COLOR", "value": "1"},
        {"name": "CI", "value": "true"}
    ],
    "memory": 2048,
    "memoryReservation": 2048,
    "name": "generator",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.log_group}",
          "awslogs-region": "${data.aws_region.current.name}",
          "awslogs-stream-prefix": "runtime"
        }
    },
    "mountPoints": [
      {
        "containerPath": "/app/.cache",
        "sourceVolume": "cache"
      },
      {
        "containerPath": "/app/public",
        "sourceVolume": "public"
      }
    ]
  }
]
DEFINITION

  volume {
    name = "cache"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.cms-site-generator.id
      transit_encryption = "ENABLED"
      transit_encryption_port = 2049
      authorization_config {
        access_point_id = aws_efs_access_point.cms-site-generator-cache.id
        iam = "ENABLED"
      }
    }
  }

  volume {
    name = "public"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.cms-site-generator.id
      transit_encryption = "ENABLED"
      transit_encryption_port = 2050
      authorization_config {
        access_point_id = aws_efs_access_point.cms-site-generator-public.id
        iam = "ENABLED"
      }
    }
  }

  tags = {
    Project = var.project_name
  }

}

resource "aws_iam_role" "cms-site-generator-ecs-execution" {
  name = "${var.project_name}-cms-site-generator-ecs-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Project = var.project_name
  }

}

// TODO reduce permissions
resource "aws_iam_role_policy" "cms-site-generator-ecs-execution" {
  name = "${var.project_name}-cms-site-generator-ecs-execution"
  role = aws_iam_role.cms-site-generator-ecs-execution.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "${var.log_group_arn}:*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "cms-site-generator-ecs-container" {
  name = "${var.project_name}-cms-site-generator-ecs-container"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Project = var.project_name
  }

}

resource "aws_iam_role_policy" "cms-site-generator-ecs-container" {
  name = "${var.project_name}-cms-site-generator-ecs-container"
  role = aws_iam_role.cms-site-generator-ecs-container.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AccessBucket",
        "Effect": "Allow",
        "Action": [
            "s3:HeadBucket",
            "s3:GetBucketLocation",
            "s3:PutBucketWebsite",
            "s3:ListBucket"
        ],
        "Resource": [
            "${var.hosting_bucket_arn}"
        ]
    },
    {
        "Sid": "AccessObjects",
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:PutObject"
        ],
        "Resource": [
            "${var.hosting_bucket_arn}/*"
        ]
    },
    {
        "Effect": "Allow",
        "Resource": [
            "${var.event_bus_arn}"
        ],
        "Action": [
            "events:PutEvents"
        ]
    },
    {
        "Effect": "Allow",
        "Resource": [
            "${aws_efs_file_system.cms-site-generator.arn}"
        ],
        "Action": [
            "elasticfilesystem:ClientMount",
            "elasticfilesystem:ClientRootAccess",
            "elasticfilesystem:ClientWrite"
        ]
    }
  ]
}
EOF
}
