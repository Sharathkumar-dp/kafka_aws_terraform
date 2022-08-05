output "vpc_id" {
  value = aws_vpc.kafka_vpc.id
}

output "elastic_ip" {
  value = aws_eip.kafka_nat_eip.id
}

output "instance_public_ips" {
  value = aws_instance.kafka_pub_instance.*.public_ip
}

output "instance_public_dns" {
  value = aws_instance.kafka_pub_instance.*.public_dns
}

output "instance-private_ips" {
  value = aws_instance.kafka_pri_instance.*.private_ip
}
