output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.host_bucket_website_config.website_endpoint
}

output "website_domain" {
  value = aws_s3_bucket_website_configuration.host_bucket_website_config.website_domain
}

# Output the CloudFront distribution domain name
output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website_distribution.domain_name
}
