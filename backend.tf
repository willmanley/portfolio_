terraform {
  backend "s3" {
    bucket       = "852634928873-terraform-remote-backend"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}