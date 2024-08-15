resource "aws_s3_bucket" "bucket_um" {
  bucket = "estudos-soso-test-bucket-1"

  tags = {
    Environment = "Estudos"
  }
}

resource "aws_s3_bucket" "bucket_2" {
  bucket = "estudos-soso-test-bucket-2"

  tags = {
    Environment = "Estudos"
  }
}

resource "aws_s3_bucket" "bucket_3" {
  bucket = "estudos-soso-test-bucket-3"

  tags = {
    Environment = "Estudos"
  }
}