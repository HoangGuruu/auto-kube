#!/bin/zsh

GUEST_E=kube@10.0.3.9
GUEST_0=kube@10.0.3.10
GUEST_1=kube@10.0.3.11

SSH_JUMP='-J kube@localhost:8022'
SSH="ssh -o ConnectionAttempts=2 -o ConnectTimeout=2 $SSH_JUMP"
alias myssh=$SSH

if [ $# -eq 0 ]; then
    tmux new -s kube -n vmext "$SSH $GUEST_E" \; \
    neww -n vm0 "$SSH $GUEST_0" \; \
    neww -n vm1 "$SSH $GUEST_1" \; \
    neww -n host
elif [ $# -eq 1 ]; then
    if [ $1 = 'e' ]; then
        myssh $GUEST_E
    elif [ $1 = '0' ]; then
        myssh $GUEST_0
    elif [ $1 = '1' ]; then
        myssh $GUEST_1
    elif [ $1 = 'off' ]; then
        myssh $GUEST_1 "echo kube | sudo -S poweroff"
        myssh $GUEST_0 "echo kube | sudo -S poweroff"
        myssh $GUEST_E "echo kube | sudo -S poweroff"
    fi
fi

unalias myssh
exit 0

