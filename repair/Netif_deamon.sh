#!/bin/sh
VAR="$( cd "$( dirname "$0"  )" && pwd  )"
FILEPath=$VAR/netdeamon.log

echo `date +"%Y-%m-%d %H:%M:%S"` "begin ------------------------" >> $FILEPath

ping_disconnect_times=0
log_clear_flag=0

wlan0_mtcp_times=0
wlan1_mtcp_times=0
wlan1_hw_times=0
wlan0_ip=$(ifconfig wlan0 | grep inet\ addr | awk '{print $2}')
wlan0_ip=${wlan0_ip/addr:/}


wlan1_ip=$(ifconfig wlan1 | grep inet\ addr | awk '{print $2}')
wlan1_ip=${wlan1_ip/addr:/}

log_deamon()
{
#clear log
let log_clear_flag="$log_clear_flag"+1
if [ "$log_clear_flag" -eq 1000 ]
then
	log_clear_flag=0	
	filesize=`ls -l $FILEPath | awk '{ print $5 }'`
	#echo fileszie=$filesize
	if [ "$filesize" -gt 100000000 ] 
	then
		true > $FILEPath
		#echo fileszie=$filesize
	fi
fi
sync
}

route_deamon()
{
#deamon for route
route_num=$(sudo route | grep -c default)
#echo route_num=${route_num}
wlan0_essid=$(iwconfig wlan0 | grep -c Not-Associated )
wlan1_essid=$(iwconfig wlan1 | grep -c Not-Associated )
lose_rate=$(ping -c2 -Iwlan0 30.113.151.254 -W2 | grep packet\ loss | awk -F '%' '{print $1}' | awk '{print $NF}')
lose_rate1=$(ping -c2 -Iwlan1 30.113.127.254 -W2| grep packet\ loss | awk -F '%' '{print $1}' | awk '{print $NF}')
if [ "$route_num" -eq 0 ]
then
	if [ "$wlan0_essid" -eq 1 ]
	then
		ip route add default scope global nexthop via 30.113.127.254 dev wlan1
	else
		ip route add default scope global nexthop via 30.113.151.254 dev wlan0
	fi
elif [ "$route_num" -eq 1 ]
then
	route_ip=$(sudo route | grep default | awk '{print $2}' | awk -F '.' '{print $3}')
	if [ "$route_ip" -eq 151 ]
	then
		if [[ "$wlan0_essid" -eq 1 ]] || [[ "$lose_rate" -eq 100 ]] && [[ "$lose_rate1" -eq 0 ]]
		then
			ip route del default scope global
			ip route add default scope global nexthop via 30.113.127.254 dev wlan1
			echo `date +"%Y-%m-%d %H:%M:%S"` "wlan0_essid route" >> $FILEPath
		elif [ "$wlan1_essid" -eq 0 ]
		then
			route add default gw 30.113.127.254
		fi
	elif [ "$route_ip" -eq 127 ]
	then
		if [[ "$wlan1_essid" -eq 1 ]] || [[ "$lose_rate" -eq 0 ]]
		then
			ip route del default scope global
			ip route add default scope global nexthop via 30.113.151.254 dev wlan0
			echo `date +"%Y-%m-%d %H:%M:%S"` "wlan1_essid route" >> $FILEPath
		fi
	fi
fi
}

reup_wlan0()
{
   ifconfig wlan0 down
   sleep 2
   ifconfig wlan0 up
   sleep 5
   /mnt/home/quicktron/mptcp/route.sh
   #route add default gw 30.113.151.254
   echo `date +"%Y-%m-%d %H:%M:%S"` reup wlan0 >> $FILEPath

}

reup_wlan1()
{
   
   if [[ "$wlan1_hw_times" -eq 2 ]] || [[ "$wlan1_hw_times%5" -eq 0 ]]
   then
	sudo rmmod 8812au.ko	
        sudo cp /home/quicktron/Desktop/rtl8812au-master/8812au.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless/
        sudo insmod /lib/modules/`uname -r`/kernel/drivers/net/wireless/8812au.ko
	#wlan1_hw_times=0
	echo `date +"%Y-%m-%d %H:%M:%S"` "reup wlan1_hw" >> $FILEPath
	sleep 5
   fi
   let wlan1_hw_times="$wlan1_hw_times"+1
   ifconfig wlan1 down
   sleep 2 
   ifconfig wlan1 up
   sleep 5
   /mnt/home/quicktron/mptcp/route.sh 
   route add default gw 30.113.127.254
   echo `date +"%Y-%m-%d %H:%M:%S"` "reup wlan1" >> $FILEPath
}

