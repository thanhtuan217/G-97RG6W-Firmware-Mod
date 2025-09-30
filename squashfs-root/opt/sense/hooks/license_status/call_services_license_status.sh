#!/bin/sh

# Note: this script runs with empty LD_LIBRARY_PATH variable

while [ $# -gt 1 ]; do
    case $1 in
        --value)
            VALUE="$2"
            shift
            ;;
    esac
    shift
done

case $VALUE in
    valid)
        /tmp/FscReport 1
        ;;
    invalid)
        /tmp/FscReport 0
        ;;
esac

exit 0
