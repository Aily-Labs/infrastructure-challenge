resource "aws_route53_record" "this" {
  name    = "infrastructure-challenge.${var.zone_name}"
  records = [aws_lb.this.dns_name]
  ttl     = 60
  type    = "CNAME"
  zone_id = data.aws_route53_zone.this.id
}
