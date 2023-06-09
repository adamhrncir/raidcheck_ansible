#!/bin/bash

source /etc/raidcheck.conf

# dirve 0
physDrive0Id=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:0] -aALL | grep 'Device Id:' | awk '{print $3}')
physDrive0Media=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:0] -aALL | grep 'Media Error Count:' | awk '{print $4}')
physDrive0Other=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:0] -aALL | grep 'Other Error Count:' | awk '{print $4}')

# drive 1
physDrive1Id=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:1] -aALL | grep 'Device Id:' | awk '{print $3}')
physDrive1Media=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:1] -aALL | grep 'Media Error Count:' | awk '{print $4}')
physDrive1Other=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:1] -aALL | grep 'Other Error Count:' | awk '{print $4}')

# drive 2
physDrive2Id=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:2] -aALL | grep 'Device Id:' | awk '{print $3}')
physDrive2Media=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:2] -aALL | grep 'Media Error Count:' | awk '{print $4}')
physDrive2Other=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:2] -aALL | grep 'Other Error Count:' | awk '{print $4}')

# drive 3
physDrive3Id=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:3] -aALL | grep 'Device Id:' | awk '{print $3}')
physDrive3Media=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:3] -aALL | grep 'Media Error Count:' | awk '{print $4}')
physDrive3Other=$(/usr/sbin/megacli -PDInfo -PhysDrv [$encID:3] -aALL | grep 'Other Error Count:' | awk '{print $4}')

# logical drive 0
logDrvState=$(/usr/sbin/megacli -LDInfo -L0 -a0 | grep 'State' | awk '{print $3}')


# on fail function
fail () {
    echo "$(date +"%F") Error, check /tmp/raidfail.log" >> $logDest

    echo "Raid check" > /tmp/raidfail.log
    echo "$(date +"%d.%m.%Y_%H:%M")" >> /tmp/raidfail.log
    echo "" >> /tmp/raidfail.log
    echo "Virtual drive state: $logDrvState" >> /tmp/raidfail.log

    echo "" >> /tmp/raidfail.log
    echo "Drive ID: $physDrive0Id" >> /tmp/raidfail.log
    echo "Meida Error: $physDrive0Media" >> /tmp/raidfail.log
    echo "Other Error: $physDrive0Other" >> /tmp/raidfail.log

    echo "" >> /tmp/raidfail.log
    echo "Drive ID: $physDrive1Id" >> /tmp/raidfail.log
    echo "Meida Error: $physDrive1Media" >> /tmp/raidfail.log
    echo "Other Error: $physDrive1Other" >> /tmp/raidfail.log

    echo "" >> /tmp/raidfail.log
    echo "Drive ID: $physDrive2Id" >> /tmp/raidfail.log
    echo "Meida Error: $physDrive2Media" >> /tmp/raidfail.log
    echo "Other Error: $physDrive2Other" >> /tmp/raidfail.log

    echo "" >> /tmp/raidfail.log
    echo "Drive ID: $physDrive3Id" >> /tmp/raidfail.log
    echo "Meida Error: $physDrive3Media" >> /tmp/raidfail.log
    echo "Other Error: $physDrive3Other" >> /tmp/raidfail.log


    mail -s "$HOSTNAME drive warning" $recipient < /tmp/raidfail.log
}


# checks

if [ $physDrive0Media -gt $drive0MediaLimit ]; then
    fail
elif [ $physDrive0Other -gt $drive0OtherLimit ]; then
    fail
elif [ $physDrive1Other -gt $drive1OtherLimit ]; then
    fail
elif [ $physDrive1Other -gt $drive1OtherLimit ]; then
    fail
elif [ $physDrive2Other -gt $drive2OtherLimit ]; then
    fail
elif [ $physDrive2Other -gt $drive2OtherLimit ]; then
    fail
elif [ $physDrive3Other -gt $drive3OtherLimit ]; then
    fail
elif [ $physDrive3Other -gt $drive3OtherLimit ]; then
    fail
elif [ $logDrvState != $logDrvStateLimit ]; then
    fail
else
    echo "$(date +"%F") all drives OK" >> $logDest
fi