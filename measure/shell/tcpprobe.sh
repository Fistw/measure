#!/bin/bash 
cd /mnt/home/quicktron/mptcp/measure/shell
make
file='/mnt/home/quicktron/mptcp/measure/data/tcpprobe.'`date +%s`'.dat'
sudo insmod /mnt/home/quicktron/mptcp/measure/shell/tcp_probe.ko full=1 port=7070
sudo cat /proc/net/tcpprobe > $file
