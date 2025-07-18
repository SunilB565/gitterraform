output "vpc_id"            { value = aws_vpc.main.id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "lb_sg_id"          { value = aws_security_group.lb.id }
output "service_sg_id"     { value = aws_security_group.service.id }

