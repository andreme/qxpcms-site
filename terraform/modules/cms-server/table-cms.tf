resource "aws_dynamodb_table" "cms" {
  name = "${var.project_name}-cms"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "type"
  range_key = "name"

  attribute {
    name = "type"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  tags = {
    Project = var.project_name
  }

}
