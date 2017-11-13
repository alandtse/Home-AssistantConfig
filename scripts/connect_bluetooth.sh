#!/bin/bash

bluetoothctl << EOF
trust 84:D6:D0:21:85:21 
connect 84:D6:D0:21:85:21 
EOF
sleep 10
pactl set-card-profile `pactl list short | grep bluez_card | awk '{print $1}'` a2dp
