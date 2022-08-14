
resource "aws_dynamodb_table" "list" {
  name = "${var.project_name}-list"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "listID"
  range_key = "id"

  attribute {
    name = "listID"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "updated"
    type = "S"
  }

  tags = {
    Project = var.project_name
  }

  local_secondary_index {
    name = "UpdatedIndex"
    projection_type = "KEYS_ONLY"
    range_key = "updated"
  }
}
