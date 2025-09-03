resource "aws_iam_role" "ec2_ssm" {
  name = "poc-msk-client-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect="Allow", Principal={ Service="ec2.amazonaws.com" }, Action="sts:AssumeRole" }]
  })

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_attach" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "poc-msk-client-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
  
  tags = local.default_tags
}
