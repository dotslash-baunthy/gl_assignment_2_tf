# Creating launch config
# This is used in case of adding another instance to the Autoscaling Group
resource "aws_launch_configuration" "web" {
  name_prefix                 = "web-"
  image_id                    = data.aws_ami.amazon-linux.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  user_data                   = file("user-data.sh")
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.ec2sg.id}"]

  lifecycle {
    create_before_destroy = true
  }
}
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

# Creating autoscaling group based on the above launch config
# Instructions for autoscaling are added and instances created use the template above
resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"

  min_size         = 2
  desired_capacity = 2
  max_size         = 5

  health_check_type = "ELB"
  load_balancers = [
    "${aws_elb.web_elb.name}"
  ]

  launch_configuration = aws_launch_configuration.web.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier = ["subnet-0535ad1a7677b9ca0", "subnet-07490e858de29b80c", "subnet-00426cc01eddb2799", "subnet-032d2c14537efb9db", "subnet-04eaf7f46498b199d", "subnet-066044e27e27bad97"]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }

}
