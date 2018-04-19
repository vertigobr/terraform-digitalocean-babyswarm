variable "do_token" {}

variable "ssh_keys" {
  default = []
}

variable "do_image" {
  default = "centos-7-x64"
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_tag" "swarm-manager" {
  name = "swarm-manager"
}

resource "digitalocean_tag" "swarm-worker" {
  name = "swarm-worker"
}

# Create swarm manager and workers
resource "digitalocean_droplet" "vtg-manager" {
  image    = "${var.do_image}"
  name     = "vtg-manager"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = "${var.ssh_keys}"
  tags     = ["${digitalocean_tag.swarm-manager.id}"]

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL get.docker.com -o /tmp/get-docker.sh",
      "sudo sh /tmp/get-docker.sh",
      "systemctl start docker",
    ]
  }
}

resource "digitalocean_droplet" "vtg-worker1" {
  image    = "${var.do_image}"
  name     = "vtg-worker1"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = "${var.ssh_keys}"
  tags     = ["${digitalocean_tag.swarm-worker.id}"]

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL get.docker.com -o /tmp/get-docker.sh",
      "sudo sh /tmp/get-docker.sh",
      "systemctl start docker",
    ]
  }
}

resource "digitalocean_droplet" "vtg-worker2" {
  image    = "${var.do_image}"
  name     = "vtg-worker2"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = "${var.ssh_keys}"
  tags     = ["${digitalocean_tag.swarm-worker.id}"]

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL get.docker.com -o /tmp/get-docker.sh",
      "sudo sh /tmp/get-docker.sh",
      "systemctl start docker",
    ]
  }
}

/*
resource "digitalocean_floating_ip" "vtg-manager" {
  droplet_id = "${digitalocean_droplet.vtg-manager.id}"
  region     = "${digitalocean_droplet.vtg-manager.region}"
}

resource "digitalocean_floating_ip" "vtg-worker1" {
  droplet_id = "${digitalocean_droplet.vtg-worker1.id}"
  region     = "${digitalocean_droplet.vtg-worker1.region}"
}

resource "digitalocean_floating_ip" "vtg-worker2" {
  droplet_id = "${digitalocean_droplet.vtg-worker2.id}"
  region     = "${digitalocean_droplet.vtg-worker2.region}"
}

output "floating ip address vtg-manager" {
  value = "${digitalocean_floating_ip.vtg-manager.ip_address}"
}
*/

output "ip address vtg-manager" {
  value = "${digitalocean_droplet.vtg-manager.ipv4_address}"
}


