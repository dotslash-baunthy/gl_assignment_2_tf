# Creating load balancer
# The ELB faces the world, users do not lock into individual machines
# Redirection logic is managed by the LB
# LB listens on port 80 only
resource "aws_elb" "web_elb" {
  name            = "web-elb"
  security_groups = ["${aws_security_group.lbsg.id}"]
  subnets         = ["subnet-0535ad1a7677b9ca0", "subnet-07490e858de29b80c", "subnet-00426cc01eddb2799", "subnet-032d2c14537efb9db", "subnet-04eaf7f46498b199d", "subnet-066044e27e27bad97"]

  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

}
