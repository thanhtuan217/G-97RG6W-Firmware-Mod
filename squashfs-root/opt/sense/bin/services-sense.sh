#!/bin/sh -e

#
# F-Secure SENSE platform management script (CIG AV1000C v2)
#

: ${SENSE_SDKROOT:="/tmp/fsc"}
: ${SENSE_LAN_INTERFACE:="br0"}
: ${SENSE_MAX_STOP_TIME:=10}
: ${SENSE_WATCHDOG_INTERVAL:=10s}
: ${SENSE_RESPAWN_INTERVAL:=1}
: ${SENSE_LOGROTATE_INTERVAL:=6}
: ${SENSE_IPTABLES_INTERVAL:=6}
: ${SENSE_FILES_INTERVAL:=360}

BB="$SENSE_SDKROOT/bin/busybox"
SERVICES_SH="$SENSE_SDKROOT/bin/services.sh"
SERVICES_LOG="$SENSE_SDKROOT/tmp/services.log"
WATCHDOG_PID="$SENSE_SDKROOT/tmp/watchdog.pid"

IPV4_FILTER_QUEUE=0
IPV4_FLOW_QUEUE=1
IPV4_FINGERPRINT_QUEUE=2
IPV6_FILTER_QUEUE=3
IPV6_FLOW_QUEUE=4
BYPASS_MARK=1
REPEAT_MARK=2
IPV4_IPTABLES_COMMAND="_iptables"
IPV6_IPTABLES_COMMAND="_ip6tables"
MARK_MATCH="mark"
MARK_TARGET="MARK"
CONNMARK_MATCH="connmark"
CONNMARK_TARGET="CONNMARK"
NFQUEUE_TARGET="NFQUEUE --queue-bypass"

# table:chain:count
# SENSE_FILTER_INPUT is adjusted by -1 for IPv6
RESPAWN_COUNTERS=$($BB cat <<- EOS
raw:SENSE_RAW_OUTPUT:2
mangle:SENSE_MANGLE_FORWARD:5
filter:SENSE_FILTER_INPUT:2
filter:SENSE_FILTER_OUTPUT:3
filter:SENSE_FILTER_FORWARD:7
EOS
)

export SENSE_CONF0="\"lanInterface\":\"$SENSE_LAN_INTERFACE\""
export SENSE_CONF1="\"nfqBypassMark\":\"$BYPASS_MARK\""
export SENSE_CONF2="\"nfqRepeatMark\":\"$REPEAT_MARK\""

if [ -n "$IPV4_IPTABLES_COMMAND" ]; then
    export SENSE_CONF3="\"nfqQueueList\":\"$IPV4_FILTER_QUEUE,$IPV4_FLOW_QUEUE,$IPV4_FINGERPRINT_QUEUE\""
else
    export SENSE_CONF3="\"nfqQueueList\":\"\""
fi

if [ -n "$IPV6_IPTABLES_COMMAND" ]; then
    export SENSE_CONF4="\"nfqQueueList6\":\"$IPV6_FILTER_QUEUE,$IPV6_FLOW_QUEUE\""
else
    export SENSE_CONF4="\"nfqQueueList6\":\"\""
fi

export SENSE_CONF5="\"dhcpLeasesPath\":\"/var/tmp/dnsmasq.lease\""

log_call()
{
    $BB echo "$($BB date -u) $0 $@"
}

_iptables()
{
    repeat_until_success iptables $@
}

_ip6tables()
{
    repeat_until_success ip6tables $@
}

repeat_until_success()
{
    for attempt in 1 2 3 4 5; do
        if $@; then
            break
        elif [ "$attempt" = "5" ]; then
            echo "Error: \"$@\" failed $attempt times in a row. Exiting."
            return 0
        else
            echo "Warning: \"$@\" failed. Retry in 1 sec ..."
            sleep 1
        fi
    done
}

run_iptables_chains()
{
    local op=$1

    for ip_tables in $IPV4_IPTABLES_COMMAND $IPV6_IPTABLES_COMMAND; do
        $ip_tables -t raw $op SENSE_RAW_OUTPUT
        $ip_tables -t mangle $op SENSE_MANGLE_FORWARD
        $ip_tables -t mangle $op SENSE_MANGLE_DEVBLOCK
        $ip_tables -t filter $op SENSE_FILTER_INPUT
        $ip_tables -t filter $op SENSE_FILTER_OUTPUT
        $ip_tables -t filter $op SENSE_FILTER_FORWARD
        $ip_tables -t filter $op SENSE_FILTER_DEVBLOCK
    done
}

