locals {
  tags = merge(var.tags, {
    "environment" = var.environment
    "managed_by"  = "terraform"
  })
}