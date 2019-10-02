# Lookup the current Ubuntu OS
# In a production environment you probably want to
# hardcode the AMI ID, to prevent upgrading to a
# new and potentially broken release.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = [
    "099720109477"]
  # Canonical

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }
}