run_iptables_devblock()
{
    local op=$1
    local mac=$2

    for ip_tables in $IPV4_IPTABLES_COMMAND $IPV6_IPTABLES_COMMAND; do
        $ip_tables -t mangle $op SENSE_MANGLE_DEVBLOCK -m mac --mac-source $mac -p tcp --dport 80 -j $CONNMARK_TARGET --set-xmark 0/$BYPASS_MARK
        $ip_tables -t filter $op SENSE_FILTER_DEVBLOCK -m mac --mac-source $mac -p tcp -m multiport --dports 53,80 -j RETURN
        $ip_tables -t filter $op SENSE_FILTER_DEVBLOCK -m mac --mac-source $mac -p udp --dport 53 -j RETURN
        $ip_tables -t filter $op SENSE_FILTER_DEVBLOCK -m mac --mac-source $mac -j REJECT
    done
}

add_iptables_rules()
{
    # SKIPLOG example
    # iptables -t mangle -A SENSE_MANGLE_FORWARD -p tcp -m multiport --dports/--sports 53,80,443 -i/-o $SENSE_LAN_INTERFACE -m $CONNMARK_MATCH --mark 0/$BYPASS_MARK -j SKIPLOG

    # Keep in mind RESPAWN_COUNTERS when changing iptables rules

    logger -t "$0" "Adding SENSE SDK iptables rules"
    run_iptables_chains "-F" 2>/dev/null || true

    for ip_tables in $IPV4_IPTABLES_COMMAND $IPV6_IPTABLES_COMMAND; do
        local filter_queue=$IPV4_FILTER_QUEUE
        local flow_queue=$IPV4_FLOW_QUEUE
        if [ "$ip_tables" = "$IPV6_IPTABLES_COMMAND" ]; then
            filter_queue=$IPV6_FILTER_QUEUE
            flow_queue=$IPV6_FLOW_QUEUE
        fi

        # device blocking (only outgoing packets due to mac-source match in devblock chains)
        $ip_tables -t mangle -A SENSE_MANGLE_FORWARD -i $SENSE_LAN_INTERFACE -j SENSE_MANGLE_DEVBLOCK
        $ip_tables -t filter -A SENSE_FILTER_FORWARD -i $SENSE_LAN_INTERFACE -j SENSE_FILTER_DEVBLOCK

        # prevent raw packets sent by fstunnel from getting stuck
        $ip_tables -t raw -A SENSE_RAW_OUTPUT -p tcp -m multiport --sports 53,80,443 -o $SENSE_LAN_INTERFACE -j CT --notrack
        $ip_tables -t raw -A SENSE_RAW_OUTPUT -p udp --sport 53 -o $SENSE_LAN_INTERFACE -j CT --notrack

        # restore bypass bit from connmark (--set-mark is more compatible then --set-xmark)
        $ip_tables -t mangle -A SENSE_MANGLE_FORWARD -p tcp -m multiport --dports 53,80,443 -i $SENSE_LAN_INTERFACE -m $CONNMARK_MATCH --mark $BYPASS_MARK/$BYPASS_MARK -j $MARK_TARGET --set-mark $BYPASS_MARK/$BYPASS_MARK
        $ip_tables -t mangle -A SENSE_MANGLE_FORWARD -p tcp -m multiport --sports 53,80,443 -o $SENSE_LAN_INTERFACE -m $CONNMARK_MATCH --mark $BYPASS_MARK/$BYPASS_MARK -j $MARK_TARGET --set-mark $BYPASS_MARK/$BYPASS_MARK
        $ip_tables -t mangle -A SENSE_MANGLE_FORWARD -p tcp -m multiport --dports 53,80,443 -i $SENSE_LAN_INTERFACE -m $CONNMARK_MATCH ! --mark $BYPASS_MARK/$BYPASS_MARK -j $MARK_TARGET --set-mark 0x20000/0x20000
        $ip_tables -t mangle -A SENSE_MANGLE_FORWARD -p tcp -m multiport --sports 53,80,443 -o $SENSE_LAN_INTERFACE -m $CONNMARK_MATCH ! --mark $BYPASS_MARK/$BYPASS_MARK -j $MARK_TARGET --set-mark 0x20000/0x20000

        # filtering
        local mark_set=$(($BYPASS_MARK | $REPEAT_MARK))
        $ip_tables -t filter -A SENSE_FILTER_FORWARD -p tcp -m multiport --dports 53,80,443 -i $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark 0/$mark_set -j $NFQUEUE_TARGET --queue-num $filter_queue
        $ip_tables -t filter -A SENSE_FILTER_FORWARD -p tcp -m multiport --sports 53,80,443 -o $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark 0/$mark_set -j $NFQUEUE_TARGET --queue-num $filter_queue

        $ip_tables -t filter -A SENSE_FILTER_INPUT -p tcp --dport 53 -i $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark 0/$REPEAT_MARK -j $NFQUEUE_TARGET --queue-num $filter_queue
        $ip_tables -t filter -A SENSE_FILTER_OUTPUT -p tcp --sport 53 -o $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark 0/$REPEAT_MARK -j $NFQUEUE_TARGET --queue-num $filter_queue
        $ip_tables -t filter -A SENSE_FILTER_OUTPUT -p tcp -m multiport --dports 53,80,443 -j ACCEPT
        $ip_tables -t filter -A SENSE_FILTER_OUTPUT -p tcp -m multiport --sports 53,80,443 -j ACCEPT

        $ip_tables -t filter -A SENSE_FILTER_FORWARD -p udp --dport 53 -i $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark 0/$REPEAT_MARK -j $NFQUEUE_TARGET --queue-num $filter_queue
        $ip_tables -t filter -A SENSE_FILTER_INPUT -p udp --dport 53 -i $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark 0/$REPEAT_MARK -j $NFQUEUE_TARGET --queue-num $filter_queue

        # flow counting
        $ip_tables -t filter -A SENSE_FILTER_FORWARD -p tcp --syn -i $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark 0/$REPEAT_MARK -j $NFQUEUE_TARGET --queue-num $flow_queue

        # fingerprinting (IPv4 only)
        if [ "$ip_tables" = "$IPV4_IPTABLES_COMMAND" ]; then
            $ip_tables -t filter -A SENSE_FILTER_INPUT -p udp -m multiport --dports 67,1900,5353 -i $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark 0/$REPEAT_MARK -j $NFQUEUE_TARGET --queue-num $IPV4_FINGERPRINT_QUEUE
        fi

        # set bypass bit to connmark
        $ip_tables -t filter -A SENSE_FILTER_FORWARD -p tcp -m multiport --dports 53,80,443 -i $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark $BYPASS_MARK/$BYPASS_MARK -j $CONNMARK_TARGET --set-xmark $BYPASS_MARK/$BYPASS_MARK
        $ip_tables -t filter -A SENSE_FILTER_FORWARD -p tcp -m multiport --sports 53,80,443 -o $SENSE_LAN_INTERFACE -m $MARK_MATCH --mark $BYPASS_MARK/$BYPASS_MARK -j $CONNMARK_TARGET --set-xmark $BYPASS_MARK/$BYPASS_MARK
    done

    if [ -n "$($BB pidof serviceapi)" ]; then
        $BB killall -SIGALRM serviceapi || true
    fi

    $BB touch $SENSE_SDKROOT/tmp/fsrespawn-iptables.flag
}

