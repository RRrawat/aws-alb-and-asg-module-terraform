region        = "us-east-1"
vpc_id = "vpc-085##################"
create_lc = true

instance_type = "t2.micro"

key_name = "#########"

ingress = {
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


#autoscaling group 

create_asg = true 
min_size = 1
max_size = 5
desired_capacity = 3
wait_for_capacity_timeout = 0
health_check_type         = "EC2"


#alb
ingress_alb = {
      
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
      "22" = {
          port = 22
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          
      }
  }

