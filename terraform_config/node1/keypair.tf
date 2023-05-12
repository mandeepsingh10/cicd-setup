#creating ssh-key
resource "aws_key_pair" "terra-key" {
  key_name   = "node-key"
  public_key = file("${path.module}/publickey.pub")
}

output "keyname" {
  value = aws_key_pair.terra-key.key_name
}

