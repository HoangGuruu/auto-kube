#!/bin/zsh

IP_EXT=192.168.128.9
IP_0=192.168.128.10
IP_1=192.168.128.11
IP_2=192.168.128.12
GUEST_E=kube@$IP_EXT
GUEST_0=kube@$IP_0
GUEST_1=kube@$IP_1
GUEST_2=kube@$IP_2

SSH='ssh -o ConnectionAttempts=1 -o ConnectTimeout=1'
alias myssh=$SSH

if [ $# -eq 0 ]; then
    tmux new -s kube -n vm0 "$SSH $GUEST_0" \; \
	neww -n vm1 "$SSH $GUEST_1" \; \
	neww -n vmext "$SSH $GUEST_E" \; \
	neww -n host
elif [ $# -eq 1 ]; then
	if [ $1 = 'e' ]; then
		myssh $GUEST_E
	elif [ $1 = '0' ]; then
		myssh $GUEST_0
	elif [ $1 = '1' ]; then
		myssh $GUEST_1
	elif [ $1 = 'off' ]; then
		myssh $GUEST_0 "echo kube | sudo -S poweroff"
		myssh $GUEST_1 "echo kube | sudo -S poweroff"
		myssh $GUEST_E "echo kube | sudo -S poweroff"
	fi
fi

unalias myssh
exit 0

