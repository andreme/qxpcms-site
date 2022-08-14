resource aws_codecommit_repository "site" {
  repository_name = "${var.project_name}-site"

  tags = {
    Project = var.project_name
  }

}
