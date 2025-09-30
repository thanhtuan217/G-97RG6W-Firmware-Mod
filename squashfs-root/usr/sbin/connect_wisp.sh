#!/bin/sh
# Script to connect to a WISP network

SSID="$1"
PASSWORD="$2"
IFACE="wlan0"

killall wpa_supplicant
killall udhcpc

wpa_passphrase "$SSID" "$PASSWORD" > /var/tmp/wpa.conf
wpa_supplicant -B -i $IFACE -c /var/tmp/wpa.conf

sleep 5

udhcpc -i $IFACE -b -q

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o $IFACE -j MASQUERADE

echo "WISP_SSID=\"$SSID\"" > /mnt/rwdir/wisp.conf
echo "WISP_PASS=\"$PASSWORD\"" >> /mnt/rwdir/wisp.conf

echo "Success"
