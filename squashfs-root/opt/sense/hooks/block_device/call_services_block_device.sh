#!/bin/sh

# Note: this script runs with empty LD_LIBRARY_PATH variable

while [ $# -gt 1 ]; do
    case $1 in
        --mac)
            MAC="$2"
            shift
            ;;
        --action)
            ACTION="$2"
            shift
            ;;
    esac
    shift
done

if [ -z "$SENSE_SDKROOT" ]; then
    exit 0
fi

case $ACTION in
    block)
        $SENSE_SDKROOT/bin/services-sense.sh -f block_device $MAC
        ;;
    unblock)
        $SENSE_SDKROOT/bin/services-sense.sh -f unblock_device $MAC
        ;;
    reset)
        $SENSE_SDKROOT/bin/services-sense.sh -f flush_devblock
        ;;
esac

exit 0
