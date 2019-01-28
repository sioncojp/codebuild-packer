/* packerはsshを利用するため、sg内でのsshを許可する */
resource "aws_security_group" "packer" {
  name        = "${var.packer}"
  description = "${var.packer}"
  vpc_id      = "${data.aws_vpc.xxxxxx.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }

  tags {
    "Name" = "${var.packer}"
  }
}