del_iptables_rules()
{
    $BB rm -f $SENSE_SDKROOT/tmp/fsrespawn-iptables.flag

    logger -t "$0" "Deleting all SENSE SDK iptables rules"
    run_iptables_chains "-F" || true
}

respawn_iptables_rules()
{
    if [ ! -f "$SENSE_SDKROOT/tmp/fsrespawn-iptables.flag" ]; then
        return 0
    fi

    for ip_tables in $IPV4_IPTABLES_COMMAND $IPV6_IPTABLES_COMMAND; do
        for tuple in $RESPAWN_COUNTERS; do
            local table=$($BB echo $tuple | $BB cut -d ':' -f 1)
            local chain=$($BB echo $tuple | $BB cut -d ':' -f 2)
            local count=$($BB echo $tuple | $BB cut -d ':' -f 3)

            local chain_is_custom="$($BB echo $chain | $BB grep "SENSE")"
            if [ -n "$chain_is_custom" ]; then
                # count all rules in 'SENSE' custom chain and subtract header lines
                local result=$($ip_tables -t $table -L $chain | $BB wc -l) || true
                result=$(($result - 2))
            else
                # count 'SENSE' rules in core chain
                local result=$($ip_tables -t $table -L $chain | $BB grep SENSE | $BB wc -l) || true
            fi

            if [ $result -lt $count ]; then
                log_call respawn_iptables_rules
                $BB echo "Missing rule: $ip_tables $table $chain"
                add_iptables_rules
                return 0
            fi
        done
    done

    return 0
}

