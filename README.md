# Auto Kube - Install Git/CI/CD/K8s automatically 

Auto Kube is a collection of Ansible playbooks that install Git/CI/CD and Kubernetes On-premise.

![Overview](/docs/images/kube_overview.png)

## Tested environment

Tested target machine environment likes below.

* CPU Archtecture: x86_64 or arm64
* OS: Ubuntu 20.04

## Installation steps

1. Install Ansible

    Ansible is one of IT automation tools. You need to install it first to use this.

    [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)

1. Set target machine IPs & users

    You must set your target information(IP and user name) to the "ansible/inventories/vbox.yaml". You can put same IP address and user name onto different items, then those items will be installed on the same machine.

1. Set variables

    You can skip this step, but if you want to set your variables, see "ansible/plabooks/vars.yaml". You can specify tool versions, domain names, etc.

1. Execute "/ansible/ext.sh" to install the external part

    ext.sh creates and copies a ssh key to communicate with the target machines. And it installs DNS(CoreDNS), Proxy(Envoy), Registry(Harbor), Git(Gitea), and CI(Jenkins) onto the target machines.

1. Execute "/ansible/init.sh" to setup environment for Kubernetes cluster

    init.sh do the jobs for ssh key and it installs basic Kubernetes tools.

1. Execute "/ansible/cluster.sh" to install Kubernetes cluster

    cluster.sh installs Kubernetes, CNI(Cilium), LoadBalancer(MetalLB), Dashboard(Kubernetes Dashboard), and CD(Argo CD) onto the target machines.
