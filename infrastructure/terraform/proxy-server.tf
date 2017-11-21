variable "env" {
  description = "Deploy environment"
}

module "proxy-service" {
  source = "git@github.com:WisePricer/tf.git?ref=workflow-changes//wiser/service"
  env = "${var.env}"
  stack = "test-proxy"
  port = "3199"
  min_instances = 2
  max_instances = 4
  spot_price = "0.05"
  notify = "test-proxy"
  network = "public"
  instance_type = "r3.large"
  repo = "docker-node"
  additional_ports = [3200]
  lb_type = "network"
  has_redis = true
  redis_instance_type = "cache.m3.large"
}
