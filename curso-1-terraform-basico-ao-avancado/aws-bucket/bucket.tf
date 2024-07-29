resource "aws_s3_bucket" "bucket" {
  bucket = "estudos-soso-test-bucket"

  tags = {
    Environment = "Estudos"
  }
}