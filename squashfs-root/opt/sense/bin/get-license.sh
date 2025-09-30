#!/bin/sh -e

: ${SENSE_SDKROOT:="/tmp/fsc"}
BB="${SENSE_SDKROOT}/bin/busybox"
CURL="${SENSE_SDKROOT}/bin/curl"

if ! [ -x "$BB" -a -x "$CURL" ]; then
    echo "[ERROR] Couldn't find busybox and/or curl executables in ${SENSE_SDKROOT}/bin"
    exit 1
fi

$BB echo "Activation status:"
$BB echo
LD_LIBRARY_PATH="${SENSE_SDKROOT}/lib" $CURL -i 127.0.0.1:60277/api/1/activation-status

$BB echo "License status:"
$BB echo
LD_LIBRARY_PATH="${SENSE_SDKROOT}/lib" $CURL -i 127.0.0.1:60277/api/1/license-status

$BB echo
