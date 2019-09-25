#!/bin/bash 

#mapfile -t iplist < /home/nvidia/WD/measure_scripts/agvip.info
iplist=(30.113.151.71)

for element in ${iplist[@]}
do
    scp -P 2223 rc_local.sh quicktron@$element:/mnt/home/quicktron/
    scp -P 2223 rc.sh quicktron@$element:/mnt/home/quicktron/mptcp/measure/
done

