# locals {
#   # Extract all website source code files to upload.
#   source_code_files = fileset(var.source_code_path, "**/*")
#
#   # Add supported file MIME types as used.
#   mime_types = {
#     ".html" = "text/html"
#     ".css"  = "text/css"
#     ".js"   = "application/javascript"
#     ".json" = "application/json"
#     ".png"  = "image/png"
#     ".jpg"  = "image/jpeg"
#     ".jpeg" = "image/jpeg"
#     ".gif"  = "image/gif"
#     ".svg"  = "image/svg+xml"
#     ".pdf"  = "application/pdf"
#   }
# }
#
# # Create the hosting S3 bucket.
# resource "aws_s3_bucket" "host_bucket" {
#   bucket = var.host_bucket_name
# }
#
# # Disable default explicit public access blocking.
# resource "aws_s3_bucket_public_access_block" "host_bucket_public_access" {
#   bucket = aws_s3_bucket.host_bucket.id
#
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }
#
# # Create an Origin Access Identity for secure S3 access
# resource "aws_cloudfront_origin_access_identity" "website_oai" {
#   comment = "OAI for static website S3 bucket"
# }
#
# # Create CloudFront distribution
# resource "aws_cloudfront_distribution" "website_distribution" {
#   enabled             = true
#   is_ipv6_enabled     = true
#   default_root_object = "index.html"
#
#   # S3 origin configuration
#   origin {
#     domain_name = aws_s3_bucket.host_bucket.bucket_regional_domain_name
#     origin_id   = aws_s3_bucket.host_bucket.id
#
#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.website_oai.cloudfront_access_identity_path
#     }
#   }
#
#   # Default cache behavior
#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = aws_s3_bucket.host_bucket.id
#
#     forwarded_values {
#       query_string = false
#       headers      = []
#
#       cookies {
#         forward = "none"
#       }
#     }
#
#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }
#
#   # Restrict geographic distribution (optional)
#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }
#
#   # SSL certificate configuration
#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }
#
# # Configure S3 static website hosting.
# resource "aws_s3_bucket_website_configuration" "host_bucket_website_config" {
#   bucket = aws_s3_bucket.host_bucket.bucket
#
#   index_document {
#     suffix = "index.html"
#   }
#
#   error_document {
#     key = "error.html"
#   }
# }
#
# # Attach a single bucket policy allowing CloudFront access
# resource "aws_s3_bucket_policy" "host_bucket_policy" {
#   bucket = aws_s3_bucket.host_bucket.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "CloudFrontReadGetObject"
#         Effect    = "Allow"
#         Principal = {
#           AWS = aws_cloudfront_origin_access_identity.website_oai.iam_arn
#         }
#         Action    = "s3:GetObject"
#         Resource  = "${aws_s3_bucket.host_bucket.arn}/*"
#       }
#     ]
#   })
#
#   depends_on = [aws_s3_bucket_public_access_block.host_bucket_public_access]
# }
#
# #  Upload the website source code as bucket objects.
# resource "aws_s3_object" "website_source_code" {
#   for_each = local.source_code_files
#
#   bucket       = aws_s3_bucket.host_bucket.id
#   key          = each.value
#   source       = "${var.source_code_path}/${each.value}"
#   etag         = filemd5("${var.source_code_path}/${each.value}")
#   content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "binary/octet-stream")
#
#   # For HTML files, also set cache-control (prevent caching issues during development).
#   cache_control = can(regex("\\.html?$", each.value)) ? "no-cache" : null
# }


locals {
  # Extract all website source code files to upload.
  source_code_files = fileset(var.source_code_path, "**/*")

  # Add supported file MIME types as used.
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".pdf"  = "application/pdf"
  }
}

# Fetch the existing hosted zone for your domain
data "aws_route53_zone" "domain_zone" {
  name = "trained-by-will.com."
}

# Create an ACM certificate for your domain
resource "aws_acm_certificate" "website_cert" {
  provider          = aws.us-east-1
  domain_name       = "trained-by-will.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# NOTE: AWS ACM certificate requires us-east-1.
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# Create the DNS validation record
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain_zone.zone_id
}

# Validate the certificate
resource "aws_acm_certificate_validation" "website_cert_validation" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.website_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Create the hosting S3 bucket
resource "aws_s3_bucket" "host_bucket" {
  bucket = var.host_bucket_name
}

# Disable default explicit public access blocking
resource "aws_s3_bucket_public_access_block" "host_bucket_public_access" {
  bucket = aws_s3_bucket.host_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create an Origin Access Identity for secure S3 access
resource "aws_cloudfront_origin_access_identity" "website_oai" {
  comment = "OAI for static website S3 bucket"
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "website_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["trained-by-will.com"]

  # S3 origin configuration
  origin {
    domain_name = aws_s3_bucket.host_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.host_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website_oai.cloudfront_access_identity_path
    }
  }

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.host_bucket.id

    forwarded_values {
      query_string = false
      headers      = []

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Restrict geographic distribution (optional)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL certificate configuration
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# Configure S3 static website hosting
resource "aws_s3_bucket_website_configuration" "host_bucket_website_config" {
  bucket = aws_s3_bucket.host_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Attach a single bucket policy allowing CloudFront access
resource "aws_s3_bucket_policy" "host_bucket_policy" {
  bucket = aws_s3_bucket.host_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "CloudFrontReadGetObject"
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.website_oai.iam_arn
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.host_bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.host_bucket_public_access]
}

# Upload the website source code as bucket objects
resource "aws_s3_object" "website_source_code" {
  for_each = local.source_code_files

  bucket       = aws_s3_bucket.host_bucket.id
  key          = each.value
  source       = "${var.source_code_path}/${each.value}"
  etag         = filemd5("${var.source_code_path}/${each.value}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "binary/octet-stream")

  # For HTML files, also set cache-control (prevent caching issues during development)
  cache_control = can(regex("\\.html?$", each.value)) ? "no-cache" : null
}

# Create Route 53 record to point domain to CloudFront
resource "aws_route53_record" "website_domain" {
  zone_id = data.aws_route53_zone.domain_zone.zone_id
  name    = "trained-by-will.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}