output "ns_records" {
  description = "NS records for the domain"
  value       = aws_route53_zone.this.name_servers
}
