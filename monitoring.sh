#!/bin/bash

MEMUSED=$(free -h | grep Mem | awk '{print $3}')
MEMFULL=$(free -h | grep Mem | awk '{print $2}')
MEMPERC=$(free -k | grep Mem | awk '{printf("%.2f%%"), ($3 / $2) * 100}')

DISKUSED=$(df -h --total | grep total | awk '{print $3}')
DISKFULL=$(df -h --total | grep total | awk '{print $2}')
DISKPERC=$(df -h --total | grep total | awk '{print $5}')

CPUCHARGE=$(top -bn1 | grep '^%Cpu' | cut -c 9 | xargs | awk '{printf("%.1f%%"), $1 + $3}')

LVMUSED="no"
if [ $(lsblk | grep lvem | wc -l) -eq 0 ];
	then LVMUSED="yes";
fi

IP=$(hostname -I | awk '{print $1}')
MAC=$(ip link show | grep link/ether | awk '{print $2}')

wall "  #Architecture   : $(uname -srvmo)
  #CPU physical   : $(grep 'physical id' /proc/cpuinfo | uniq |wc -l )
  #vCPU           : $(grep processor /proc/cpuinfo | uniq | wc -l)
  #Memory Usage   : $MEMUSED/$MEMFULL ($MEMPERC)
  #Disk Usage     : $DISKUSED/$DISKFULL ($DISKPERC)
  #CPU load       : $CPUCHARGE
  #Last boot      : $(who -b | awk '{print($3 " " $4)}')
  #LVM use        : $LVMUSED
  #Connexions TCP : $(grep TCP /proc/net/sockstat | awk '{print $3}') ESTABLISHED
  #User log       : $(who | wc -l)
  #Network        : IP $IP ($MAC)
  #Sudo           : $(grep COMMAND /var/log/sudo/sudo.log | wc -l)"
