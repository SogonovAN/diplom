terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

resource "yandex_compute_instance" "vm-1" {

  name                      = "linux-vm-1"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"
  
  hostname = "vm-1"

  resources {
    cores  = "2"
    core_fraction = "20"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      size = 10
      image_id = "fd8nru7hnggqhs9mkqps"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
    security_group_ids = ["${yandex_vpc_security_group.internal-bastion-network.id}"]
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-2" {

  name                      = "linux-vm-2"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-b"
  
  hostname = "vm-2"

  resources {
    cores  = "2"
    core_fraction = "20"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      size = 10
      image_id = "fd8nru7hnggqhs9mkqps"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-2.id}"
    nat       = true
    security_group_ids = ["${yandex_vpc_security_group.internal-bastion-network.id}"]
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "master" {

  name                      = "master"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"
  
  hostname = "master"

  resources {
    cores  = "2"
    core_fraction = "20"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      size = 10
      image_id = "fd8nru7hnggqhs9mkqps"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-3.id}"
    nat       = true
    security_group_ids = ["${yandex_vpc_security_group.external-bastion-network.id}"]
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "zabbix" {

  name                      = "zabbix"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"
  
  hostname = "vm-zabbix"

  resources {
    cores  = "2"
    core_fraction = "20"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      size = 10
      image_id = "fd8nru7hnggqhs9mkqps"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-3.id}"
    nat       = true
    security_group_ids = ["${yandex_vpc_security_group.external-bastion-network.id}"]
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "elasticsearch-vm" {

  name                      = "elasticsearch"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"
  
  hostname = "elasticsearch"

  resources {
    cores  = "2"
    core_fraction = "20"
    memory = "4"
  }

  boot_disk {
    initialize_params {
      size = 10
      image_id = "fd8nru7hnggqhs9mkqps"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
    security_group_ids = ["${yandex_vpc_security_group.internal-bastion-network.id}"]
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "kibana-vm" {

  name                      = "kibana"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"
  
  hostname = "kibana"

  resources {
    cores  = "2"
    core_fraction = "20"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      size = 10
      image_id = "fd8nru7hnggqhs9mkqps"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-3.id}"
    nat       = true
    security_group_ids = ["${yandex_vpc_security_group.external-bastion-network.id}"]
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.11.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}

resource "yandex_vpc_subnet" "subnet-3" {
  name           = "subnet3"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.12.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}

resource "yandex_vpc_security_group" "external-bastion-network" {
  name        = "external-bastion-network"
  description = "Description for security group"
  network_id  = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol       = "TCP"
    description    = "Rule description 1"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "zabbix"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8080
  }

  ingress {
    protocol       = "TCP"
    description    = "zabbix-agent"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 10051
  }

  ingress {
    protocol       = "TCP"
    description    = "kibana"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "internal-bastion-network" {
  name        = "internal-bastion-network"
  description = "Description for security group"
  network_id  = "${yandex_vpc_network.network-1.id}"

  ingress {
    description    = "Allow HTTP protocol from local subnets"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
  }

  ingress {
    description    = "Allow HTTPS protocol from local subnets"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
  }

  ingress {
    description    = "zabbix-agent"
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["192.168.12.0/24"]
  }

  ingress {
    description    = "elasticsearch"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "elasticsearch"
    protocol       = "TCP"
    port           = 9300
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["192.168.12.0/24"]
  }

  ingress {
    protocol          = "ANY"
    description       = "Разрешает взаимодействие между ресурсами текущей группы безопасности"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_alb_target_group" "foo" {
  name      = "my-target-group"

  target {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    ip_address   = "${yandex_compute_instance.vm-1.network_interface.0.ip_address}"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.subnet-2.id}"
    ip_address   = "${yandex_compute_instance.vm-2.network_interface.0.ip_address}"
  }
}

resource "yandex_alb_backend_group" "test-backend-group" {
  name      = "my-backend-group"

  http_backend {
    name = "test-http-backend"
    weight = 1
    port = 80
    target_group_ids = ["${yandex_alb_target_group.foo.id}"]
    load_balancing_config {
      panic_threshold = 90
    }    
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15 
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name          = "router1"
  labels        = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name                    = "virtualhost"
  http_router_id          = yandex_alb_http_router.tf-router.id
  route {
    name                  = "route"
    http_route {
      http_route_action {
        backend_group_id  = "${yandex_alb_backend_group.test-backend-group.id}"
        timeout           = "60s"
      }
    }
  }
}    

resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "balancer"
  network_id  = "${yandex_vpc_network.network-1.id}"

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = "${yandex_vpc_subnet.subnet-1.id}" 
    }
  }

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = "${yandex_alb_http_router.tf-router.id}"
      }
    }
  }
}

resource "yandex_compute_snapshot_schedule" "default" {
  name = "default"

  schedule_policy {
    expression = "0 0 * * *"
  }
  
  retention_period = "168h"
  
  disk_ids = ["${yandex_compute_instance.vm-1.boot_disk.0.disk_id}", "${yandex_compute_instance.vm-2.boot_disk.0.disk_id}", "${yandex_compute_instance.master.boot_disk.0.disk_id}", "${yandex_compute_instance.zabbix.boot_disk.0.disk_id}", "${yandex_compute_instance.elasticsearch-vm.boot_disk.0.disk_id}", "${yandex_compute_instance.kibana-vm.boot_disk.0.disk_id}"]
}
