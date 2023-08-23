#!/bin/sh

# Generate ssh keys if there are no keys
ls ~/.ssh/id*.pub > /dev/null 2> /dev/null
if [ $? -ne 0 ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ''
fi

# Find out all remote addresses and user from the inventory file
inv_path='inventories/vbox.yaml'
remotes=$(cat $inv_path | grep ansible_host: | sed -E "s/[ $(echo -e '\t')]*ansible_host: ([0-9.]+)/\1/" | sort | uniq)
user=$(cat $inv_path | grep ansible_user: | head -1 | sed -E "s/[ $(echo -e '\t')]*ansible_user: (.*)/\1/")

# Copy the ssh public key to the remotes
alias my-ssh-copy='ssh-copy-id -o ConnectionAttempts=1 -o ConnectTimeout=1'
for remote in $remotes; do
    echo "Copying ssh key to $remote ..."
    my-ssh-copy $user@$remote
done
unalias my-ssh-copy

# Run ansible scripts
ansible-playbook -i $inv_path -K playbooks/init.yaml

