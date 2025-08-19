resource "aws_cloudwatch_event_rule" "this" {
  name                = "${var.project_name}-cron-job"
  description         = "Trigger cron job"
  schedule_expression = var.cron
}

resource "aws_cloudwatch_event_target" "this" {
  rule = aws_cloudwatch_event_rule.this.name
  arn  = var.lambda_function_arn

  input_transformer {
    input_template = <<EOF
{
  "resource": "${var.path}"
}
    EOF
  }
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}
