module "static_s3_website" {
  source = "../../../../libs/terraform/aws/static_s3_website"
  host_bucket_name = "852634928873-portfolio-website"
  source_code_path = "${path.module}/../src/"
}

output "website_endpoint" {
  value = module.static_s3_website.website_endpoint
}

output "website_domain" {
  value = module.static_s3_website.website_domain
}

output "cloudfront_domain_name" {
  value = module.static_s3_website.cloudfront_domain_name
}
