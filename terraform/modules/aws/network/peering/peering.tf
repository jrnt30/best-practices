variable "vpc_id" {}
variable "vpc_cidr" {}
variable "pub_route_table_ids" {}
variable "priv_route_table_ids" {}
variable "peer_owner_id" {}
variable "services_vpc" {}
variable "services_cidr" {}

resource "aws_vpc_peering_connection" "services_peering" {
    peer_owner_id = "${var.peer_owner_id}"
    peer_vpc_id = "${var.services_vpc}"
    vpc_id = "${var.vpc_id}"
    auto_accept = true
}

# Local to services routes
resource "aws_route" "pub_to_services" {
  count                     = "${length(split(",", var.pub_route_table_ids))}"
  route_table_id            = "${element(split(",", var.pub_route_table_ids), count.index)}"
  destination_cidr_block    = "${var.services_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.services_peering.id}"
}

output "interpolation_debug" { value = "${length(split(",", var.pub_route_table_ids))}" }