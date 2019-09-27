#!/bin/bash 
mapfile -t iplist < /home/nvidia/WD/measure_scripts/scan/allagvip.info5
FILEPath=/home/nvidia/WD/measure_scripts/scan/erroragvip.info
touch $FILEPath
logfile=/home/nvidia/WD/measure_scripts/scan/scan.log
for element in ${iplist[@]}
do
	echo test $element >> $logfile
	arr=(${element//,/ })  
	ip0=${arr[0]}
	ip1=${arr[1]}
	lose_rate0=$(ping -c 2  $ip0 -W2 | grep packet\ loss | awk -F '%' '{print $1}' | awk '{print $NF}')
	lose_rate1=$(ping -c 2  $ip1 -W2 | grep packet\ loss | awk -F '%' '{print $1}' | awk '{print $NF}')
	if [[ "$lose_rate0" -eq 100 ]] && [[ "$lose_rate1" -eq 100 ]]
	then
		echo $element >> $FILEPath
		echo $element "has dual error" >> $logfile
	elif  [ "$lose_rate0" -eq 100 ]
	then
		echo $ip0 >> $FILEPath
		echo $element "has single error" >> $logfile
	elif  [ "$lose_rate1" -eq 100 ]
	then
		echo $ip1 >> $FILEPath
		echo $element "has single error" >> $logfile
	else
		echo $element "is dual NIC" >> $logfile
	fi
done
	
