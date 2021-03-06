#!/bin/bash
# Exit and restart bitcoind after some time period
# Willtech ©2022

# How often to restart in seconds
timeout=43200

# BAT / CMD goto function
# Source: https://www.codegrepper.com/code-examples/shell/bash+jump+to
function goto
{
    label=$1
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 | 
          grep -v ':$')
    eval "$cmd"
    exit
}
# Just for the heck of it: how to create a variable where to jump to:
start=${1:-"start"}
goto "$start"

: start

#Start bitcoind
bitcoind -daemon

#Run until timout
sleep $timeout

#Stop bitcoind
bitcoin-cli stop

#Tries for ten minutes to see if exit is detected.
until timeout 1200s tail -f /media/drive2/.bitcoin/debug.log | grep -m 1 "Shutdown: done"
  do
    sleep 2
  done

#Log again
echo again

#Loop to : start
goto "start"

echo bar
