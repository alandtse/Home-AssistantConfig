#!/usr/bin/expect -f

set prompt "#"
set address [lindex $argv 0]
set controller [lindex $argv 1]

spawn bluetoothctl -a
expect -re $prompt
send "select $controller\r"
sleep 2
send "trust $address\r"
sleep 2
send "connect $address\r"
sleep 2
send_user "\nShould be paired now.\r"
send "quit\r"
expect eof
