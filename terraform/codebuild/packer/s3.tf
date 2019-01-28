/* codebuildで使うためのファイルを保管 */
resource "aws_s3_bucket" "packer" {
  bucket = "${var.packer}"
  acl    = "private"
}
