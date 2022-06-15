variable "aws_region" {
  description = "AWS region where you wants to deploy the services"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  default = " "
  type = string
}

#****************************************
# Common tags
#************************************

variable "enviroment" {
  type        = string
  description = "Provide environment (DEV/TEST/PRD)"
  default     = "DEV"
}

variable "additional_tags" {
  type        = map(string)
  default     = null
  description = "If user wants to add any other additional tags to resource"
}


 #ingreess value variable 
variable "ingress" {
  description = "It will set the inbound rule of the security group"
  type = map(object({
    port = number
    protocol = string
    cidr_blocks = list(string)

  }))
  default = {
      "22" = {
          port = 22
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]      
      }
      "8080" = {
          port = 8080
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"] 
      }
      "80" = {
          port = 80
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
      }
      "443" = {
          port = 443
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          
      }
  }
}
variable "create_lc" {
  description = "Determines whether to create launch configuration or not"
  type        = bool
  default     = true
}

variable "lc_name" {
  description = "Name of launch configuration to be created"
  type        = string
  default     = "launch-config"
}
variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default = "t3.medium"
}


variable "ebs_block_device" {
  description = "(LC) Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "root_block_device" {
  description = "(LC) Customize details about the root block device of the instance"
  type        = list(map(string))
  default     = []
}

/*****************************************************************************************
* EC2 autoscaling group variable
******************************************************************************************/

variable "create_asg" {
  description = "Determines whether to create autoscaling group or not"
  type        = bool
  default     = true
}

variable "asg_name" {
  description = "Name used across the resources created"
  type        = string
  default = "asg-01"
}
variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default = 1
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default = 5
}

variable "desired_capacity" {
  description = "The desired number of EC2 Instances in the ASG"
  type        = number
  default = 2
}
variable "capacity_rebalance" {
  description = "Indicates whether capacity rebalance is enabled"
  type        = bool
  default     = null
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  type        = number
  default     = null
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior."
  type        = number
  default     = null
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
  default     = null
}
variable "associate_public_ip_address" {
  description = "(LC) Associate a public ip address with an instance in a VPC"
  type        = bool
  default     = true
}
variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = null
}

variable "protect_from_scale_in" {
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events."
  type        = bool
  default     = false
}


variable "health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = null
}
variable "force_delete" {
  description = "Allows deleting the Auto Scaling Group without waiting for all instances in the pool to terminate. You can force an Auto Scaling Group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  type        = bool
  default     = null
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the Auto Scaling Group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `OldestLaunchTemplate`, `AllocationStrategy`, `Default`"
  type        = list(string)
  default     = null
}

/*****************************************************************
* application load balancer variable 
***************************************************************/
#ingreess value variable 
variable "ingress_alb" {
  description = "It will set the inbound rule of the security group"
  type = map(object({
    port = number
    protocol = string
    cidr_blocks = list(string)

  }))
  default = {
      
      "8080" = {
          port = 8080
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"] 
      }
      "80" = {
          port = 80
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
      }
      "443" = {
          port = 443
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          
      }
  }
}

variable "internal" {
  type        = bool
  default     = false
  description = "A boolean flag to determine whether the ALB should be internal"
}

variable "cross_zone_load_balancing_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable cross zone load balancing"
}
variable "drop_invalid_header_fields" {
  type        = bool
  default     = false
  description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false)."
}
variable "deletion_protection_enabled" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable deletion protection for ALB"
}

variable "http2_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable HTTP/2"
}

variable "idle_timeout" {
  type        = number
  default     = 60
  description = "The time in seconds that the connection is allowed to be idle"
}

variable "alb_sg_name" {
  type = string
  default = "terraform_alb_security_group"
}

variable "ip_address_type" {
  type        = string
  default     = "ipv4"
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`."
}

variable "target_group_target_type" {
  type        = string
  default     = "instance"
  description = "The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group"
}

variable "deregistration_delay" {
  type        = number
  default     = 300
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused"
}
variable "target_group_protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol for the default target group HTTP or HTTPS"
}

variable "health_check_path" {
  type        = string
  default     = "/"
  description = "The destination for the health check request"
}

variable "health_check_port" {
  type        = string
  default     = "traffic-port"
  description = "The port to use for the healthcheck"
}

variable "health_check_timeout" {
  type        = number
  default     = 5
  description = "The amount of time to wait in seconds before failing a health check request"
}

variable "health_check_healthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health check failures required before considering the target unhealthy"
}

variable "health_check_interval" {
  type        = number
  default     = 30
  description = "The duration in seconds in between health checks"
}

variable "health_check_matcher" {
  type        = string
  default     = "200"
  description = "The HTTP response codes to indicate a healthy check"
}
variable "certificate_arn" {
  type        = string
  default     = ""
  description = "The ARN of the default SSL certificate for HTTPS listener"
}

variable "target_port" {
  description = "The port on which targets receive traffic."
  default = "80"
}

variable "https_ssl_policy" {
  type        = string
  description = "The name of the SSL Policy for the listener"
  default     = "ELBSecurityPolicy-2015-05"
}
variable "additional_certs" {
  type        = list(string)
  description = "A list of additonal certs to add to the https listerner"
  default     = []
}

variable "alb_sg_description" {
  type = string
  default = "Terraform load balancer security group"
}
variable "https_enabled" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable HTTPS listener"
}
variable "alb_name"{
  type = string
  default = "Dev-alb"
  description = "name of the alb"
}

variable "load_balancer_type"{
  type = string
  default = "application"
}

variable "alb_target_name"{
  type = string
  default = "Dev-alb-target"
}

variable "alb_target_port" {
  type = string
  default = "8080"
  description = " Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda."
}

variable "alb_target_protocol_version"{
  type        = string
  default     = "HTTP1"
  description = "Only applicable when protocol is HTTP or HTTPS. The protocol version. Specify GRPC to send requests to targets using gRPC. Specify HTTP2 to send requests to targets using HTTP/2. The default is HTTP1, which sends requests to targets using HTTP/1.1"
}

variable "alb_target_protocol"{
  type = string
  default = "HTTP"
  description = "Protocol to use for routing traffic to the targets. Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda."
}

variable "aws_alb_listener_http_port"{
  type = string
  default = "80"
  description = "Port on which the load balancer is listening. Not valid for Gateway Load Balancers."
}

