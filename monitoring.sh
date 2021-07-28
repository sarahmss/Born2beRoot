#!/bin/bash

ARCH=$(uname -a)
VIRTUAL_CPU=$(grep "^processor" /proc/cpuinfo | wc -l)
PHYSICAL_CPU=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
RAM_AVAILABLE=$(free -m | awk '$1 == "Mem:" {print $2}')
RAM_USED=$(free -m | awk '$1 == "Mem:" {print $3}')
RAM_PERCENTUAL=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
DISK_AVAILABLE=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
DISK_USED=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $3} END {print ut}')
DISK_PERCENTUAL=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3}{ft += $2} END {printf("%d"), ut/ft*100}')
CPU_PERCENTUAL=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs  | awk '{printf("%1.f%%"), $1 + $3}')
LAST_BOOT=$(who -b | awk '$1 == "system" {print $3 " " $4}')
LVM_TEMP=$(lsblk | grep "lvm" | wc -l)
LVMU=$(if [$LVM_TEMP -eq 0 ]; then echo no; else echo yes; fi)
ACTIVE_CONNECTIONS=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
USERS=$(users | wc -w)
IP=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
COMMANDS=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "
	#Architecture:	  $ARCH
	#CPU physical:	  $PHYSICAL_CPU
	#vCPU: 		  $VIRTUAL_CPU
	#Memory Usage:	  $RAM_USED/${RAM_AVAILABLE}Gb ($RAM_PERCENTUAL%)
	#Disk Usage:	  $DISK_USED/${DISK_AVAILABLE}Gb ($DISK_PERCENTUAL%)
	#CPU load:	  $CPU_PERCENTUAL
	#Last boot:	  $LAST_BOOT
	#LVM use: 	  $LVMU
	#TCP Connections: $ACTIVE_CONNECTIONS
	#User log: 	  $USERS
	#Network:         IP $IP ($MAC)
	#Sudo:	          $COMMANDS cmd
"
