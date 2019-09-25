#!/bin/bash


source $HOME/.keychain/${HOSTNAME}-sh
echo `date '+%Y-%m-%d %H:%M'`"  start run pull.sh" >> /home/nvidia/WD/measure_scripts/collect/collect.log

mapfile -t pullPid < /home/nvidia/WD/measure_scripts/collect/pid
for pid in ${pullPid[@]}
do
	echo "nvidia" | sudo -S kill -9 $pid
done
pgrep -f pull.sh > /home/nvidia/WD/measure_scripts/collect/pid

mapfile -t iplist < /home/nvidia/WD/measure_scripts/agvip.info

agvnum=${#iplist[@]}

while :
do
    for(( i=0; i<$agvnum; i++ ))
    do
        if [ "${iplist[i]}" != "" ] 
        then
            res=`ssh -p 2223 quicktron@${iplist[i]} "tail -n 20 /mnt/home/quicktron/wallehope/eva-local-driveunit-application-linux/logs/communication.log | grep 'dspStatus=DO_CHARGE'"`
	if [ "$res" != "" ] 
            then
                echo "${iplist[i]} is charging, start copying.."
                echo `date '+%Y-%m-%d %H:%M'`"  ${iplist[i]}: start copying" >> /home/nvidia/WD/measure_scripts/collect/collect.log
                ret=`scp -P 2223 -l 800 quicktron@"${iplist[i]}":/mnt/home/quicktron/mptcp/measure/tmp/* /home/nvidia/WD/data/"${iplist[i]}"`
                if [[ $ret -eq 0 ]]
                then
                    echo `date '+%Y-%m-%d %H:%M'`"  ${iplist[i]}"' is copyed: '`ssh -p 2223 quicktron@${iplist[i]} "ls /mnt/home/quicktron/mptcp/measure/tmp/"` >> /home/nvidia/WD/measure_scripts/collect/collect.log
                    echo `date '+%Y-%m-%d %H:%M'`"  ${iplist[i]}: copy success" >> /home/nvidia/WD/measure_scripts/collect/collect.log
                    ssh -p 2223 quicktron@${iplist[i]} "rm -rf /mnt/home/quicktron/mptcp/measure/tmp/*"
                    unset iplist[i]
                else
                    echo "${iplist[i]} :An error occurred while copying"
                    echo `date '+%Y-%m-%d %H:%M'`"  ${iplist[i]}: copy error" >> /home/nvidia/WD/measure_scripts/collect/collect.log
                fi
            else
                echo "${iplist[i]} is not charging.."
                echo `date '+%Y-%m-%d %H:%M'`"  ${iplist[i]} is not charging" >> /home/nvidia/WD/measure_scripts/collect/collect.log
            fi
        fi
    done

    echo "Remain: "${iplist[@]}
    echo `date '+%Y-%m-%d %H:%M'`"  Remain: "${iplist[@]} >> /home/nvidia/WD/measure_scripts/collect/collect.log
    if [[ ${#iplist[@]} -eq 0 ]]
    then
        echo `date '+%Y-%m-%d %H:%M'`"  Successful completion of operation" >> /home/nvidia/WD/measure_scripts/collect/collect.log
        exit 0
    fi
    echo "sleep 5 minutes"
    echo `date '+%Y-%m-%d %H:%M'`"  Sleep 5 minutes" >> /home/nvidia/WD/measure_scripts/collect/collect.log
    sleep 5m
done
