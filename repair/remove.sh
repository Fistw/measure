#!/bin/bash 

mapfile -t iplist < /home/nvidia/WD/measure_scripts/agvip.info

for element in ${iplist[@]}
do
    echo $element
    scp -P 2223 a.sh quicktron@$element:/mnt/home/quicktron/mptcp/
    scp -P 2223 rc_local.sh quicktron@$element:/mnt/home/quicktron/
    ssh -p 2223 quicktron@$element "/mnt/home/quicktron/mptcp/a.sh"
    ssh -p 2223 quicktron@$element "rm /mnt/home/quicktron/mptcp/a.sh"
done
