resource "aws_vpc" "prueba" {
    cidr_block = "1.2.3.0/16"
    tags = {
        Name = "prueba"
    }
}