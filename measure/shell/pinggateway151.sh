#!/bin/bash 

file151='/mnt/home/quicktron/mptcp/measure/data/ping151.'`date +%s`'.dat'
while :
do
	ping -c100 -Iwlan0 30.113.151.254 -D >> $file151
done
