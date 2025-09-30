#!/bin/sh -e

case "$1" in
    start)
        mkdir -p /mnt/midware/sense
        mkdir -p /tmp/senseSDK
        mount --bind /mnt/midware/sense /opt/sense/data
        mount --bind /tmp/senseSDK /opt/sense/tmp
        mkdir -p /opt/sense/tmp/orsp
        ;;
    stop)
        umount /opt/sense/tmp
        umount /opt/sense/data
        ;;
esac
