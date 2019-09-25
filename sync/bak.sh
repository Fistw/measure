#!/bin/bash 

mapfile -t iplist < /home/nvidia/WD/measure_scripts/agvip.info

mv /home/nvidia/WD/data /home/nvidia/WD/archive/
mv /home/nvidia/WD/archive/data /home/nvidia/WD/archive/`date '+%Y-%m-%d'`

mkdir /home/nvidia/WD/data
for element in ${iplist[@]}
do
    mkdir /home/nvidia/WD/data/$element
done
