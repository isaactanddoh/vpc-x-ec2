resource "aws_ssm_parameter" "vpc_id" {
  name  = "${local.ssm_prefix}/vpc_id"
  type  = "String"
  value = aws_vpc.main.id
  depends_on = [ aws_vpc.main ]
}

resource "aws_ssm_parameter" "vpc_cidr" {
  name  = "${local.ssm_prefix}/vpc_cidr"
  type  = "String"
  value = var.vpc_cidr
}
resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "${local.ssm_subnet_ids}/public_subnet_ids"
  type  = "String"
  value = join(", ", local.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "${local.ssm_subnet_ids}/private_subnet_ids"
  type  = "String"
  value = join(", ", local.private_subnet_ids)
}

resource "aws_ssm_parameter" "ngw_id" {
  name  = "${local.ssm_gateway_ids}/nat_id"
  type  = "String"
  value = aws_nat_gateway.ngw.id
}

resource "aws_ssm_parameter" "eip_id" {
  name  = "${local.ssm_gateway_ids}/eip_id"
  type  = "String"
  value = aws_eip.nat.id
}

resource "aws_ssm_parameter" "igw_id" {
  name  = "${local.ssm_gateway_ids}/igw_id"
  type  = "String"
  value = aws_internet_gateway.igw.id
}

resource "aws_ssm_parameter" "asg_sg_id" {
  name  = "${local.ssm_sg_ids}/asg-sg_id"
  type  = "String"
  value = aws_security_group.autoscaling_sg.id
}

resource "aws_ssm_parameter" "alb_sg_id" {
  name  = "${local.ssm_sg_ids}/alb-sg_id"
  type  = "String"
  value = aws_security_group.load_balancer_sg.id
}

resource "aws_ssm_parameter" "public_rtb_id" {
  name  = "${local.ssm_sg_ids}/public-rtb_id"
  type  = "String"
  value = aws_route_table.public_rtb.id
}

resource "aws_ssm_parameter" "private_rtb_id" {
  name  = "${local.ssm_rtb_ids}/private-rtb_id"
  type  = "String"
  value = aws_route_table.private_rtb.id
}