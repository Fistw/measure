#!/bin/bash 

echo "quicktron" | sudo -S systemctl stop iwscan.service
echo "quicktron" | sudo -S systemctl stop conn.service
echo "quicktron" | sudo -S systemctl stop tcpprobe.service
echo "quicktron" | sudo -S systemctl stop tcpdump.service
echo "quicktron" | sudo -S systemctl stop pinggateway127.service
echo "quicktron" | sudo -S systemctl stop pinggateway151.service

tar zcvf /mnt/home/quicktron/mptcp/measure/tmp/`ifconfig wlan0 | grep "inet " | awk '{ print $2}'`-`date +%Y%m%d%H%M`.tar.gz -C /mnt/home/quicktron/mptcp/measure data
rm -rf /mnt/home/quicktron/mptcp/measure/data/*

find  /mnt/home/quicktron/mptcp/measure/tmp -mtime +5 -name "*.gz" -exec rm -rf {} \;

echo "quicktron" | sudo -S systemctl start iwscan.service
echo "quicktron" | sudo -S systemctl start conn.service
echo "quicktron" | sudo -S systemctl start tcpprobe.service
echo "quicktron" | sudo -S systemctl start tcpdump.service
echo "quicktron" | sudo -S systemctl start pinggateway127.service
echo "quicktron" | sudo -S systemctl start pinggateway151.service

cp /mnt/home/quicktron/wallehope/eva-local-driveunit-application-linux/logs/communication.log.`date +%Y-%m-%d -d "1 day ago" `* /mnt/home/quicktron/mptcp/measure/tmp

