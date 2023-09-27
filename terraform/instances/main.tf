data "aws_vpc" "main_vpc" {
  filter {
    name   = "tag:Name"
    values = ["lab-vpc"]
  }
}

data "aws_subnet" "snet_public" {
  filter {
    name   = "tag:Name"
    values = ["snet-public-*"]
  }
}

data "aws_iam_role" "Eksctl_Role" {
  name = "Eksctl_Role"
}

resource "aws_iam_instance_profile" "Eksctl_profile" {
  name = "Eksctl_profile"
  role = data.aws_iam_role.Eksctl_Role.name
}

resource "aws_instance" "jenkins_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnet.snet_public.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo yum update -y
              sudo yum install wget
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              sudo yum install jenkins -y
              sudo yum install git -y
              sudo dnf install java-11-amazon-corretto -y
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              sudo yum upgrade -y
  EOF

  tags = {
    Name = var.instance_name
  }
}

resource "aws_instance" "ansible_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnet.snet_public.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo yum update -y
              sudo dnf install python3-pip
              sudo pip install ansible -y
              sudo yum install docker -y
              sudo useradd ansible-admin
              sudo mkdir /opt/docker
              sudo chown ansible-admin:ansible-admin /opt/docker
              sudo usermod -a -G docker ansible-admin
              sudo systemctl enable docker
              sudo systemctl start docker
              sudo yum upgrade -y
  EOF

  tags = {
    Name = "AnsibleServer"
  }
}

resource "aws_instance" "k8s_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnet.snet_public.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.Eksctl_profile.name

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo yum update -y
              sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.5/2023-09-14/bin/linux/amd64/kubectl
              sudo chmod +x kubectl
              sudo sudo mv kubectl /usr/local/bin
              sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
              sudo mv /tmp/eksctl /usr/local/bin
              sudo yum upgrade -y
  EOF

  tags = {
    Name = "K8sServer"
  }
}

resource "aws_security_group" "jenkins_sg" {
  description = "Jenkins CI/CD Pipeline SG"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  ingress {
    description = ""
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
  }
  name   = "CI_CD_Pipeline_SG"
  vpc_id = data.aws_vpc.main_vpc.id
}
