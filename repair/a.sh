#!/bin/bash 

sudo  pkill -f Netif
nohup sudo /mnt/home/quicktron/Netif_deamon.sh 30.113.129.7 30.113.151.254 &

