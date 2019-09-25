#!/bin/bash 

sudo cp /mnt/home/quicktron/mptcp/measure/services/* /lib/systemd/system/

if [ "`ls -A /mnt/home/quicktron/mptcp/measure/data`" != "" ];
then
	tar zcvf /mnt/home/quicktron/mptcp/measure/tmp/`ifconfig wlan0 | grep "inet " | awk '{ print $2}'`-`date +%Y%m%d%H%M`.tar.gz -C /mnt/home/quicktron/mptcp/measure data
	rm -rf /mnt/home/quicktron/mptcp/measure/data/*
fi


sudo systemctl daemon-reload
sudo systemctl start iwscan.service
sudo systemctl start conn.service
sudo systemctl start tcpprobe.service
sudo systemctl start tcpdump.service
sudo systemctl start pinggateway127.service
sudo systemctl start pinggateway151.service

echo "quicktron" | sudo -S sed -i '/crontab.sh/d' /etc/crontab
echo "0 0 * * * quicktron /mnt/home/quicktron/mptcp/measure/crontab.sh" | sudo tee -a /etc/crontab

