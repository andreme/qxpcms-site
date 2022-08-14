resource "aws_cloudwatch_event_bus" "events" {
  name = "${var.project_name}-events"
}