flush_iptables()
{
    for ip_tables in $IPV4_IPTABLES_COMMAND $IPV6_IPTABLES_COMMAND; do
        for x in INPUT FORWARD OUTPUT; do
            $ip_tables -P $x ACCEPT
        done

        for x in raw mangle nat filter; do
            $ip_tables -t $x -F
            $ip_tables -t $x -X
        done
    done

    if [ -n "$IPV4_IPTABLES_COMMAND" ]; then
        local lan_ipv4_addr=$($BB ifconfig $SENSE_LAN_INTERFACE | $BB grep "inet addr" | $BB cut -d ':' -f 2 | $BB cut -d ' ' -f 1 ) || true
        local lan_ipv4_prefix=$($BB ifconfig $SENSE_LAN_INTERFACE | $BB grep "inet addr" | $BB cut -d ':' -f 4 | $BB cut -d ' ' -f 1 ) || true

        if [ -z "$lan_ipv4_addr" -o -z "$lan_ipv4_prefix" ]; then
            $BB echo "Error: failed to get LAN subnet from interface '$SENSE_LAN_INTERFACE'"
            return 0
        fi

        $IPV4_IPTABLES_COMMAND -t nat -A POSTROUTING -s $lan_ipv4_addr/$lan_ipv4_prefix -j MASQUERADE

        $BB echo 1 > /proc/sys/net/ipv4/ip_forward
    fi
}

block_device()
{
    local mac=$($BB echo $1 | $BB sed 's/-/:/g')
    if [ -z "$mac" ]; then
        $BB echo "Error: empty mac address"
        return 1
    fi

    run_iptables_devblock "-D" $mac 2>/dev/null || true

    run_iptables_devblock "-A" $mac
    local ip4=$(arp -a | grep $mac | awk '{ print $2 }' | sed 's/[()]//g')
    if [ -n "$ip4" ]; then
        conntrack -D -s "$ip4" 2>/dev/null || true
    fi
    for ip6 in $(ip -6 neigh show | grep $mac | awk '{ print $1 }'); do
        conntrack -D -s "$ip6" 2>/dev/null || true
    done
}

unblock_device()
{
    local mac=$($BB echo $1 | $BB sed 's/-/:/g')
    if [ -z "$mac" ]; then
        $BB echo "Error: empty mac address"
        return 1
    fi

    run_iptables_devblock "-D" $mac || true
}

flush_devblock()
{
    for ip_tables in $IPV4_IPTABLES_COMMAND $IPV6_IPTABLES_COMMAND; do
        $ip_tables -t mangle -F SENSE_MANGLE_DEVBLOCK
        $ip_tables -t filter -F SENSE_FILTER_DEVBLOCK
    done
}

