#!/bin/bash

# begin start ping test output the file for the next spcrit

./child/ping.sh

#read the file line by line

cat ip.list | while read line

# return to implement the log.sh spcrit

do
 
./child/login.sh $line 30.113.128.50

done

#delete the file

rm -rf ip.list
