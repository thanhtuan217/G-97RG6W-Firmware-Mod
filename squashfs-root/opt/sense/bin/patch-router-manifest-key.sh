#!/bin/sh -e

: ${SENSE_SDKROOT:="/opt/sense"}
BB="${SENSE_SDKROOT}/bin/busybox"
CURL="${SENSE_SDKROOT}/bin/curl"

if ! [ -x "$BB" -a -x "$CURL" ]; then
    echo "[ERROR] Couldn't find busybox and/or curl executables in ${SENSE_SDKROOT}/bin"
    exit 1
fi

if [ -z "$1" ]; then
    $BB echo "Usage: $0 LICENSE_KEY [RESET_KEY]"
    exit 0
fi

if [ -n "$2" ]; then
    # Reset key can be used to attach an identifier to licensing registration.
    # Thus, it needs to be patched before router-manifest-key.
    LD_LIBRARY_PATH="${SENSE_SDKROOT}/lib" $CURL -i -X PATCH http://127.0.0.1:60277/api/1/router-ref -d $2
fi

LD_LIBRARY_PATH="${SENSE_SDKROOT}/lib" $CURL -i -X PATCH http://127.0.0.1:60277/api/1/router-manifest-key -d $1