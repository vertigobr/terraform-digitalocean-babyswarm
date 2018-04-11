# terraform-digitalocean-babyswarm

Terraforms a 3-node swarm mode cluster (1 manager, 2 workers).
Creates swarm mode cluster with ansible.

## How to use Terraform

There are specific folders for some combinations of Linux distro and Digital Ocean 1-click apps:

* centos: plain CentOS 7.4 (Terraform installs Docker CE)
* coreos: plain CoreOS (Docker already installed)
* Docker on ubuntu: 1-click app

Whatever you choose you must:

* Copy `babyswarm.auto.tfvars.template` into `babyswarm.auto.tfvars` and fill in the variables;
* Provision your servers with the commands below:

```sh
terraform init
terraform apply
```

* Check on Digital Ocean dashboard if servers were created and do a few tests on command line:

```sh
python terraform.py --debug --list | jq    # dynamic ansible inventory
ansible -i terraform.py -m ping all
```

## Tips

To create just the manager node:

    terraform apply -target=digitalocean_droplet.vtg-manager

To create just the manager node with floating ip:

    terraform apply -target=digitalocean_droplet.vtg-manager -target=digitalocean_floating_ip.vtg-manager

