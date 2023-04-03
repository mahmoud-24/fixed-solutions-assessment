resource "aws_instance" "pub_ec2" {
  ami                         = "ami-0aa2b7722dc1b5612"
  instance_type               = "t2.micro"
  key_name                    = "iti"
  vpc_security_group_ids      = ["sg-0702a81e85b98290f"]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data= <<-EOF
  #!/bin/bash
  Sudo su
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  apt update
  apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" -y
  apt-cache policy docker-ce
  apt install docker-ce -y
  apt-get install -y openssh-server
  apt-get install openjdk-11-jdk -y
  sudo apt install unzip
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
EOF


  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }
}