provider "bigip" {
  address  = "${var.url}"
  username = "${var.username}"
  password = "${var.password}"
}

resource "bigip_ltm_node" "test_node_1" {
  name    = "/Common/terraform_node1"
  address = "10.10.10.10"
}

resource "bigip_ltm_node" "test_node_2" {
  name    = "/Common/terraform_node2"
  address = "10.10.10.11"
}

resource "bigip_ltm_pool" "pool" {
  name                = "/Common/terraform-pool"
  load_balancing_mode = "round-robin"
  nodes               = ["${bigip_ltm_node.test_node_1.name}:80", "${bigip_ltm_node.test_node_2.name}:80"]
  allow_snat          = false
}

resource "bigip_ltm_virtual_server" "http" {
  name                       = "/Common/terraform_vs_http"
  destination                = "10.12.12.12"
  port                       = 80
  pool                       = "${bigip_ltm_pool.pool.name}"
  source_address_translation = "snat"
}
