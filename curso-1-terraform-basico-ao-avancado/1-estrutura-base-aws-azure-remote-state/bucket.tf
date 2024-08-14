resource "aws_s3_bucket" "bucket" {
  bucket = "soso-rm-state-bucket"
}

resource "aws_s3_bucket_versioning" "bucketVersioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "terraform_data" "cleanup_s3_bucket" {
#   lifecycle {
#     create_before_destroy = false
#   }
#   provisioner "local-exec" {
#     command = <<EOT
#     aws s3 rm s3://soso-rm-state-bucket --recursive
#     aws s3api list-object-versions --bucket soso-rm-state-bucket --query "Versions[].{Key:Key,VersionId:VersionId}" --output text | while read key version_id; do
#         aws s3api delete-object --bucket soso-rm-state-bucket --key "$key" --version-id "$version_id"
#     done
#     aws s3api list-object-versions --bucket soso-rm-state-bucket --query "DeleteMarkers[].{Key:Key,VersionId:VersionId}" --output text | while read key version_id; do
#         aws s3api delete-object --bucket soso-rm-state-bucket --key "$key" --version-id "$version_id"
#     done
#     EOT
#   }
# }