/* packer用 */
resource "aws_codebuild_project" "packer" {
  name          = "${var.packer}"
  description   = "codebuild for packer"
  build_timeout = "5"
  service_role  = "${aws_iam_role.packer.arn}"

  # packerはamiとしてartifactが出るので、不要を設定
  artifacts {
    type = "NO_ARTIFACTS"
  }

  # codebuildにはubuntu-baseの一番小さいサイズを使う
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ubuntu-base:14.04-1.6.0"
    type         = "LINUX_CONTAINER"
  }

  # s3にpackerのデータを保管し、buildspec.ymlを読み込んでbuildさせる
  source {
    type     = "S3"
    location = "${aws_s3_bucket.packer.bucket}/images/"
  }

  # packerはsshを利用するため、同じVPC内とSGで通信させる
  vpc_config {
    vpc_id = "${data.aws_vpc.xxxxxx.id}"

    subnets = [
      # 適宜変更してね
      "${data.aws_subnet.private-subnet-1a.id}",
    ]

    security_group_ids = [
      "${aws_security_group.packer.id}",
    ]
  }
}