checkwlan0(){
	s=`iwconfig wlan0 | egrep 'Signal level' | awk '{print $4}'`
	s=${s##*=}
	if [ $s -lt -75 ]; then
		sudo iwlist wlan0 scan > wlan0.txt

		while read line; do 

			## Reset variables on new network 
			[[ "$line" =~ Cell || "$line" == "" ]] && { 
				network=""
			} 

			## Test line content and parse as required 
			[[ "$line" =~ Quality ]] && { 
				qual=${line##*ity=} 
				qual=${qual%% *} 
				lvl=${line##*evel=} 
				lvl=${lvl%% *} 
			}
			[[ "$line" =~ ESSID ]] && { 
				essid=${line##*ID:} 
			} 
			if [[ $essid =~ "cainiao-AGV" ]]; then
				if [ $lvl -gt -60 ]; then
					echo $lvl
					return 1
				fi
			fi
			
		done < wlan0.txt
	fi
	
	return 0
}

while [ "$2" != "" ]
do

log_deamon

checkwlan0
ret=$?
if [ $ret -eq 1 ]; then
	sudo wpa_cli -i wlan0 reassociate
	echo `date +"%Y-%m-%d %H:%M:%S"` reassociate wlan0 >> $FILEPath
	sleep 2
fi
#############################################################################################################
#connection check with ping
lose_rate=$(ping -c 2 -Iwlan0 $2 -W2 | grep packet\ loss | awk -F '%' '{print $1}' | awk '{print $NF}')
lose_rate1=$(ping -c 2 -Iwlan1 30.113.127.254 -W 2| grep packet\ loss | awk -F '%' '{print $1}' | awk '{print $NF}')
if [[ "$lose_rate" -eq 100 ]] &&  [[ "$lose_rate1" -eq 100 ]]
#if [ "$lose_rate" -eq 100 ]
then
	let ping_disconnect_times="$ping_disconnect_times"+1
	echo `date +"%Y-%m-%d %H:%M:%S"` "ping_disconnect_times:$ping_disconnect_times"  >> $FILEPath
else
	ping_disconnect_times=0
fi

if [ "$ping_disconnect_times" -gt 4 ]
then
	echo `date +"%Y-%m-%d %H:%M:%S"` "reboot one times------------------------"  >> $FILEPath
	sync	
	reboot -f
fi
#############################################################################################################


line_num=$(netstat -n | grep ESTABLISHED | grep -c $1:7070)
#echo $1 
wlan0_essidShow=$(iwconfig wlan0 | grep -c cainiao-AGV )
if [ "$wlan0_essidShow" -eq 1 ]
then
#tcp connection check on wlan0
	if [ "$line_num" -eq 1 ]
	then			
		wlan_ip0=$(netstat -n | grep ESTABLISHED | grep $1:7070 | awk '{print $4}')    
		wlan_ip0=${wlan_ip0/:*/}      
		if [ "$wlan_ip0" == "$wlan1_ip" ]
		then	
			ip link set dev wlan0 multipath off
			sleep 1
			ip link set dev wlan0 multipath on      
			echo `date +"%Y-%m-%d %H:%M:%S"` "reup mptcp_on wlan0 line_num=$line_num" >> $FILEPath
			sleep 5	
			#route add default gw 30.113.151.254		
		fi
	elif [ "$line_num" -eq 2 ]
	then
		wlan_ip0=$(netstat -n | grep ESTABLISHED | grep $1:7070 | awk '{print $4}' | head -n 1)     
		wlan_ip0=${wlan_ip0/:*/}   
		wlan_ip1=$(netstat -n | grep ESTABLISHED | grep $1:7070 | awk '{print $4}' | tail -n 1)   
		wlan_ip1=${wlan_ip1/:*/}

		if [ "$wlan_ip0" == "$wlan_ip1" ]
		then
			if [ "$wlan_ip0" == "$wlan1_ip" ]
			then
			    ip link set dev wlan0 multipath off
			    sleep 1
			    ip link set dev wlan0 multipath on      
			    echo `date +"%Y-%m-%d %H:%M:%S"` reup mptcp on wlan0 line_num="$line_num">> $FILEPath
			    sleep 5
			    #route add default gw 30.113.151.254
			fi
		fi
	else
	    echo `date +"%Y-%m-%d %H:%M:%S"` "wlan0 no connection or more connection line_num=$line_num">> $FILEPath
	fi

else
	reup_wlan0
fi

line_num=$(netstat -n | grep ESTABLISHED | grep -c $1:7070)
wlan1_essidShow=$(iwconfig wlan1 | grep -c Quicktron-AGV )
if [ "$wlan1_essidShow" -eq 1 ]
then
#tcp connection check on wlan1
	if [ "$line_num" -eq 1 ]
	then
		wlan_ip0=$(netstat -n | grep ESTABLISHED | grep $1:7070 | awk '{print $4}')
		#echo ${wlan_ip0}       
		wlan_ip0=${wlan_ip0/:*/}
		#echo ${wlan_ip0}       
		if [ "$wlan_ip0" == "$wlan0_ip" ]
		then
			ip link set dev wlan1 multipath off
			sleep 1
			ip link set dev wlan1 multipath on      
			echo `date +"%Y-%m-%d %H:%M:%S"` "reup mptcp_on wlan1i$i line_num=$line_num" >> $FILEPath
			sleep 6	
			#let wlan1_hw_times="$wlan1_hw_times"+1
			#route add default gw 30.113.127.254		
		fi
	elif [ "$line_num" -eq 2 ]
	then
		wlan_ip0=$(netstat -n | grep ESTABLISHED | grep $1:7070 | awk '{print $4}' | head -n 1)     
		wlan_ip0=${wlan_ip0/:*/}     
		wlan_ip1=$(netstat -n | grep ESTABLISHED | grep $1:7070 | awk '{print $4}' | tail -n 1)     
		wlan_ip1=${wlan_ip1/:*/}
	
		if [ "$wlan_ip0" == "$wlan_ip1" ]
		then
			if [ "$wlan_ip0" == "$wlan0_ip" ]
			then
			    ip link set dev wlan1 multipath off
			    sleep 1
			    ip link set dev wlan1 multipath on      
			    echo `date +"%Y-%m-%d %H:%M:%S"` "reup mptcp on wlan1 line_num=$line_num">> $FILEPath
			    sleep 3
			    #route add default gw 30.113.127.254
			fi
		fi
	else
	    echo `date +"%Y-%m-%d %H:%M:%S"` "wlan1 no connection or more connection line_num=$line_num">> $FILEPath
	fi
	wlan1_hw_times=0
else

	reup_wlan1
fi

#########################################################################################################################

route_deamon

sleep 5
#while true do
done
#don't come to here
exit 1

