#!/bin/bash
test="pactl list short | grep bluez_sink"
dbus1="dbus-send --print-reply --system --dest=org.bluez /org/bluez/hci"
dbus2=" org.bluez.Device1.ConnectProfile string:0000110b-0000-1000-8000-00805f9b34f"
controllers=(00:1B:DC:0F:D2:E1 B8:27:EB:00:B4:BF)
speakers=(84:D6:D0:21:85:21 00:FC:8B:D5:99:F3)

for i in ${!speakers[@]}; do
speaker=${speakers[i]}
#echo $speaker
command="$test.${speaker//:/_}" 
command2=$dbus1$i/"dev"_${speaker//:/_}$dbus2
#echo $command2
result=`eval $command`
#echo $result
if [[ -z $result ]]; then
  echo "Connecting to $speaker with ${controllers[i]}"
  #commented out do to rpi tendency to treat echos as sources and sinks
  #/home/homeassistant/.homeassistant/scripts/bluetooth.sh ${speakers[i]} ${controllers[i]}
  #pactl set-card-profile `pactl list short | grep bluez_card | awk '{print $1}'` a2dp_sink
  $command2
else
  echo "Already connected to $speaker with ${controllers[i]}"

fi 
done
