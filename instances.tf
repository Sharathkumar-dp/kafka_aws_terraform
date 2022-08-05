####  KEY-PAIR ####

resource "tls_private_key" "kafka_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kafka_pub_key" {
  key_name   = var.key_name
  public_key = tls_private_key.kafka_ssh.public_key_openssh
}

resource "local_file" "kafka_pri-key" {
  content  = tls_private_key.kafka_ssh.private_key_pem
  filename = "kafka_pri_key"
}

#### INSTANCES ####


resource "aws_instance" "kafka_pub_instance" {
  count                       = var.pub_instance_count
  ami                         = var.aws_ami
  instance_type               = var.aws_instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = ["${aws_security_group.kafka_sg.id}"]
  subnet_id                   = aws_subnet.kafka_pub_subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "kafka-pub-${var.instance_prefix}-${format("%02d", count.index + 1)}"
  }
}

resource "aws_instance" "kafka_pri_instance" {
  count                  = var.pri_instance_count
  ami                    = var.aws_ami
  instance_type          = var.aws_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.kafka_sg.id}"]
  subnet_id              = aws_subnet.kafka_pri_subnet.id
  tags = {
    Name = "kafka-pri-${var.instance_prefix}-${format("%02d", count.index + 1)}"
  }
}

#### END ####
