#!/bin/bash 

echo "quicktron" | sudo -S sed -i '/crontab.sh/d' /etc/crontab
echo "quicktron" | sudo -S service cron restart


sudo systemctl stop iwscan.service
sudo systemctl stop conn.service
sudo systemctl stop tcpprobe.service
sudo systemctl stop tcpdump.service
sudo systemctl stop pinggateway127.service
sudo systemctl stop pinggateway151.service

sudo rm -rf /lib/systemd/system/iwscan.service
sudo rm -rf /lib/systemd/system/conn.service
sudo rm -rf /lib/systemd/system/tcpprobe.service
sudo rm -rf /lib/systemd/system/tcpdump.service
sudo rm -rf /lib/systemd/system/pinggateway127.service
sudo rm -rf /lib/systemd/system/pinggateway151.service

sudo systemctl daemon-reload


sudo rm -rf /mnt/home/quicktron/mptcp/measure


