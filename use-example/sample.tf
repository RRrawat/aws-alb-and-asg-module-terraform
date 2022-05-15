module "alb_with_asg" {
  source = "../"
  region = var.region
  vpc_id = var.vpc_id 
  create_lc = var.create_lc
  instance_type = var.instance_type
  key_name = var.key_name 
  ingress = var.ingress
  create_asg = var.create_asg
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity 
  wait_for_capacity_timeout = var.wait_for_capacity_timeout 
  health_check_type = var.health_check_type
  ingress_alb = var.ingress_alb =
  
}
