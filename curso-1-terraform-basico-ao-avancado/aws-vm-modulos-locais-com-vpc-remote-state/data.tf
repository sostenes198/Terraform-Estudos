data "local_file" "aws_remote_state" {
  filename = "${path.module}/../aws.remote.state.default.json"
}