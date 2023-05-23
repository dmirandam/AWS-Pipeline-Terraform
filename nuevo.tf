variable "aws_region" {
    description = "AWS Region"
    type = string
    default = "us-east-2"
    nullable = false
    sensitive = false
}
 
variable "instance_type" {
    description = "Instance Type"
    type = string
    default = "t2.micro"
    nullable = false
    sensitive = false
}
 
variable "ami" {
    description = "AMI"
    type = string
    default = "ami-0a695f0d95cefc163"
    nullable = false
    sensitive = false
}

variable "key" {
    description = "SSH Key"
    type = string
    default = "Key_General" 
    nullable = true
    sensitive = true
}

variable "security_group" {
    description = "Security Group"
    type = list(string)
    default = ["sg-092ecf1ac36a65467"]
    nullable = true
    sensitive = false
  
}

variable "name" {
    description = "Name"
    type = string
    default = "IS2"
    nullable = false
    sensitive = false
  
}

variable "user_data" {
    description = "User Data"
    type = string
    default = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    usermod -aG docker ubuntu
    systemctl enable docker
    systemctl start docker
    docker run -d -p 80:80 --name nginx nginx
  EOF
  nullable = true
  sensitive = false
}




resource "aws_instance" "instance" {
  ami          = var.ami
  instance_type = var.instance_type
  key_name = var.key
  user_data = var.user_data
  vpc_security_group_ids = var.security_group
  tags = {
    Name = var.name
  }
}  

