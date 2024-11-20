
resource "aws_lambda_function" "server" {
  function_name = "${var.project_name}-server"
  role = aws_iam_role.cms-server.arn
  handler = "src/lambda.handler"
  runtime = "nodejs16.x"
  timeout = 40
  memory_size = 256

  s3_bucket = "qxp-cms-app-repo"
  s3_key = "prod/server.zip"

  environment {
    variables = {
      NODE_ENV = "production"
      TZ = var.tz
      COGNITO_USER_POOL_ID = aws_cognito_user_pool.cms.id
      PROJECT_NAME = var.project_name
      BABEL_DISABLE_CACHE = 1
      COGNITO_USER_POOL_WEB_CLIENT_ID = aws_cognito_user_pool_client.cms.id
      API_KEY = var.api_key
      FILE_BUCKET = aws_s3_bucket.cms-files.bucket
      QXP_CMS_PROJECT_NAME = var.project_name
    }
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
    ]
  }

  tags = {
    Project = var.project_name
  }

}

resource "aws_iam_role" "cms-server" {
  name = "${var.project_name}-cms-server"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "server-AWSLambdaBasicExecutionRole" {
  role = aws_iam_role.cms-server.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "cms-server-access" {
  name = "access"
  role = aws_iam_role.cms-server.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "${aws_dynamodb_table.cms.arn}",
                "${aws_dynamodb_table.cms.arn}/*",
                "${aws_dynamodb_table.list.arn}",
                "${aws_dynamodb_table.list.arn}/*"
            ],
            "Action": [
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem"
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
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.cms-files.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:FilterLogEvents",
                "logs:GetLogEvents"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.qxpcms-system.arn}:*",
                "${aws_cloudwatch_log_group.site-deployment.arn}:*",
                "${aws_cloudwatch_log_group.build-site-generator.arn}:*"
            ]
        }
    ]
}
POLICY
}

resource "aws_cloudwatch_log_group" "server" {
  name = "/aws/lambda/${aws_lambda_function.server.function_name}"

  retention_in_days = 90

  tags = {
    Project = var.project_name
  }

}
