##### RESOURCES #####

##### VPC #####

resource "aws_vpc" "kafka_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "Kafka_VPC"
  }
}

##### SUBNETS #####

resource "aws_subnet" "kafka_pub_subnet" {
  vpc_id                  = aws_vpc.kafka_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "Kafka_Public_Subnet"
  }
}

resource "aws_subnet" "kafka_pri_subnet" {
  vpc_id     = aws_vpc.kafka_vpc.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = "Kafka_Private_Subnet"
  }
}

##### IGW and NAT #####

resource "aws_internet_gateway" "kafka_igw" {
  vpc_id = aws_vpc.kafka_vpc.id
  tags = {
    Name = "kafka_igw"
  }
}

resource "aws_eip" "kafka_nat_eip" {
  vpc = true
  tags = {
    Name = "kafka_nat_eip"
  }
}

resource "aws_nat_gateway" "kafka_nat" {
  subnet_id     = aws_subnet.kafka_pub_subnet.id
  allocation_id = aws_eip.kafka_nat_eip.id
  tags = {
    Name = "kafka_nat"
  }
}

##### ROUTE TABLE #####

resource "aws_route_table" "kafka_pub_rt" {
  vpc_id = aws_vpc.kafka_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kafka_igw.id
  }
  tags = {
    Name = "kafka_pub_rt"
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.kafka_pub_subnet.id
  route_table_id = aws_route_table.kafka_pub_rt.id
}


resource "aws_route_table" "kafka_pri_rt" {
  vpc_id = aws_vpc.kafka_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.kafka_nat.id
  }
  tags = {
    Name = "kafka_pri_rt"
  }
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.kafka_pri_subnet.id
  route_table_id = aws_route_table.kafka_pri_rt.id
}

##### SECURITY GROUP #####

resource "aws_security_group" "kafka_sg" {
  name        = "kafka_sg"
  description = "Accept incoming connections."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }
  ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Kafka Connect REST API"
  }
  ingress {
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "KSQL Server REST API"
  }
  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "REST Proxy"
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Schema Registry REST API"
  }
  ingress {
    from_port   = 1099
    to_port     = 1099
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "JMX"
  }
  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ZooKeeper"
  }
  ingress {
    from_port   = 2888
    to_port     = 2888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ZooKeeper"
  }
  ingress {
    from_port   = 3888
    to_port     = 3888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ZooKeeper"
  }
  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Kafka Brokers"
  }
  ingress {
    from_port   = 9021
    to_port     = 9021
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Control Center"
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.kafka_vpc.id

  tags = {
    Name = "kafka_cluster_sg"
  }
}

#### END ####
