#!/usr/bin/env bash

# finds volume over x percent

overPerc=10

df |grep [0-9]% |while read line; do
 used=$(echo $line |awk '{print $5}' |tr -d '%')
 mountpoint=$(echo $line |awk '{print $6}')
 [ $used -gt $overPerc ] && echo "$mountpoint is over 10% utilized."
 done
