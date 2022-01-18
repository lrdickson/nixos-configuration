#! /usr/bin/env bash

email_message="/tmp/raidstatus.txt"

echo "from:dicksonserver@gmail.com" > $email_message
echo "to:lyndseyrd@gmail.com" >> $email_message
echo "subject:cloudsdale raid status" >> $email_message
btrfs device stats /data >> $email_message

sendmail lyndseyrd@gmail.com < $email_message
