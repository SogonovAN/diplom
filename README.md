# Домашнее задание к занятию "Кеширование Redis/memcached - `Согонов Алексей`"

### Задание 1
```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
variable "yandex_cloud_token" {
  type = string
  description = ""
}
provider "yandex" {
  token     = var.yandex_cloud_token #секретные данные должны быть в сохранности!! Никогда не выкладывайте токен в публичный доступ.
  cloud_id  = "b1g9aq9ld62tle4e2foh"
  folder_id = "b1gcq8e922b176vv64p4"
  zone = "ru-central1-b"
}

resource "yandex_compute_instance" "vm-1" {

  count = 2
  name                      = "linux-vm-${count.index + 1}"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-b"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8nru7hnggqhs9mkqps"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = ""
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}

resource "yandex_lb_target_group" "foo-1" {
  name      = "group1"
  target {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    address   = "${yandex_compute_instance.vm-1[0].network_interface.0.ip_address}"
  }
  target {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    address   = "${yandex_compute_instance.vm-1[1].network_interface.0.ip_address}"
  }
}

resource "yandex_lb_network_load_balancer" "foo-1" {
  name = "balancer1"

  listener {
    name = "listener1"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.foo-1.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
```


![Название скриншота 1](https://github.com/SogonovAN/balancer-cloud-hw/blob/main/11.JPG)`

![Название скриншота 1](https://github.com/SogonovAN/balancer-cloud-hw/blob/main/22.JPG)`

![Название скриншота 1](https://github.com/SogonovAN/balancer-cloud-hw/blob/main/3.JPG)`

---

