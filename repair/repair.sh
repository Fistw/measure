#!/bin/bash 

mapfile -t iplist < /home/nvidia/WD/measure_scripts/agvip.info
#iplist=(30.113.148.112)
for element in ${iplist[@]}
do
    ssh -p 2223 quicktron@$element 'echo quicktron |sudo -S chown -R quicktron:quicktron /mnt/home/quicktron'
    ssh -p 2223 quicktron@$element 'mv /mnt/home/quicktron/Netif_deamon.sh /mnt/home/quicktron/Netif_deamon.sh.20190926'
    #scp -P 2223 Netif_deamon.sh quicktron@$element:/mnt/home/quicktron    
    #scp -P 2223 a.sh quicktron@$element:/mnt/home/quicktron    
    ssh -p 2223 -q quicktron@$element 'echo quicktron | sudo -S /mnt/home/quicktron/a.sh'
    ssh -p 2223 quicktron@$element 'rm /mnt/home/quicktron/a.sh'
done
