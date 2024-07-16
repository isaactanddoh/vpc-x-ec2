# Create Application Load Balancer
resource "aws_lb" "alb" {
  load_balancer_type = "application"
  internal           = false
  name = "${var.resource_name}-${var.alb_name}"
  subnet_mapping {
    subnet_id     = data.aws_subnet.public1.id
  }
  subnet_mapping {
    subnet_id     = data.aws_subnet.public2.id
  }
  security_groups    = [data.aws_security_group.alb_sg.id]
  depends_on         = [aws_lb_target_group.app-tg]
  tags = {
    Name = "${var.resource_name}-${var.alb_name}"
  }
}

# Attach a target group to the AL
resource "aws_lb_target_group" "app-tg" {
  name     = "${var.resource_name}-tg"
  port     = var.tg-port
  vpc_id   = data.aws_vpc.main.id
  protocol = var.tg-protocol
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "alb-listener" {
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
  load_balancer_arn = aws_lb.alb.arn
  port              = var.tg-port
  protocol          = var.tg-protocol
  depends_on        = [aws_lb_target_group.app-tg]
}

# Create launch Template
resource "aws_launch_template" "app-lt" {
  name_prefix   = "${var.resource_name}-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  user_data     = data.template_file.user_data_script.rendered
  vpc_security_group_ids = [data.aws_security_group.asg_sg.id]
  
  block_device_mappings {
    device_name = "/dev/sdf"
    
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }
  iam_instance_profile {
    name = data.aws_iam_role.EC2Role.name
  }
  tags = {
    Name = "${var.resource_name}-lt"
  }
}

# Create Autoscaling Group
resource "aws_autoscaling_group" "app-asg" {
  name                = "${var.resource_name}-App-asg"
  desired_capacity    = var.asg-size
  max_size            = var.asg-size
  min_size            = var.asg-size
  depends_on = [ aws_launch_template.app-lt ]
  target_group_arns   = [aws_lb_target_group.app-tg.arn]
  vpc_zone_identifier = [data.aws_ssm_parameter.private_subnet_ids.value]
  launch_template {
    id = aws_launch_template.app-lt.id
  }
  tag {
    key                 = "Name"
    value               = "${var.resource_name}-server"
    propagate_at_launch = true
  }
}