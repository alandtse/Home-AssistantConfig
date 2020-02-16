#!/bin/sh
Log=/var/log/dnsmasqscript.log

op="${1:-op}"
mac="${2:-mac}"
ip="${3:-ip}"
hostname="${4}"

uptime=`ps -o etimes= -p $PPID`
# Don't report on deleted leases, or when dnsmasq restarts
if [ $op = "del" ] || [ $uptime -lt 30 ]
then
	exit 0
fi
mac=$(echo "$mac" | tr '[:lower:]' '[:upper:]')
#date >> $Log
#echo $op >> $Log
#echo $mac >> $Log
#echo $ip >> $Log
#echo $hostname >> $Log

# Convert $hostname (or $mac, or $ip) into the device_tracker.dev_id.
# $mac is lowercase while known_devices.yaml is uppercase. Convert.
case "$mac" in
	40:4E:36:93:9C:93)
		dev_id="alandtse_pixel2"
		;;
	8C:45:00:6B:D3:0E)
		dev_id="raywtse_note4"
		;;
	E0:33:8E:88:D3:AC)
		dev_id="e0338e88d3ac" #Solomon
		;;
	E0:33:8E:C1:9A:BE)
		dev_id="e0338ec19abe" # Orla
		;;
	*)
		# other devices we're not tracking 
		exit 0
		;;
esac

curl -H "Content-Type: application/json" -X POST \
	-d '{"dev_id": "'$dev_id'", "location_name":"home"}' \
	-H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiI0Njg4MThiOGRlMjM0MTlhODZlYTM4ZTU3MjFkOTQ1MCIsImlhdCI6MTU1MDczNzY1MywiZXhwIjoxODY2MDk3NjUzfQ.jKdc1pSH6EB5ZPTfj87N0w0GqNkrP8bpe7FpJcWm56k' \
	https://alandtse.duckdns.org/api/services/device_tracker/see
