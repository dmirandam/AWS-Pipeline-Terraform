resource "aws_instance" "instance" {
  ami          = "ami-0a695f0d95cefc163"
  instance_type = "t2.micro"
  key_name = "Key_General"
  user_data = <<EOT
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
  EOT
  vpc_security_group_ids = ["sg-092ecf1ac36a65467"]
  tags = {
    Name = "is2"
  }
}  
