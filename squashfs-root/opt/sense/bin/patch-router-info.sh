#!/bin/sh -e

: ${SENSE_SDKROOT:="/opt/sense"}
BB="${SENSE_SDKROOT}/bin/busybox"
CURL="${SENSE_SDKROOT}/bin/curl"

if ! [ -x "$BB" -a -x "$CURL" ]; then
    echo "[ERROR] Couldn't find busybox and/or curl executables in ${SENSE_SDKROOT}/bin"
    exit 1
fi

WAN_IFACE="ppp0"
MANUFACTURER="CIG"
MODEL="G-97RG6W"

for attempt in 1 2 3 4 5; do
    FIRMWARE=$(cat /tmp/cpe3/cfg.param |grep "InternetGatewayDevice.X_FPT_CollectInfo.DevInfo.1.SWVersion" |awk -F\; '{print $NF}')
    [ ! -z "$FIRMWARE" ] && break
    sleep 1s
done

for attempt in 1 2 3 4 5; do
    SERIAL=$(cat /tmp/cpe3/cfg.param |grep "InternetGatewayDevice.X_FPT_CollectInfo.DevInfo.1.SN" |awk -F\; '{print $NF}')
    [ ! -z "$SERIAL" ] && break
    sleep 1s
done

for attempt in 1 2 3 4 5; do
    WAN_MACADDR=$(cat /tmp/cpe3/cfg.param |grep "InternetGatewayDevice.X_FPT_CollectInfo.DevInfo.1.ONTMAC" |awk -F\; '{print $NF}' | sed 's/:/-/g')
    [ ! -z "$WAN_MACADDR" ] && break
    sleep 1s
done

while [ $# -gt 1 ]; do
    case $1 in
        -w)
            WAN_IFACE="$2"
            shift
            ;;
        -m)
            MANUFACTURER="$2"
            shift
            ;;
        -o)
            MODEL="$2"
            shift
            ;;
        -f)
            FIRMWARE="$2"
            shift
            ;;
        -s)
            SERIAL="$2"
            shift
            ;;
        -x)
            WAN_MACADDR="$2"
            shift
            ;;
    esac
    shift
done

if [ -z "$WAN_MACADDR" ]; then
    $BB echo "[ERROR] Couldn't find WAN MAC address"
    exit 1
fi

DATA=$($BB cat << EOF
    {
        "manufacturer": "$MANUFACTURER",
        "model": "$MODEL",
        "serial": "$SERIAL",
        "mac": "$WAN_MACADDR",
        "firmware": "$FIRMWARE"
    }
EOF
)

LD_LIBRARY_PATH="${SENSE_SDKROOT}/lib" $CURL -i -X PATCH 127.0.0.1:60277/api/1/router-info -d "$DATA"