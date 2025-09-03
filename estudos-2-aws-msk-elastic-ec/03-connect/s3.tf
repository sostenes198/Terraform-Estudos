resource "random_id" "plugins_rand" {
  byte_length = 3
}

resource "aws_s3_bucket" "plugins" {
  bucket        = "poc-msk-plugins-${random_id.plugins_rand.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "plugins" {
  bucket                  = aws_s3_bucket.plugins.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "plugins" {
  bucket = aws_s3_bucket.plugins.id
  versioning_configuration { status = "Enabled" }
}

# Faz o upload do ZIP local durante o apply
resource "aws_s3_object" "es_sink_zip" {
  bucket       = aws_s3_bucket.plugins.id
  key          = "confluentinc-kafka-connect-elasticsearch-15.0.1.zip"
  source       = local.plugin_zip_path
  content_type = "application/zip"
  etag         = filemd5(local.plugin_zip_path) # força update quando o arquivo local mudar
}