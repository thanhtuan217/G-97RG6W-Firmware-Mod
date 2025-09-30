#!/bin/sh
# Script to scan for Wi-Fi networks

IFACE="wlan0"
ifconfig $IFACE up
iwlist $IFACE scan | grep -E 'ESSID:|Quality=' | sed 'N;s/\n/ /' | \
awk -F 'ESSID:"' '{print $2}' | awk -F '"' '{print $1"|"$2}' | \
sed 's/ Quality=//' | sed 's/ Signal level=//'
