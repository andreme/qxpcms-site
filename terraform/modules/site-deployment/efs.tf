data "aws_subnet" "site-deployment" {
  id = var.subnet
}

resource "aws_efs_file_system" "cms-site-generator" {

  availability_zone_name = data.aws_subnet.site-deployment.availability_zone

  tags = {
    Project = var.project_name
    Name = var.project_name
  }
}

resource "aws_efs_access_point" "cms-site-generator-cache" {
  file_system_id = aws_efs_file_system.cms-site-generator.id

  root_directory {
    creation_info {
      owner_gid = 0
      owner_uid = 0
      permissions = "666"
    }
    path = "/site/cache"
  }

  tags = {
    Project = var.project_name
    Name = "${var.project_name}-cache"
  }
}

resource "aws_efs_access_point" "cms-site-generator-public" {
  file_system_id = aws_efs_file_system.cms-site-generator.id

  root_directory {
    creation_info {
      owner_gid = 0
      owner_uid = 0
      permissions = "666"
    }
    path = "/site/public"
  }

  tags = {
    Project = var.project_name
    Name = "${var.project_name}-public"
  }
}

resource "aws_efs_mount_target" "cms-site-generator" {
  file_system_id = aws_efs_file_system.cms-site-generator.id
  subnet_id = data.aws_subnet.site-deployment.id
  security_groups = [var.security_group]
}
