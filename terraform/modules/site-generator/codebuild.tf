resource "aws_iam_role" "build-site-generator" {
  name = "${var.project_name}-codebuild-site-generator"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
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
resource "aws_iam_role_policy" "build-site-generator" {
  name = "access"
  role = aws_iam_role.build-site-generator.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "${var.log_group_arn}:*",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
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
                "${var.site_repository_arn}"
            ],
            "Action": [
                "codecommit:GitPull"
            ]
        },
        {
          "Action": [
            "ecr:GetAuthorizationToken"
          ],
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": [
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages"
          ],
          "Resource": "${aws_ecr_repository.main.arn}",
          "Effect": "Allow"
        }
    ]
}
POLICY
}

resource "aws_codebuild_project" "build-site-generator" {
  name = "${var.project_name}-site-generator"
  build_timeout = "10"
  service_role = aws_iam_role.build-site-generator.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.main.name
    }

    environment_variable {
      name = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name = "PROJECT_NAME"
      value = var.project_name
    }
  }

  source_version = "refs/heads/build"

  source {
    type = "CODECOMMIT"
    git_clone_depth = 1
    location = var.site_git_url

    buildspec = templatefile("${path.module}/codebuild-buildspec.yml", {handler: "TODO Dockerfile?"/*replace(file("${path.module}/codebuild-site-generator-handler.js"), "\n", " ")*/})

    git_submodules_config {
      fetch_submodules = false
    }
  }

  tags = {
    Project = var.project_name
  }

  logs_config {
    cloudwatch_logs {
      group_name = var.log_group
    }
  }
}


resource "aws_iam_role" "trigger-build-site-generator" {
  name = "${var.project_name}-trigger-build-build"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
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

resource "aws_iam_role_policy" "trigger-build-site-generator" {
  name = "access-codebuild"
  role = aws_iam_role.trigger-build-site-generator.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:StartBuild"
            ],
            "Resource": [
                "${aws_codebuild_project.build-site-generator.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_cloudwatch_event_rule" "site-generator-trigger-build" {
  name = "${var.project_name}-build-trigger-build"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [
    "${var.site_repository_arn}"
  ],
  "detail": {
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ],
    "referenceType": [
      "branch"
    ],
    "referenceName": [
      "build"
    ]
  }
}
PATTERN

  tags = {
    Project = var.project_name
  }

}

resource "aws_cloudwatch_event_target" "site-generator-trigger-build" {
  rule = aws_cloudwatch_event_rule.site-generator-trigger-build.name
  arn = aws_codebuild_project.build-site-generator.arn
  role_arn = aws_iam_role.trigger-build-site-generator.arn
}
