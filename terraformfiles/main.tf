resource "aws_instance" "test-server" {
  ami = "ami-0a9098891d675c629"
  instance_type = "t3.medium"
  key_name = "zomoto"
  vpc_security_group_ids = ["sg-01d81bc7936b24bc2"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./zomoto.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/zomota/terraformfiles/ansiblebook.yml"
     }
  }
