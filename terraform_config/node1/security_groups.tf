resource "aws_security_group" "allow_req_ports_node1" {
  name        = "allow_req_ports_node1"
  description = "Allow needed ports like ssh, http, https etc"

  #  dynamic "ingress" {
  #    for_each = var.ports
  #    iterator = port
  #    content {
  #      description = "TLS from VPC"
  #      from_port   = port.value
  #      to_port     = port.value
  #      protocol    = "tcp"
  #      cidr_blocks = ["0.0.0.0/0"]
  #    }
  #  }

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
  value = aws_security_group.allow_req_ports_node1.id
}
