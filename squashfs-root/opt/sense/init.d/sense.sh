#!/bin/sh -ei

SENSE_HOME=/opt/sense
export SENSE_SDKROOT=$SENSE_HOME

case "$1" in
    start)
        # Request information collection here to have it ready when calling patch-router-info.sh
        echo -e "/s/tr069/set InternetGatewayDevice.X_FPT_CollectInfo.CollectInfoState Requested\n" | GponCLI >/dev/null 2>&1
        $SENSE_HOME/bin/services-sense.sh -f install
        for attempt in 1 2 3 4 5 6 7 8 9 10; do
            if [ -x /usr/sbin/iptables ]; then
                break
            fi
            sleep 3s
        done
        $SENSE_HOME/bin/services-sense.sh -f start
        (
            for attempt in 1 2 3 4 5 6 7 8 9 10; do
                if ip r | grep -q -E 'default .* ppp'; then
                    break
                fi
                sleep 3s
            done
            cd $SENSE_SDKROOT/bin
            ./patch-router-info.sh
        ) &
        ;;
    stop)
        $SENSE_HOME/bin/services-sense.sh -f stop
        ;;
    restart)
        $SENSE_HOME/bin/services-sense.sh -f stop
        $SENSE_HOME/bin/services-sense.sh -f start
        ;;
    debug)
        $SENSE_HOME/bin/services-sense.sh -f install
        $SENSE_HOME/bin/services-sense.sh -f debug
        ;;
    add_udp_rules)
        ;;
    del_udp_rules)
        ;;
esac
