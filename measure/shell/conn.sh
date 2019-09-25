#!/bin/bash 

while :
do
	file='/mnt/home/quicktron/mptcp/measure/data/conn.'`date +%s`'.dat'
	
	wlan00=`iwconfig wlan0 | egrep 'Access|Signal level' | awk '{print $2, $4, $6}'`
	wlan10=`iwconfig wlan1 | egrep 'Access|Signal level' | awk '{print $2, $4, $6}'`
	for ((i=0; i<1000000; i ++)) do
		wlan01=`iwconfig wlan0 | egrep 'Access|Signal level' | awk '{print $2, $4, $6}'`
		if [ "$wlan00" != "$wlan01" ] 
		then
			echo '{"dev": "wlan0", "time": '`date +%s.%N`', "now": '\"{$wlan01}\"'}||' >> $file
			wlan00=$wlan01
		fi
		
		wlan11=`iwconfig wlan1 | egrep 'Access|Signal level' | awk '{print $2, $4, $6}'`
		if [ "$wlan10" != "$wlan11" ] 
		then
			echo '{"dev": "wlan1", "time": '`date +%s.%N`', "now": '\"{$wlan11}\"'}||' >> $file
			wlan10=$wlan11
		fi
	done
done
