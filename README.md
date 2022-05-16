# application-load-balancer-with-autoscaling-group

In this post, I am going bit further to explain the same scenario by having an Application Load Balancer (ALB) with Auto Scaling feature. Though this is a pretty straight forward scenario, having a production level setup 


deployment architecture.

A Custom VPC with two Availability Zones for High Availability
Each Availability Zone has a public subnet and a private subnet.
There are two EC2 instances, which are in private subnets and the Application Load Balancer is attached to two public subnets as expected.
ALB is coupled with Auto Scaling
There is one Target Group connecting both the EC2 instances
EC2 Apache installation happens with AWS SSM

You can do a quick check to see whether the example works now.

Select ALB -> Click Description Tab -> Click the Description tab -> Copy (Ctrl +C) the DNS name (e.g. myALB-1767835550.us-east-1.elb.amazonaws.com)

Paste the DNS name on a web browser and see all ok.
