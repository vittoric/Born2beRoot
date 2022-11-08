#!/bin/bash

# sis arqh
arq=$(uname -a)

# physical cpu
cpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# virtual cpu
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM
total_ram=$(free -m | grep Mem | awk '{print $2}')
used_ram=$(free -m | grep Mem | awk '{print $3}')
percent_ram=$(free -m | grep Mem | awk '{printf("%.2f"), $3/$2*100}')

# DISK
total_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_total += $2} END {printf ("%.1fGb\n"), disk_total/1024}')
used_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_use += $3} END {print disk_use}')
percent_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_use += $3} {disk_total+= $2} END {printf("%d"), disk_use/disk_total*100}')

#CPU load
cpuload=$(top -bn1 | grep %Cpu\(s\): | awk '{printf("%.2f", $2+$4)}')

#Last boot
lboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM USE
lvmuse=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP CONNEXIONS
tcpc=$(ss -ta | grep ESTAB | wc -l)

# USER LOG
userslg=$(users | wc -w)

# NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# SUDO
nbrsudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall  "
	Arquitecture: $arq
	CPU physical: $cpu
	 CPU virtual: $vcpu
	Memory Usage: $used_ram/${total_ram}MB ($percent_ram%)
	  Disk Usage: $used_disk/${total_disk} ($percent_disk%)
	    CPU load: $cpuload%
	   Last boot: $lboot
	     LVM use: $lvmuse
     Connections TCP: $tcpc ESTABLISHED
     	    User log: $userslg
	     Network: IP $ip ($mac)
	        Sudo: $nbrsudo cmd

	"