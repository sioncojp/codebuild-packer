variable "packer" {
  default = "codebuild-packer"
}

data "aws_caller_identity" "self" {}