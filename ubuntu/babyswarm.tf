variable "do_token" {}

variable "ssh_keys" {
  default = []
}

variable "do_image" {
  default = "30970148" # docker CE on ubuntu
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
      "sudo apt-get -y install python",
      "sed 's# -H fd://# #g' -i /etc/systemd/system/multi-user.target.wants/docker.service",
      "sed 's# -H fd://# #g' -i /lib/systemd/system/docker.service",
      "ufw allow 2377/tcp",
      "ufw allow 7946/tcp",
      "ufw allow 7946/udp",
      "ufw allow 4789/udp",
      "ufw reload",
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
      "sudo apt-get -y install python",
      "sed 's# -H fd://# #g' -i /etc/systemd/system/multi-user.target.wants/docker.service",
      "sed 's# -H fd://# #g' -i /lib/systemd/system/docker.service",
      "ufw allow 7946/tcp",
      "ufw allow 7946/udp",
      "ufw allow 4789/udp",
      "ufw reload",
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
      "sudo apt-get -y install python",
      "sed 's# -H fd://# #g' -i /etc/systemd/system/multi-user.target.wants/docker.service",
      "sed 's# -H fd://# #g' -i /lib/systemd/system/docker.service",
      "ufw allow 7946/tcp",
      "ufw allow 7946/udp",
      "ufw allow 4789/udp",
      "ufw reload",
    ]
  }
}

resource "digitalocean_floating_ip" "vtg-manager" {
  droplet_id = "${digitalocean_droplet.vtg-manager.id}"
  region     = "${digitalocean_droplet.vtg-manager.region}"
}

/*
resource "digitalocean_floating_ip" "vtg-worker1" {
  droplet_id = "${digitalocean_droplet.vtg-worker1.id}"
  region     = "${digitalocean_droplet.vtg-worker1.region}"
}

resource "digitalocean_floating_ip" "vtg-worker2" {
  droplet_id = "${digitalocean_droplet.vtg-worker2.id}"
  region     = "${digitalocean_droplet.vtg-worker2.region}"
}
*/

output "ip address vtg-manager" {
  value = "${digitalocean_droplet.vtg-manager.ipv4_address}"
}

output "floating ip address vtg-manager" {
  value = "${digitalocean_floating_ip.vtg-manager.ip_address}"
}
