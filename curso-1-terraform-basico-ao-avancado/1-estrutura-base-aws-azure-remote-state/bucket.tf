resource "aws_s3_bucket" "bucket" {
  bucket = "soso-rm-state-bucket"
}

resource "aws_s3_bucket_versioning" "bucketVersioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}