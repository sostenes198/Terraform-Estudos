resource "aws_route53_zone" "ess_vpce" {
  name = var.privatelink_domain
  vpc  { vpc_id = module.vpc.vpc_id }
  comment = "Private hosted zone for Elastic Cloud PrivateLink"
}

resource "aws_route53_record" "ess_cname" {
  zone_id = aws_route53_zone.ess_vpce.zone_id
  name    = "*"
  type    = "CNAME"
  ttl     = 60
  records = [aws_vpc_endpoint.elastic_privatelink.dns_entry[0].dns_name]
}
