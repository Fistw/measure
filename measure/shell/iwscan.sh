#!/bin/bash 

while :
do
	file='/mnt/home/quicktron/mptcp/measure/data/scan.'`date +%s`'.dat'

	for ((i=0; i<5000; i ++)) do
		echo '{"dev": "wlan0", "stime": '`date +%s.%N`', "list": [' >> $file
		sudo iwlist wlan0 scan > wlan0.txt

		while read line; do 

			## Reset variables on new network 
			[[ "$line" =~ Cell || "$line" == "" ]] && { 

			 # If we already found one network then echo its information 
			 if [[ "$network" != "" ]] 
			 then 
				if [[ "$network" =~ "cainiao-AGV" ]] 
				then 
					echo "$network, " >> $file; 
				fi
			fi
			 network="" 
			} 

			## Test line content and parse as required 
			[[ "$line" =~ Address ]] && mac=${line##*ss: } 
			[[ "$line" =~ \(Channel ]] && { chn=${line##*nel }; chn=${chn:0:$((${#chn}-1))}; } 
			[[ "$line" =~ Frequen ]] && { frq=${line##*ncy:}; frq=${frq%% *}; } 
			[[ "$line" =~ Quality ]] && { 
			 qual=${line##*ity=} 
			 qual=${qual%% *} 
			 lvl=${line##*evel=} 
			 lvl=${lvl%% *} 
			} 


			## The ESSID is the last line of the basic channel data, so build information string now 
			[[ "$line" =~ ESSID ]] && { 
			 essid=${line##*ID:} 
			 network="$mac $essid $frq $chn $qual $lvl" # output after ESSID 
			} 


		done < wlan0.txt

		echo '], "etime": '`date +%s.%N`',' >> $file
		echo '"now": '\"`iwconfig wlan0 | egrep 'Access|Signal level' | awk '{print $2, $4, $6}'`\"'}||' >> $file
		
		echo '{"dev": "wlan1", "stime": '`date +%s.%N`', "list": [' >> $file
		
		
		sudo iwlist wlan1 scan > wlan1.txt

		while read line; do 

			## Reset variables on new network 
			[[ "$line" =~ Cell || "$line" == "" ]] && { 

			 # If we already found one network then echo its information 
			 if [[ "$network" != "" ]] 
			 then 
				if [[ "$network" =~ "Quicktron-AGV" ]] 
				then 
					echo "$network, " >> $file;
				fi
			fi
			 network="" 
			} 

			## Test line content and parse as required 
			[[ "$line" =~ Address ]] && mac=${line##*ss: } 
			[[ "$line" =~ \(Channel ]] && { chn=${line##*nel }; chn=${chn:0:$((${#chn}-1))}; } 
			[[ "$line" =~ Frequen ]] && { frq=${line##*ncy:}; frq=${frq%% *}; } 
			[[ "$line" =~ Quality ]] && { 
			 qual=${line##*ity=} 
			 qual=${qual%% *} 
			 lvl=${line##*evel=} 
			 lvl=${lvl%% *} 
			 network="$mac $essid $frq $chn $qual $lvl" # output after ESSID 

			} 


			## The ESSID is the last line of the basic channel data, so build information string now 
			[[ "$line" =~ ESSID ]] && { 
			 essid=${line##*ID:} 
			} 


		done < wlan1.txt

		echo '], "etime": '`date +%s.%N`',' >> $file
		echo '"now": '\"`iwconfig wlan1 | egrep 'Access|Signal level' | awk '{print $2, $4, $6}'`\"'}||' >> $file
		
	done
done
