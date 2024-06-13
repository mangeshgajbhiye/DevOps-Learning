
resource "aws_instance" "ec2" {
    ami = "ami-07d3a50bd29811cd1"
    instance_type = "t2.micro"
    key_name = "my-key1"
    
     connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("./my-key1")
        host = self.public_ip
     }

     provisioner "remote-exec" {
        inline = [
            "sudo yum update -y"
        ]
     }
}

resource "aws_key_pair" "tf" {
    key_name = "my-key1"
    public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "my-key1"
}