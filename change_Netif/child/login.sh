#!/usr/bin/expect -f


set timeout 5

set ip [ lindex $argv 0 ]
set server [ lindex $argv 1 ]


spawn ssh  quicktron@$ip -p 2223 

expect {
  "yes/no" {send "yes\r";exp_continue}
 }

expect "desktop:~$"
  send "sudo su\r"

expect "quicktron:"
  send "quicktron\r"

expect "quicktron#"
  send "cd /mnt/home/quicktron\r"

expect "quicktron#"
  send "pkill -f Netif\r"
expect "quicktron#"
  send "mv Netif_deamon.sh Netif_deamon.20190927.sh\r"
expect "quicktron#"
  send "scp nvidia@$server:/home/nvidia/WD/measure_scripts/repair/Netif_deamon.sh .\r"
expect {
  "yes/no" {send "yes\r";exp_continue}
 }
expect "password:"
  send "nvidia\r"
expect "quicktron#"
  send "sh /mnt/home/quicktron/Netif_deamon.sh 30.113.129.7 30.113.151.254 &\r"

expect "quicktron#"
  send "exit\r"

expect "desktop:~$"
  send "exit\r"

expect eof
