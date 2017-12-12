
module "service" {
  source      = "git@github.com:WisePricer/tf.git//wiser/service"
  env         = "${var.env}"
  repo        = "${var.docker_image_name}"
  key_name    = "${var.key_name}"
  stack       = "test-docker"
  dns_aliases = ["test-docker"]
  port        = "3199"
  min_instances = 1
  max_instances = 1
  notify      = "test-docker"
  network     = "public"
  instance_type = "r3.large"
  lb_type     = "network"
  has_redis   = false
}
