
resource "aws_elasticache_cluster" "demo_redis" {
  cluster_id           = "demo-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  port                 = 6379
  num_cache_nodes = 1

  subnet_group_name = "${aws_elasticache_subnet_group.demo_redis_sn.name}"
  security_group_ids = [
    "${data.terraform_remote_state.layer_base.sg_sn_private_id}" 
  ]

  tags {
    Name = "demo_redis"
  }
}

resource "aws_elasticache_subnet_group" "demo_redis_sn" {
  name       = "demo-redis-sn"
  subnet_ids = ["${data.terraform_remote_state.layer_base.sn_private_a_id}", "${data.terraform_remote_state.layer_base.sn_private_b_id}", "${data.terraform_remote_state.layer_base.sn_private_c_id}"]
}
