module "cron_job" {
  for_each             = { for job in var.cron_jobs : job.name => job }
  source               = "../cron_job"
  project_name         = "${var.project_name}-${each.value.name}"
  lambda_function_arn  = aws_lambda_function.api.arn
  lambda_function_name = aws_lambda_function.api.function_name
  cron                 = each.value.cron
  path                 = each.value.path
}
