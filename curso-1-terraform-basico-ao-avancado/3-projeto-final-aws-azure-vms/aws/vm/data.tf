resource "terraform_data" "exist_ssh_file" {
  input = fileexists("${path.module}/${var.ssh_file_name}")
}