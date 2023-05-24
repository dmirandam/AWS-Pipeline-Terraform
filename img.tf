variable "user_d" {
  type        = string
  description = "User data script for EC2 instance"
  default = <<-EOT
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              docker pull maherreramu/ag-front
              docker run -d -p 80:80 maherreramu/ag-front
              EOT
}


resource "aws_instance" "instance" {
  ami                     = "ami-0a695f0d95cefc163"
  instance_type           = "t2.micro"
  user_data               = var.user_d
  
}
