locals {
  name           = format("%s-%s", var.resource_name, "vpc")
  short_region   = "use1"
  resource_name  = format("%s-%s", var.resource_name, local.short_region)
  ssm_prefix     = format("/%s/%s/%s", var.resource_name, local.short_region, "vpc")
  ssm_subnet_ids = format("/%s/%s/%s", var.resource_name, local.short_region, "subnets")
  ssm_gateway_ids = format("/%s/%s/%s", var.resource_name, local.short_region, "gateway_ids")
  ssm_sg_ids = format("/%s/%s/%s", var.resource_name, local.short_region, "sg_ids")
  ssm_rtb_ids = format("/%s/%s/%s", var.resource_name, local.short_region, "rtb_ids")
}

locals {
  private_subnet_ids = concat(aws_subnet.private1[*].id, aws_subnet.private2[*].id)
}

locals {
  public_subnet_ids = concat(aws_subnet.public1[*].id, aws_subnet.public2[*].id)
}