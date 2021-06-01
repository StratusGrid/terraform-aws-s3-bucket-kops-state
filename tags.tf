locals {
  common_tags = merge(var.input_tags, {
    "ModuleSourceRepo" = "github.com/StratusGrid/terraform-aws-s3-bucket-kops-state"
  })
}