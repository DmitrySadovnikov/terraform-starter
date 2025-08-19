module "s3_bucket" {
  count        = var.create_bucket ? 1 : 0
  source       = "../bucket"
  project_name = var.project_name
  tags         = local.tags
}