start_watchdog()
{
    if [ ! -f "$SERVICES_SH" ]; then
        $BB echo "Error: file not found '$SERVICES_SH'"
        return 1
    fi

    if [ -f "$WATCHDOG_PID" ]; then
        $BB echo "watchdog is already running"
        return 0
    fi

    local max_interval=$($BB printf "$SENSE_RESPAWN_INTERVAL\n$SENSE_LOGROTATE_INTERVAL\n$SENSE_IPTABLES_INTERVAL\n$SENSE_FILES_INTERVAL" | $BB sort -n | $BB tail -n1)
    if [ $max_interval -eq 0 ]; then
        $BB echo "watchdog is disabled"
        return 0
    fi

    local counter=0
    while true; do
        # note: respawn comes last because logrotate can stop orspservice
        if [ -f "$SENSE_SDKROOT/tmp/disable_sync" ]; then
            if [ $SENSE_FILES_INTERVAL != 0 ] && [ $((counter % $SENSE_FILES_INTERVAL)) = 0 ]; then
                $SERVICES_SH -f copy_ram_files || true
            fi
        fi

        if [ $SENSE_LOGROTATE_INTERVAL != 0 ] && [ $((counter % $SENSE_LOGROTATE_INTERVAL)) = 0 ]; then
            $SERVICES_SH -f logrotate || true
        fi

        if [ $SENSE_IPTABLES_INTERVAL != 0 ] && [ $((counter % $SENSE_IPTABLES_INTERVAL)) = 0 ]; then
            respawn_iptables_rules >>$SERVICES_LOG 2>&1 || true
        fi

        if [ $SENSE_RESPAWN_INTERVAL != 0 ] && [ $((counter % $SENSE_RESPAWN_INTERVAL)) = 0 ]; then
            $SERVICES_SH -f respawn || true
        fi

        counter=$((counter+1))
        if [ $counter = $max_interval ]; then
            counter=0
        fi

        $BB sleep $SENSE_WATCHDOG_INTERVAL
    done >/dev/null 2>&1 &

    local pid=$!
    $BB echo $pid > $WATCHDOG_PID
    $BB echo "watchdog started: $pid"
}

stop_watchdog()
{
    if [ ! -f "$WATCHDOG_PID" ]; then
        $BB echo "watchdog is not running"
        return 0
    fi

    local pid=$($BB cat $WATCHDOG_PID)
    $BB rm -f $WATCHDOG_PID

    if [ -f "$SENSE_SDKROOT/tmp/disable_sync" ]; then
        $SERVICES_SH -f copy_ram_files || true
    fi

    $BB kill $pid
    for x in $($BB seq 1 $SENSE_MAX_STOP_TIME); do
        if ! $BB kill -s 0 $pid 2>/dev/null; then
            $BB echo "watchdog finished normally"
            return 0
        fi;
        $BB sleep 1s;
    done;

    $BB kill -9 $pid
    $BB echo "watchdog was killed"
}

run()
{
    case "$1" in
        add_iptables_rules)
            log_call $1
            add_iptables_rules
            ;;
        del_iptables_rules)
            log_call $1
            del_iptables_rules
            ;;
        respawn_iptables_rules)
            #log_call inside function
            respawn_iptables_rules
            ;;
        flush_iptables)
            log_call $1
            flush_iptables
            ;;
        block_device)
            log_call $1 $2
            block_device $2
            ;;
        unblock_device)
            log_call $1 $2
            unblock_device $2
            ;;
        flush_devblock)
            log_call $1
            flush_devblock
            ;;
        install)
            log_call $1
            $SERVICES_SH install
            ;;
        start|debug)
            log_call $1
            add_iptables_rules
            for x in orspservice serviceapi proxyagent fstunnel; do
                $SERVICES_SH $1_$x
            done
            start_watchdog
            ;;
        stop)
            log_call $1
            stop_watchdog
            del_iptables_rules
            for x in orspservice serviceapi proxyagent fstunnel; do
                $SERVICES_SH stop_$x
            done
            ;;
        start_watchdog)
            log_call $1
            start_watchdog
            ;;
        stop_watchdog)
            log_call $1
            stop_watchdog
            ;;
        *)
            $BB cat <<- EOS
F-Secure SENSE platform management script (CIG AV1000C v2)
Usage: $0 [-f] COMMAND
  add_iptables_rules | del_iptables_rules | respawn_iptables_rules | flush_iptables
  block_device MAC | unblock_device MAC | flush_devblock
  install | start | debug | stop
  start_watchdog | stop_watchdog
EOS
            exit 1
            ;;
    esac
}

if [ "$1" = "-f" ]; then
    shift
    run $1 $2 $3 >>$SERVICES_LOG 2>&1
else
    run $1 $2 $3
fi
