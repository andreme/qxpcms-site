resource "aws_apigatewayv2_api" "cms" {
  name = "${var.project_name}-cms"
  protocol_type = "HTTP"

  tags = {
    Project = var.project_name
  }

}

resource "aws_apigatewayv2_integration" "cms" {
  api_id = aws_apigatewayv2_api.cms.id
  integration_type = "AWS_PROXY"

  description = "CMS"
  integration_uri = aws_lambda_function.server.arn
  payload_format_version = "1.0"
}

resource "aws_lambda_permission" "cms" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.server.arn
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.cms.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "cms" {
  api_id = aws_apigatewayv2_api.cms.id
  route_key = "$default"
  target = "integrations/${aws_apigatewayv2_integration.cms.id}"
}

resource "aws_apigatewayv2_stage" "cms-default" {
  api_id = aws_apigatewayv2_api.cms.id
  name = "$default"
  auto_deploy = true
}
