module "web_portfolio" {
  source = "./apps/web/portfolio/infra"
}

output "website_endpoint" {
  value = module.web_portfolio.website_endpoint
}

output "website_domain" {
  value = module.web_portfolio.website_domain
}

output "cloudfront_domain_name" {
  value = module.web_portfolio.cloudfront_domain_name
}
