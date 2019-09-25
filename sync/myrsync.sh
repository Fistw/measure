#!/bin/bash

echo `date '+%Y-%m-%d %H:%M'`"   Start sync......" >> /home/nvidia/WD/measure_scripts/sync/sync.log
rsync -r -avz /home/nvidia/WD/data/ fuliyu@49.232.43.8:/home/fuliyu/data >> /home/nvidia/WD/measure_scripts/sync/sync.log
echo `date '+%Y-%m-%d %H:%M'`"   Finished sync..." >> /home/nvidia/WD/measure_scripts/sync/sync.log
echo -e "\n\n\n" >> /home/nvidia/WD/measure_scripts/sync/sync.log
