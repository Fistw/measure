#!/bin/bash 

file127='/mnt/home/quicktron/mptcp/measure/data/ping127.'`date +%s`'.dat'
while :
do
	ping -c100 -Iwlan1 30.113.127.254 -D >> $file127
done
