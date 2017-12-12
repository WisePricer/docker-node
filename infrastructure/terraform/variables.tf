variable "region" {
  default = "us-west-2"
}
variable "env" {
  description = "Deploy environment"
  default = "test"
}
variable "docker_image_name" {
  description = "Docker image name"
}
variable "key_name" {
  default = "devops20170606"
}
