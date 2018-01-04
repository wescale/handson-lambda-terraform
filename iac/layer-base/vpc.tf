
resource "aws_vpc" "demo_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags {
        Name = "demo_vpc"
    }
}

resource "aws_internet_gateway" "demo_vpc_igtw" {
    vpc_id = "${aws_vpc.demo_vpc.id}"
}

/*
  Public Subnet
*/
resource "aws_subnet" "demo_sn_public_a" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    cidr_block = "${var.public_subnet_a_cidr}"
    availability_zone = "${var.region}a"

    tags = {
        Name = "demo_sn_public_a"
    }
}

resource "aws_subnet" "demo_sn_public_b" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    cidr_block = "${var.public_subnet_b_cidr}"
    availability_zone = "${var.region}b"

    tags = {
        Name = "demo_sn_public_b"
    }
}

resource "aws_subnet" "demo_sn_public_c" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    cidr_block = "${var.public_subnet_c_cidr}"
    availability_zone = "${var.region}c"

    tags = {
        Name = "demo_sn_public_c"
    }
}

/*
  Private Subnet
*/
resource "aws_subnet" "demo_sn_private_a" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    cidr_block = "${var.private_subnet_a_cidr}"
    availability_zone = "${var.region}a"


    tags = {
        Name = "demo_sn_private_a"
    }
}

resource "aws_subnet" "demo_sn_private_b" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    cidr_block = "${var.private_subnet_b_cidr}"
    availability_zone = "${var.region}b"


    tags = {
        Name = "demo_sn_private_b"
    }
}

resource "aws_subnet" "demo_sn_private_c" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    cidr_block = "${var.private_subnet_c_cidr}"
    availability_zone = "${var.region}c"


    tags = {
        Name = "demo_sn_private_c"
    }
}

/* add route to public subnet */

/* ici on autorise le réseau "public" à accéder à la Gateway internet */

resource "aws_route_table" "demo_vpc_rt_public" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.demo_vpc_igtw.id}"
    }

    tags = {
        Name = "demo_vpc_rt_public"
    }
}

resource "aws_route_table_association" "demo_vpc_rta_public_a" {
    subnet_id = "${aws_subnet.demo_sn_public_a.id}"
    route_table_id = "${aws_route_table.demo_vpc_rt_public.id}"
}

resource "aws_route_table_association" "demo_vpc_rta_public_b" {
    subnet_id = "${aws_subnet.demo_sn_public_b.id}"
    route_table_id = "${aws_route_table.demo_vpc_rt_public.id}"
}

resource "aws_route_table_association" "demo_vpc_rta_public_c" {
    subnet_id = "${aws_subnet.demo_sn_public_c.id}"
    route_table_id = "${aws_route_table.demo_vpc_rt_public.id}"
}

/* ici la SG générique pour les instances dans le réseau public */

resource "aws_security_group" "demo_sg_public" {
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    tags = {
        Name = "demo_sg_public"
    }

    vpc_id = "${aws_vpc.demo_vpc.id}"
}

resource "aws_security_group" "demo_sg_private" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    tags = {
        Name = "demo_sg_private"
    }
}

resource "aws_security_group_rule" "demo_sg_private_allow_redis_ingress" {
  type            = "ingress"
  from_port       = 6379
  to_port         = 6379
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.demo_lambda_sg.id}"

  security_group_id = "${aws_security_group.demo_sg_private.id}"
}


resource "aws_security_group_rule" "demo_sg_private_allow_redis_egress" {
  type            = "egress"
  from_port       = 6379
  to_port         = 6379
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.demo_lambda_sg.id}"

  security_group_id = "${aws_security_group.demo_sg_private.id}"
}

/* for lambda */

resource "aws_security_group" "demo_lambda_sg" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    tags = {
        Name = "demo_sg_lambda"
    }
}

resource "aws_security_group_rule" "demo_lambda_sg_allow_redis_ingress" {
  type            = "ingress"
  from_port       = 6379
  to_port         = 6379
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.demo_sg_private.id}"

  security_group_id = "${aws_security_group.demo_lambda_sg.id}"
}

resource "aws_security_group_rule" "demo_lambda_sg_allow_redis_egress" {
  type            = "egress"
  from_port       = 6379
  to_port         = 6379
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.demo_sg_private.id}"

  security_group_id = "${aws_security_group.demo_lambda_sg.id}"
}


resource "aws_security_group_rule" "demo_lambda_sg_allow_http_ingress" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks =  ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.demo_lambda_sg.id}"
}

resource "aws_security_group_rule" "demo_lambda_sg_allow_http_egress" {
  type            = "egress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks =  ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.demo_lambda_sg.id}"
}

resource "aws_security_group_rule" "demo_lambda_sg_allow_https_ingress" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks =  ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.demo_lambda_sg.id}"
}

resource "aws_security_group_rule" "demo_lambda_sg_allow_https_egress" {
  type            = "egress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks =  ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.demo_lambda_sg.id}"
}

resource "aws_eip" "demo_nat_gw_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "demo_nat_gw" {

  depends_on = ["aws_internet_gateway.demo_vpc_igtw"]

  allocation_id = "${aws_eip.demo_nat_gw_eip.id}"
  subnet_id     = "${aws_subnet.demo_sn_public_a.id}"
}


/* ici on autorise le réseau "privé" à accéder à la NAT Gateway */

resource "aws_route_table" "demo_vpc_rt_private" {
    vpc_id = "${aws_vpc.demo_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.demo_nat_gw.id}"
    }

    tags = {
        Name = "demo_vpc_rt_private"
    }
}

resource "aws_route_table_association" "demo_vpc_rta_private_a" {
    subnet_id = "${aws_subnet.demo_sn_private_a.id}"
    route_table_id = "${aws_route_table.demo_vpc_rt_private.id}"
}

resource "aws_route_table_association" "demo_vpc_rta_private_b" {
    subnet_id = "${aws_subnet.demo_sn_private_b.id}"
    route_table_id = "${aws_route_table.demo_vpc_rt_private.id}"
}

resource "aws_route_table_association" "demo_vpc_rta_private_c" {
    subnet_id = "${aws_subnet.demo_sn_private_c.id}"
    route_table_id = "${aws_route_table.demo_vpc_rt_private.id}"
}


output "sn_private_a_id" {
    value = "${aws_subnet.demo_sn_private_a.id}"
}

output "sn_private_b_id" {
    value = "${aws_subnet.demo_sn_private_b.id}"
}

output "sn_private_c_id" {
    value = "${aws_subnet.demo_sn_private_c.id}"
}

output "vpc_id" {
    value = "${aws_vpc.demo_vpc.id}"
}

output "sg_sn_private_id" {
    value = "${aws_security_group.demo_sg_private.id}"
}

output "sg_sn_lambda_id" {
    value = "${aws_security_group.demo_lambda_sg.id}"
}