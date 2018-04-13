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

* Check on Digital Ocean dashboard if servers were created.

### Tips

To create just the manager node:

    terraform apply -target=digitalocean_droplet.vtg-manager

To create just the manager node with floating ip:

    terraform apply -target=digitalocean_droplet.vtg-manager -target=digitalocean_floating_ip.vtg-manager

## How to use Ansible

The challenge is to use the dynamic inventory present in "tfstate" to run our swarm setup playbook.

The "terraform.py" script in each folder generates an ansible inventory from tfstate on current folder. You can run a few tests on command line:

```sh
python terraform.py --debug --list    # dynamic ansible inventory
ansible -i terraform.py -m ping all   # pings all servers
```

To setup swarm mode on all nodes run the command below (example based on centos folder):

```sh
cd centos
ansible-playbook -i terraform.py ../swarm-mode.yaml
```

## Securing Docker Daemon

This is useful to both secure the Docker socket *and* to access the docker daemon remotely.

```sh
ansible-galaxy -i install vertigobr.secure-docker-daemon -p ./roles
ANSIBLE_ROLES_PATH=./roles ansible-playbook -i terraform.py ../secure-swarm.yaml
```

The client certificates were generated on the server (at "/root/.docker/"). Download them using the fetch-certs.yaml playbook or with any other tool like scp. You can also download the docker_env.sh utility script to quickly setup your command line.

## Fetching client certs

```sh
ansible-playbook -i terraform.py fetch-certs.yaml
```