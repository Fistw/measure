#!/bin/bash


# start staragent
sudo /etc/init.d/staragentctl restart

#add some private info
echo add your private script
cd /mnt/home/quicktron/wallehope/eva-local-driveunit-application-linux/
sudo ./startFull.sh start

sudo /mnt/home/quicktron/mptcp/measure/rc.sh

#add some plan
echo "quicktron" | sudo -S sed -i '/autoClearLog.sh/d' /etc/crontab
echo "quicktron" | sudo -S sed -i '/^[[:space:]]*$/d' /etc/crontab

echo " " | sudo tee -a /etc/crontab
echo "0 6 * * * quicktron /mnt/home/quicktron/wallehope/eva-local-driveunit-application-linux/autoClearLog.sh" | sudo tee -a /etc/crontab
echo "quicktron" | sudo -S service cron restart


exit 0
