#!/usr/bin/expect -f

set prompt "#"
set address [lindex $argv 0]

spawn sudo bluetoothctl -a
expect -re $prompt
expect -re $prompt
expect "Controller"
send "connect $address\r"
expect eof
