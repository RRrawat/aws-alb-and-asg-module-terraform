/*****************************************************************************************
# Security group for EC2
******************************************************************************************/ 

resource "aws_security_group" "security_group" {
  name        = "EC2_security_group"
  description = "Terraform load balancer security group"
  vpc_id      = var.vpc_id

  
  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  
  
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = module.tags.commontags 
}

/*****************************************************************************************
# EC2 lanch Configuration 
******************************************************************************************/

resource "aws_launch_configuration" "asg-launch-config" {
  count = var.create_lc ? 1 : 0
  name = var.lc_name
  image_id          = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type
  security_groups = [aws_security_group.security_group.id]
  ebs_optimized        = var.ebs_optimized
  key_name             = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  user_data = "${file("update.sh")}"

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      device_name           = ebs_block_device.value.device_name
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      no_device             = lookup(ebs_block_device.value, "no_device", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }
  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


/*****************************************************************************************
# EC2 autoscaling group 
******************************************************************************************/

resource "aws_autoscaling_group" "asg-sample" {
  count = var.create_asg ? 1 : 0
  name        = var.asg_name

  launch_configuration = aws_launch_configuration.asg-launch-config[0].name
  vpc_zone_identifier = data.aws_subnet_ids.subnets.ids
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  capacity_rebalance        = var.capacity_rebalance
  min_elb_capacity          = var.min_elb_capacity
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  default_cooldown          = var.default_cooldown
  protect_from_scale_in     = var.protect_from_scale_in

  target_group_arns         = ["${aws_alb_target_group.group.arn}"]
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  force_delete          = var.force_delete
  termination_policies  = var.termination_policies
  
  tag {
    key                 = "Name"
    value               = "asg-ec2"
    propagate_at_launch = true
  }
}
