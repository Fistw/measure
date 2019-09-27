#!/bin/bash

read -t 20 -p "input the network ip(such as: 30.113.148.):" network

#for((i=1;i<=254;i++)); 
for((i=164;i<165;i++)); 

  do { ping -c 1 $network$i >>aa


{
if ( cat aa | grep ttl ); then
   
   echo $network$i >>ip.list
   
  fi
}

rm -rf aa
}
    

done
