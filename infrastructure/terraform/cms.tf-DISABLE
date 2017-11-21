
variable "env" {
  description = "Deploy environment"
}

module "service" {
  source = "git@github.com:WisePricer/tf.git?ref=workflow-changes//wiser/service"
  stack = "cms"
  notify = "cms"
  port = "3060"
  spot_price = "0.05"
  env = "${var.env}"
}
