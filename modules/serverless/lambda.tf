locals {
  name_prefix = var.project_name
  stage_name  = "api"

  tags = merge(var.tags, {
    Project   = var.project_name
    Component = "serverless-api"
  })
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_dir  = "${path.root}/code"
  output_path = "${path.root}/tmp/lambda-${var.project_name}.zip"
}

resource "aws_lambda_function" "api" {
  function_name    = "${var.project_name}-api"
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = data.archive_file.lambda_code.output_path
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.lambda_code.output_base64sha256
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory_size
  tags             = local.tags

  environment {
    variables = merge(
      var.envs,
      {
        PROJECT_NAME = var.project_name
        BASE_URL     = var.domain_name != "" ? "https://${var.domain_name}/" : "https://${aws_apigatewayv2_api.main.id}.execute-api.${var.region}.amazonaws.com/${local.stage_name}/"
      },
      var.create_bucket ? {
        BUCKET_NAME = module.s3_bucket[0].bucket_name
      } : {},
      var.create_db ? {
        TABLE_NAME = aws_dynamodb_table.main[0].name
      } : {}
    )
  }
}
