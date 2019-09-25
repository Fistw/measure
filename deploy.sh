#!/bin/bash 

#mapfile -t iplist < /home/nvidia/WD/measure_scripts/agvip.info
iplist=(30.113.149.8)
for element in ${iplist[@]}
do
    ssh -p 2223 quicktron@$element 'echo quicktron |sudo -S chown -R quicktron:quicktron /mnt/home/quicktron/mptcp'
    ssh -p 2223 quicktron@$element "rm -rf /mnt/home/quicktron/mptcp/measure"
    scp -P 2223 rc_local.sh quicktron@$element:/mnt/home/quicktron    
    scp -P 2223 -r measure/ quicktron@$element:/mnt/home/quicktron/mptcp 
    ssh -p 2223 quicktron@$element "echo "quicktron" | sudo -S /mnt/home/quicktron/mptcp/measure/rc.sh"
done
