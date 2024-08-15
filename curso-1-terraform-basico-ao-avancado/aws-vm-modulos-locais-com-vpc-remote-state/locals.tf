locals {
  remote_state = jsondecode(data.local_file.aws_remote_state.content)
}