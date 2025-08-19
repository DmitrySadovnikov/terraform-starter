resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "aws_route53_zone" "this" {
  name = var.domain_name
  tags = var.tags
}

resource "null_resource" "ns_records" {
  provisioner "local-exec" {
    command = "echo 'NS records for ${aws_route53_zone.this.name}:' && echo '${join("\n", aws_route53_zone.this.name_servers)}'"
  }

  triggers = {
    domain_name = aws_route53_zone.this.name
  }

  depends_on = [aws_route53_zone.this]
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.this.zone_id
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.this.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = var.aws_apigatewayv2_api_id
  domain_name = aws_apigatewayv2_domain_name.this.id
  stage       = var.aws_apigatewayv2_stage_id
}

resource "aws_route53_record" "this" {
  name    = aws_apigatewayv2_domain_name.this.domain_name
  type    = "A"
  zone_id = aws_route53_zone.this.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
