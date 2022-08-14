data "aws_iam_policy_document" "log-system-event" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.qxpcms-system.arn}:*"
    ]

    principals {
      identifiers = ["events.amazonaws.com", "delivery.logs.amazonaws.com"]
      type = "Service"
    }

#    TODO add condition - does this allow public access?
#    condition {
#      test = "ArnEquals"
#      values = [aws_cloudwatch_event_rule.log-system-event.arn]
#      variable = "aws:SourceArn"
#    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "log-system-event" {
  policy_document = data.aws_iam_policy_document.log-system-event.json
  policy_name = "${var.project_name}-log-system-event"
}

resource "aws_cloudwatch_event_target" "log-system-event" {
  target_id = "${var.project_name}-log-system-event"
  arn = aws_cloudwatch_log_group.qxpcms-system.arn
  rule = aws_cloudwatch_event_rule.log-system-event.name

  event_bus_name = var.event_bus
}

resource "aws_cloudwatch_event_rule" "log-system-event" {
  name = "${var.project_name}-log-system-event"

  event_bus_name = var.event_bus

  event_pattern = <<EOF
{
  "source": [
    "qxpcms.${var.project_name}"
  ],
  "detail-type": [
    "cms.log.system"
  ]
}
EOF
}
