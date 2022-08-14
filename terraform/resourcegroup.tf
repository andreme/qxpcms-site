resource "aws_resourcegroups_group" "site" {
  name = "${var.project_name}-site"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "Project",
      "Values": ["${var.project_name}"]
    }
  ]
}
JSON
  }
}
