#!/bin/sh

ansible-playbook -i inventories/vbox.yaml -K playbooks/make-cluster.yaml

