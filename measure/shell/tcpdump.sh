#!/bin/bash 

file='/mnt/home/quicktron/mptcp/measure/data/tcpdump.'`date +%s`'.pcap'
sudo tcpdump -i any tcp and host 30.113.129.7 -C 20 -W 20 -w $file