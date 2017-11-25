#!/bin/bash
test=`pactl list short | grep bluez_sink`
if [[ -z $test ]]; then
  /home/homeassistant/.homeassistant/scripts/bluetooth.sh 84:D6:D0:21:85:21
  sleep 4
  pactl set-card-profile `pactl list short | grep bluez_card | awk '{print $1}'` a2dp_sink
fi 
