module "domain" {
  count                     = var.domain_name != "" ? 1 : 0
  source                    = "../domain"
  domain_name               = var.domain_name
  tags                      = var.tags
  aws_apigatewayv2_api_id   = aws_apigatewayv2_api.main.id
  aws_apigatewayv2_stage_id = aws_apigatewayv2_stage.main.id
}
