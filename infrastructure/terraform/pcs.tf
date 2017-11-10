
variable "env" {
  description = "Deploy environment"
}

module "service" {
  source = "git@github.com:WisePricer/tf.git//wiser/service"
  stack = "pcs"
  port = "3090"
  spot_price = "0.05"
  notify = "pcs"
  env = "${var.env}"
}
