#!/usr/bin/bash

interfaces=$(/usr/bin/ip -brief address show | awk '{print $1}' | grep -v lo )
echo $interfaces

numb_of_interfaces=$(/usr/bin/ip -brief address show | awk '{print $1}' | grep -v lo | wc -l)
counter=0
for interface in $interfaces;
do
        test_connection=$(/usr/bin/ping -I $interface -c 1 google.it);
        rc_test=$?
        if [ $rc_test != 0 ]; then
                let counter++
        fi
done

if [ $counter == $numb_of_interfaces ]; then
        /usr/bin/cp /etc/network/interfaces_backup /etc/network/interfaces  ### It is required to have a backup file with network configuration that works 
        systemctl restart networking.service
        echo "services restartard"
else
        echo "nothing to do"
fi
