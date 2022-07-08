// Configure the Yandex.Cloud provider
provider "yandex" {
  cloud_id                 = "b1gdf77vi5ve9v93ju6u"
  service_account_key_file = "./key.json"
  folder_id                = "b1g18ju5thr617j2dihl" 
}


data "yandex_compute_image" "image" {
  family = "ubuntu-2004-lts"
}


# Network
resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.15.0/24"]
}


resource "yandex_compute_instance" "node01" {
  name                      = "node01"
  zone                      = "ru-central1-a"
  hostname                  = "node01.netology.cloud"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.image.id
      name        = "root-node01"
      type        = "network-nvme"
      size        = "15"
    }
  }
 

network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}

