locals {
  # cluster_name = "eks-${random_string.suffix.result}"
  cluster_name = "eks-sosoestudos"
  common_tags = {
    owner      = "Soso",
    managed-by = "terraform"
  }
}
