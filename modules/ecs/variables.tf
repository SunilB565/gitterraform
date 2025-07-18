variable "env" {}
variable "execution_role_arn" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "lb_sg_id" {}
variable "service_sg_id" {}
variable "app1_image" {}
variable "app2_image" {}

