resource "aws_iam_role" "lambda_execution_role" {
  name = "${local.name_prefix}-lambda-execution-role"
  tags = local.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${local.name_prefix}-lambda-logging"
  description = "Policy for Lambda function logging"
  policy      = data.aws_iam_policy_document.lambda_logging.json
  tags        = local.tags
}

resource "aws_iam_policy" "dynamodb_policy" {
  count       = var.create_db ? 1 : 0
  name        = "${local.name_prefix}-dynamodb-policy"
  description = "Policy to access DynamoDB table for ${var.project_name}"
  tags        = local.tags
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = aws_dynamodb_table.main[count.index].arn
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_policy" {
  count       = var.create_bucket ? 1 : 0
  name        = "${local.name_prefix}-lambda-s3-policy"
  description = "Policy to access S3 bucket for ${var.project_name}"
  tags        = local.tags
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.s3_bucket[count.index].bucket_arn,
          "${module.s3_bucket[count.index].bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attachment" {
  count      = var.create_bucket ? 1 : 0
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy[count.index].arn
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attachment" {
  count      = var.create_db ? 1 : 0
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_policy[count.index].arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
