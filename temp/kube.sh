#!/bin/sh

my_exit() {
	echo "Usage: ./kube.sh [run|ssh|shutdown] [all|ext|0|1|2]"
	echo "run : Run a virtual machine"
	echo "ssh : Login to a virtual machine"
	echo "shutdown : Shut down a virtual machine"
	echo "all, ext, 0, 1, 2 : For each virtual machine"
	exit
}

if [ $# -ne 2 ]; then
	my_exit
fi

VM_USER=kube
SSH_PORT=8022

get_vm_info() {
	if [ $1 = "ext" ]; then
		VM_NAME="ubuntu server ext"
	elif [ $1 = "0" ]; then
		VM_NAME="vm0"
		VM_IP=10.0.3.10
	elif [ $1 = "1" ]; then
		VM_NAME="vm1"
		VM_IP=10.0.3.11
	fi
}

run_vm() {
	get_vm_info $1
	VBoxManage startvm "$VM_NAME" --type headless
}

ssh_vm() {
	get_vm_info $1
	if [ $1 = "ext" ]; then
		ssh -p $SSH_PORT $VM_USER@localhost
	else
		ssh -J $VM_USER@localhost:$SSH_PORT $VM_USER@$VM_IP
	fi
}

shutdown_vm() {
	get_vm_info $1
	if [ $1 = "ext" ]; then
		ssh -p $SSH_PORT $VM_USER@localhost "echo kube | sudo -S shutdown now"
	else
		ssh -J $VM_USER@localhost:$SSH_PORT $VM_USER@$VM_IP "echo kube | sudo -S shutdown now"
	fi
}

if [ $1 = "run" ]; then
	for vm in "ext" "0" "1"
	do
		if [ $2 = "all" ] || [ $2 = $vm ]; then
			run_vm $vm
		fi
	done
elif [ $1 = "ssh" ]; then
	ssh_vm $2
elif [ $1 = "shutdown" ]; then
	for vm in "0" "1" "ext"
	do
		if [ $2 = "all" ] || [ $2 = $vm ]; then
			shutdown_vm $vm
		fi
	done
fi

