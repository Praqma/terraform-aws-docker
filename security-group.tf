resource "aws_security_group" "ssh_from_other_ec2_instances" {
  vpc_id = "${aws_vpc.main.id}"
}

# Retrieve current environment IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group_rule" "ssh_from_other_ec2_instances" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  security_group_id = aws_security_group.ssh_from_other_ec2_instances.id
  source_security_group_id = aws_security_group.ssh_from_other_ec2_instances.id
}
resource "aws_security_group_rule" "ssh_from_my_computer" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [
    "${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.ssh_from_other_ec2_instances.id
}

/* Default security group */
resource "aws_security_group" "allow_http_traffic" {
  name = "${local.stack_name}-http-in"
  description = "Allow all HTTP traffic in and out on port 80"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
    self = true
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
    self = true
  }

  tags = {
    Name = "${local.stack_name}-http"
  }
}

