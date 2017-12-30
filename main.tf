provider "aws" {
  region = "${var.aws_region}"
  version = "~> 1.2"
}

resource "aws_security_group" "esn-vpn" {
  name        = "esn-vpn-sg"
  description = "Security group for EFS Client"
  vpc_id      = "${var.vpc_prod_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["74.109.185.9/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["74.109.185.9/32"]
  }

  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["74.109.185.9/32"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "tcp"
    cidr_blocks = ["74.109.185.9/32"]
  }

  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["10.0.0.0/16"]
  }

  tags {
    Name = "ESN-VPN-SG"
    owner = "alalla"
    env = "prod"
    Builder = "Terraform"
  }
}

resource "aws_instance" "vpn-ec2" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.instance_type}"

  tags {
    Name = "ESN-VPN"
    owner = "alalla"
    env = "dev"
    Builder = "Terraform"
  }

  availability_zone = "${var.az_id}"
  subnet_id         = "${var.subnet_id}"
  key_name          = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.esn-vpn.id}"]
  associate_public_ip_address = true
  
  connection {
    user        = "ubuntu"
    private_key    = "${file(var.ssh_key_filename)}"
    agent       = false
    timeout     = "60s"
  }

  provisioner "remote-exec" {
    inline = [
    sudo apt-get update 
    sudo apt-get upgrade 
    sudo apt-get -y install openvpn easy-rsa libpam-google-authenticator
    sudo gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf
    sudo make-cadir /etc/openvpn/easy-rsa
    cd /etc/openvpn/easy-rsa/
    sudo ln -s openssl-1.0.0.cnf openssl.cnf
    cd
    sudo openssl dhparam 4096 > /etc/openvpn/dh4096.pem
    ]
  }
  
}