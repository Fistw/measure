#!/bin/bash 

cp /home/nvidia/WD/measure_scripts/scan/allagvip.info /home/nvidia/WD/measure_scripts/scan/allagvip.info0

logfile=/home/nvidia/WD/measure_scripts/scan/scan.log

times=0
for ((i=0; i<5; ))
do
	mapfile -t iplist < /home/nvidia/WD/measure_scripts/scan/allagvip.info$i
	let i++
	FILEPath=/home/nvidia/WD/measure_scripts/scan/allagvip.info$i
	touch $FILEPath
	
	echo `date +"%Y-%m-%d %H:%M:%S"` "Start $i th scanning..." >> $logfile
	
	for element in ${iplist[@]}
	do
		echo scaning $element >> $logfile
		arr=(${element//,/ })  
		ip0=${arr[0]}
		ip1=${arr[1]}
		lose_rate0=$(ping -c 2  $ip0 -W2 | grep packet\ loss | awk -F '%' '{print $1}' | awk '{print $NF}')
		lose_rate1=$(ping -c 2  $ip1 -W2 | grep packet\ loss | awk -F '%' '{print $1}' | awk '{print $NF}')
		if [[ "$lose_rate0" -eq 100 ]] || [[ "$lose_rate1" -eq 100 ]]
		then
			echo $element >> $FILEPath
			echo $element "has error" >> $logfile
		else
			echo $element "is dual NIC" >> $logfile
		fi
	done
	echo `date +"%Y-%m-%d %H:%M:%S"` "Finish $i th scanning..." >> $logfile
	
done


