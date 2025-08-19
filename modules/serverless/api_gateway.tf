resource "aws_apigatewayv2_api" "main" {
  name          = "${local.name_prefix}-api"
  protocol_type = "HTTP"
  description   = "API Gateway for ${var.project_name}"
  tags          = local.tags
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = local.stage_name
  auto_deploy = true
  tags        = local.tags

  default_route_settings {
    throttling_rate_limit  = 10
    throttling_burst_limit = 50
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode(
      {
        sourceIp                = "$context.identity.sourceIp",
        httpMethod              = "$context.httpMethod",
        authorizerError         = "$context.authorizer.error",
        integrationErrorMessage = "$context.integrationErrorMessage",
        requestId               = "$context.requestId",
        requestTime             = "$context.requestTime",
        path                    = "$context.path",
        resourcePath            = "$context.resourcePath",
        responseLength          = "$context.responseLength",
        routeKey                = "$context.routeKey",
        status                  = "$context.status",
        errMsg                  = "$context.error.message",
        errType                 = "$context.error.responseType",
        intError                = "$context.integration.error",
        intIntStatus            = "$context.integration.integrationStatus",
        intLat                  = "$context.integration.latency",
        intReqID                = "$context.integration.requestId",
        intStatus               = "$context.integration.status",
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.api.invoke_arn
  description        = "Lambda integration for ${var.project_name} API"
}

resource "aws_apigatewayv2_route" "routes" {
  for_each  = var.routes
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "${each.value.method} ${each.value.path}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
