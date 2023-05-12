resource "aws_security_group" "allow_req_ports_master" {
  name        = "allow_req_ports_master"
  description = "Allow needed ports like ssh, http, https etc"


  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
output "securityGroupDetails" {
  value = aws_security_group.allow_req_ports_master.id
}

