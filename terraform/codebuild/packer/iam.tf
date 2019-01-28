/* CodeBuildでpackerを使ったamiを作成するためのiam */
resource "aws_iam_role" "packer" {
  name               = "${var.packer}"
  assume_role_policy = "${data.aws_iam_policy_document.packer_assume.json}"
}

data "aws_iam_policy_document" "packer_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy" "packer" {
  name = "${var.packer}"
  role = "${aws_iam_role.packer.id}"

  policy = "${data.aws_iam_policy_document.packer.json}"
}

data "aws_iam_policy_document" "packer" {
  # ログ周り
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.self.account_id}:log-group:/aws/codebuild/*",
    ]
  }

  # s3周り
  statement {
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.packer.arn}",
      "${aws_s3_bucket.packer.arn}/*",
    ]
  }

  # packerでamiを作成するので、ec2周りが必要
  # ref: https://www.packer.io/docs/builders/amazon.html#iam-task-or-instance-role
  statement {
    effect = "Allow"

    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateKeypair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteKeyPair",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:GetPasswordData",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:RegisterImage",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "iam:PassRole",
    ]

    resources = [
      "*",
    ]
  }
}

/* インスタンスprofile */
resource "aws_iam_instance_profile" "packer-instance" {
  name = "packer-instance"
  role = "${aws_iam_role.packer-instance.name}"
}

resource "aws_iam_role" "packer-instance" {
  name = "packer-instance"
  path = "/codebuild/packer-instance/"

  assume_role_policy = "${data.aws_iam_policy_document.packer-instance_assume.json}"
}

data "aws_iam_policy_document" "packer-instance_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy" "packer-instance" {
  name = "packer-instance"
  role = "${aws_iam_role.packer-instance.id}"

  policy = "${data.aws_iam_policy_document.packer-instance.json}"
}

data "aws_iam_policy_document" "packer-instance" {
  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      "*",
    ]
  }
}
