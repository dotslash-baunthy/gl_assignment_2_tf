# Output file
# Only outputs the DNS name of the LB
output "lb_endpoint" {
  value = "http://${aws_elb.web_elb.dns_name}"
}
