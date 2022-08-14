
resource "aws_cloudwatch_log_group" "qxpcms-system" {
  name = "/qxpcms/${var.project_name}/system"
  retention_in_days = 180

  tags = {
    Project = var.project_name
  }

}

resource "aws_cloudwatch_log_group" "build-site-generator" {
  name = "/qxpcms/${var.project_name}/build-site-generator"
  retention_in_days = 60

  tags = {
    Project = var.project_name
  }

}

resource "aws_cloudwatch_log_group" "site-deployment" {
  name = "/qxpcms/${var.project_name}/deployment"
  retention_in_days = 60

  tags = {
    Project = var.project_name
  }

}
