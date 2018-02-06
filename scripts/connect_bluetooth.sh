#!/bin/bash
test="pactl list short | grep bluez_sink"
controllers=(00:1B:DC:0F:D2:E1 B8:27:EB:00:B4:BF)
speakers=(84:D6:D0:21:85:21 00:FC:8B:D5:99:F3)

for i in ${!speakers[@]}; do
speaker=${speakers[i]}
#echo $speaker
command="$test.${speaker//:/_}" 
#echo $command
result=`eval $command`
#echo $result
if [[ -z $result ]]; then
  echo "Connecting to $speaker with ${controllers[i]}"
  /home/homeassistant/.homeassistant/scripts/bluetooth.sh ${speakers[i]} ${controllers[i]}
  #pactl set-card-profile `pactl list short | grep bluez_card | awk '{print $1}'` a2dp_sink
else
  echo "Already connected to $speaker with ${controllers[i]}"

fi 
done
