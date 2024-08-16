module "vpc" {
  source = "./vpc"
  providers = {
    aws.provider_1 = aws.eua
    aws.provider_2 = aws.australia
  }
}
