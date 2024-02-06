resource "aws_route53_record" "this" {
  count = var.zone_name != null ? 1 : 0

  name    = "infrastructure-challenge.${var.zone_name}"
  records = [aws_lb.this.dns_name]
  ttl     = 60
  type    = "CNAME"
  zone_id = data.aws_route53_zone.this[0].id
}
