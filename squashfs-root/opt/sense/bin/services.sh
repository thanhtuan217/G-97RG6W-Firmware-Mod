#!/bin/sh -e

#
# F-Secure SENSE common management script
#

: ${SENSE_SDKROOT:="/tmp/fsc"}
: ${SENSE_SDKCONF:="$SENSE_SDKROOT/tmp/sense-services.conf"}
: ${SENSE_MAX_STOP_TIME:=10}
: ${SENSE_MAX_CONF:=19}
: ${SENSE_MAX_INFO_LOG:=65536}
: ${SENSE_MAX_DEBUG_LOG:=1048576}
: ${SENSE_MAX_VMRSS:=65568}
: ${SENSE_STACK_SIZE:=512}
: ${SENSE_SYSLOG:=false}

ROUTER_ID="$SENSE_SDKROOT/data/router_id"
ROUTER_INFO="$SENSE_SDKROOT/data/router_info"
TRAFFIC_JSON="$SENSE_SDKROOT/tmp/traffic.json"
DEVICELIST_JSON="$SENSE_SDKROOT/tmp/devicelist.json"
PROFILES_JSON="$SENSE_SDKROOT/tmp/profiles.json"
EVENTS_DB="$SENSE_SDKROOT/tmp/events.db"
ARTIFACTREPORT_JSON="$SENSE_SDKROOT/tmp/artifact_report.json"
HISTOGRAMREPORT_JSON="$SENSE_SDKROOT/tmp/histogram_report.json"
INSTALL_FLAG="$SENSE_SDKROOT/tmp/install.flag"
SERVICES_LOG="$SENSE_SDKROOT/tmp/services.log"
SENSE_SERVICES_CONF="$SENSE_SDKROOT/tmp/sense-services.conf"
AGENT_DIR="$SENSE_SDKROOT/data/agent"
ORSP_DIR="$SENSE_SDKROOT/tmp/orsp"
DAAS2_DIR="$SENSE_SDKROOT/tmp/daas2"

BB="$SENSE_SDKROOT/bin/busybox"

log_call()
{
    $BB echo "$($BB date -u) $0 $@"
}

install()
{
    for name in orspservice serviceapi proxyagent fstunnel; do
        if [ -n "$($BB pidof $name)" ]; then
            $BB echo "Error: $name is running, can not perform install"
            return 1
        fi
    done

    # data files
    for f in agent router_id router_info sense-latebound.conf; do
        if [ ! -e $SENSE_SDKROOT/data/$f ]; then
            $BB cp -avf $SENSE_SDKROOT/data.install/$f $SENSE_SDKROOT/data
        fi
    done

    # tmp files
    for f in daas2 orsp artifact_report.json devicelist.json events.db histogram_report.json profiles.json traffic.json; do
        if [ ! -e $SENSE_SDKROOT/tmp/$f ]; then
            if [ -e $SENSE_SDKROOT/data/$f ]; then
                $BB cp -avf $SENSE_SDKROOT/data/$f $SENSE_SDKROOT/tmp
            else
                $BB cp -avf $SENSE_SDKROOT/data.install/$f $SENSE_SDKROOT/tmp
            fi
        fi
    done

    if $BB grep -q "unknown" $ROUTER_ID; then
        $BB cat /proc/sys/kernel/random/uuid | $BB tr -d '\n' > $ROUTER_ID # Delete newline for 36 byte UUID
        $BB echo "generated router_id"
    fi

    local reset_key=$($BB grep "reset_key" $ROUTER_INFO | $BB awk -F: '{print $2}')
    if [ "$reset_key" = "unknown" ] || [ "$reset_key" = "" ]; then
        local router_uuid=$($BB cat $ROUTER_ID)
        $BB sed -i '/^reset_key/d' $ROUTER_INFO
        $BB echo "reset_key:${router_uuid}" >> $ROUTER_INFO
        $BB echo "generated reset_key"
    fi

    $BB touch $INSTALL_FLAG
}

create_config()
{
    if [ "$SENSE_SDKCONF" != "$SENSE_SERVICES_CONF" ]; then
        $BB echo "using custom configuration"
        return 0
    fi

    local overrides="\"_overrides\": null,"
    for i in $($BB seq 0 $SENSE_MAX_CONF); do
        local val=$(eval $BB echo \$SENSE_CONF$i)
        if [ -z "$val" ]; then
            continue
        fi

        # append newline
        overrides="${overrides}
        ${val},"
    done

    $BB cat << EOF > $SENSE_SDKCONF
    {
        "_common": null,
        "agentDirectory":"$AGENT_DIR",
        "artifactReportPath":"$ARTIFACTREPORT_JSON",
        "deviceDiscoveryPath":"$DEVICELIST_JSON",
        "eventStoragePath":"$EVENTS_DB",
        "histogramReportPath":"$HISTOGRAMREPORT_JSON",
        "hookDirectory":"$SENSE_SDKROOT/hooks",
        "profileListPath":"$PROFILES_JSON",
        "rootPrefix":"$SENSE_SDKROOT",
        "routerInfoPath":"$ROUTER_INFO",
        "userSettingsPath":"$TRAFFIC_JSON",
        "serviceApiPidPath":"$SENSE_SDKROOT/tmp/serviceapi.pid",
        "fstunnelPidPath":"$SENSE_SDKROOT/tmp/fstunnel.pid",
        "agentPidPath":"$SENSE_SDKROOT/tmp/proxyagent.pid",

        "_fstunnel": null,
        "fstunnelDirectory":"$SENSE_SDKROOT/etc/fstunnel",

        "_serviceapi": null,
        "doormanUrl":"https://api.doorman.fsapi.com",
        "serviceApiAddr":"127.0.0.1",
        "webRootDirectory":"$SENSE_SDKROOT/www/webui",

        $overrides

        "_last_line": null
    }
EOF

    $BB echo "created default configuration"
}

start_process()
{
    local name="$1"
    local mode="$2"

    if [ ! -f "$INSTALL_FLAG" ]; then
        $BB echo "Error: install function has not been called"
        return 1
    fi

    if [ ! -f "$SENSE_SDKROOT/bin/$name" ]; then
        $BB echo "Error: file not found '$SENSE_SDKROOT/bin/$name'"
        return 1
    fi

    if [ -n "$($BB pidof $name)" ]; then
        $BB echo "$name is already running"
        return 0
    fi

    local stack_size=$(ulimit -Ss)
    ulimit -Ss $SENSE_STACK_SIZE # soft limit can be restored afterwards

    # Note: LD_LIBRARY_PATH default value is cleared to avoid using system libraries
    if [ "$name" = "orspservice" ]; then
        if [ "$mode" = "debug" ]; then
            LD_LIBRARY_PATH="$SENSE_SDKROOT/lib" $SENSE_SDKROOT/bin/orspservice --orsp-data $ORSP_DIR --daas2-data $DAAS2_DIR --server orsp.f-secure.com --debug >>$SENSE_SDKROOT/tmp/orspservice-debug.log 2>&1 &
        else
            LD_LIBRARY_PATH="$SENSE_SDKROOT/lib" $SENSE_SDKROOT/bin/orspservice --orsp-data $ORSP_DIR --daas2-data $DAAS2_DIR --server orsp.f-secure.com >>$SENSE_SDKROOT/tmp/orspservice.log 2>&1 &
        fi
    else
        # debug is incompatible with syslog
        if [ "$mode" = "debug" ]; then
            SENSE_SDKROOT=$SENSE_SDKROOT LD_PRELOAD=libgcc_s.so.1 LD_LIBRARY_PATH="$SENSE_SDKROOT/lib" $SENSE_SDKROOT/bin/$name -c $SENSE_SDKCONF -f $SENSE_SDKROOT/tmp/$name-debug.log -d >/dev/null 2>&1 &
        elif [ "$SENSE_SYSLOG" = true ]; then
            SENSE_SDKROOT=$SENSE_SDKROOT LD_PRELOAD=libgcc_s.so.1 LD_LIBRARY_PATH="$SENSE_SDKROOT/lib" $SENSE_SDKROOT/bin/$name -c $SENSE_SDKCONF -f $SENSE_SDKROOT/tmp/$name.log -s >/dev/null 2>&1 &
        else
            SENSE_SDKROOT=$SENSE_SDKROOT LD_PRELOAD=libgcc_s.so.1 LD_LIBRARY_PATH="$SENSE_SDKROOT/lib" $SENSE_SDKROOT/bin/$name -c $SENSE_SDKCONF -f $SENSE_SDKROOT/tmp/$name.log >/dev/null 2>&1 &
        fi
    fi

    ulimit -Ss $stack_size

    for x in $($BB seq 1 $SENSE_MAX_STOP_TIME); do
        $BB sleep 1s
        if [ -n "$($BB pidof $name)" ]; then
            if [ "$mode" != "debug" ]; then
                $BB touch "$SENSE_SDKROOT/tmp/fsrespawn-$name.flag"
            else
                $BB touch "$SENSE_SDKROOT/tmp/fsrespawn-$name-debug.flag"
            fi

            # pidof is not used as it sometimes return multiple pids
            local pid="$!"
            $BB echo $pid > "$SENSE_SDKROOT/tmp/$name.pid"
            $BB echo "$name started: $pid"

            return 0
        fi
    done

    $BB echo "Error: $name failed to launch"
    return 1
}

stop_process()
{
    local name="$1"
    local mode="$2"

    if [ "$mode" != "respawn" ]; then
        $BB rm -f $SENSE_SDKROOT/tmp/fsrespawn-$name*.flag
    fi

    if [ -z "$($BB pidof $name)" ]; then
        $BB echo "$name is not running"
        return 0
    fi

    $BB killall $name || true
    for x in $($BB seq 1 $SENSE_MAX_STOP_TIME); do
        if [ -z "$($BB pidof $name)" ]; then
            $BB rm -f $SENSE_SDKROOT/tmp/$name.pid
            $BB echo "$name finished normally"
            return 0
        fi
        $BB sleep 1s
    done

    $BB killall -9 $name || true
    $BB rm -f $SENSE_SDKROOT/tmp/$name.pid
    $BB echo "$name was killed"
}

add_crash_count()
{
    local cc=$($BB cat "$SENSE_SDKROOT/tmp/crash_count")
    $BB awk "BEGIN {print $cc+1}" > $SENSE_SDKROOT/tmp/crash_count
}

respawn()
{
    for p in orspservice serviceapi proxyagent fstunnel; do
        local pid="$($BB cat $SENSE_SDKROOT/tmp/$p.pid 2> /dev/null || echo none)"
        if [ -f "/proc/$pid/status" ]; then
            local rss=$($BB cat /proc/$pid/status | $BB grep VmRSS | $BB awk '{print $2}')
            if [ "$rss" -gt "$SENSE_MAX_VMRSS" ]; then
                log_call "respawn"
                $BB echo "$p (pid $pid) exceeded memory limit: $rss"
                stop_process $p respawn
            elif [ "$p" = "serviceapi" ]; then
                local response="$(LD_LIBRARY_PATH=$SENSE_SDKROOT/lib $SENSE_SDKROOT/bin/curl -s -m 5 127.0.0.1:60277/api/version)" || true
                if [ -z "$response" ]; then
                    log_call "respawn"
                    $BB echo "serviceapi (pid $pid) doesn't respond to REST query"
                    stop_process serviceapi respawn
                fi
            fi
        elif [ ! -z "$($BB pidof $p)" ]; then
            log_call "respawn"
            $BB echo "$p.pid outdated or non-existent, but $p processes are running"
            stop_process $p respawn
        fi

        if [ -z "$($BB pidof $p)" ]; then
            if [ -f "$SENSE_SDKROOT/tmp/fsrespawn-$p.flag" ]; then
                log_call "respawn"
                $BB echo "respawn $p"
                start_process $p
                add_crash_count 2>/dev/null || true
            elif [ -f "$SENSE_SDKROOT/tmp/fsrespawn-$p-debug.flag" ]; then
                log_call "respawn"
                $BB echo "respawn $p debug"
                start_process $p debug
                add_crash_count 2>/dev/null || true
            fi
        fi
    done
}

logrotate()
{
    for p in serviceapi proxyagent fstunnel orspservice services; do
        for t in .log -debug.log; do
            local logfile="$SENSE_SDKROOT/tmp/$p$t"
            [ ! -f "$logfile" ] && continue

            local size=$($BB wc -c < $logfile)
            [ "$t" = ".log" -a "$size" -lt "$SENSE_MAX_INFO_LOG" ] && continue
            [ "$t" = "-debug.log" -a "$size" -lt "$SENSE_MAX_DEBUG_LOG" ] && continue

            log_call "logrotate"
            $BB echo "'$logfile' exceeded size limit: $size"

            # delete orspservice.log and services.log log as those don't support rotation
            if [ "$p" = "services" ]; then
                $BB rm -vf $logfile
            elif [ "$p" = "orspservice" ]; then
                $BB cat $logfile > $logfile.1
                $BB echo -n > $logfile
            else
                $BB mv -vf $logfile $logfile.1
                reload $p
            fi
        done
    done
}

reload()
{
    local name="$1"

    if [ -z "$($BB pidof $name)" ]; then
        $BB echo "$name is not running"
        return 0
    fi

    $BB killall -1 $name || true
    $BB echo "sent HUP to $name"
}

clean()
{
    for p in serviceapi proxyagent fstunnel orspservice; do
        if [ -n "$($BB pidof $p)" ]; then
            $BB echo "Error: cannot clean while '$p' is running"
            return 1
        fi
    done

    if [ -z "$1" ]; then
        local clean_all=true
    else
        local target_to_clean="$1"
    fi

    if [ "$target_to_clean" = "license" ] || [ "$clean_all" = true ]; then
        if [ -f "$ROUTER_INFO" ]; then
            $BB sed -i '/^csa_/d' $ROUTER_INFO
            $BB sed -i '/^pairing_key/d' $ROUTER_INFO
        fi
        $BB rm -vf $AGENT_DIR/*
    fi

    if [ "$target_to_clean" = "logs" ] || [ "$clean_all" = true ]; then
        $BB rm -vf $SENSE_SDKROOT/tmp/*.log* $SENSE_SDKROOT/tmp/*.pid
    fi

    if [ "$target_to_clean" = "data" ] || [ "$clean_all" = true ]; then
        $BB rm -rvf $SENSE_SDKROOT/data/* $INSTALL_FLAG $ARTIFACTREPORT_JSON $HISTOGRAMREPORT_JSON $EVENTS_DB $TRAFFIC_JSON $SENSE_SERVICES_CONF $ORSP_DIR $DAAS2_DIR
    fi
}

copy_ram_files()
{
    for f in devicelist.json events.db profiles.json traffic.json; do
        if [ -f "$SENSE_SDKROOT/tmp/$f" ]; then
            $BB timeout 5s $BB flock -x $SENSE_SDKROOT/tmp/$f -c "$BB cp -vf $SENSE_SDKROOT/tmp/$f $SENSE_SDKROOT/data/$f.x"
            $BB mv -vf $SENSE_SDKROOT/data/$f.x $SENSE_SDKROOT/data/$f
        fi
    done
}

run()
{
    case "$1" in
        install)
            log_call $1
            install
            create_config
            ;;
        start_orspservice)
            log_call $1
            start_process orspservice
            ;;
        debug_orspservice)
            log_call $1
            start_process orspservice debug
            ;;
        stop_orspservice)
            log_call $1
            stop_process orspservice
            ;;
        start_serviceapi)
            log_call $1
            start_process serviceapi
            ;;
        debug_serviceapi)
            log_call $1
            start_process serviceapi debug
            ;;
        stop_serviceapi)
            log_call $1
            stop_process serviceapi
            ;;
        reload_serviceapi)
            log_call $1
            reload serviceapi
            ;;
        start_proxyagent)
            log_call $1
            start_process proxyagent
            ;;
        debug_proxyagent)
            log_call $1
            start_process proxyagent debug
            ;;
        stop_proxyagent)
            log_call $1
            stop_process proxyagent
            ;;
        reload_proxyagent)
            log_call $1
            reload proxyagent
            ;;
        start_fstunnel)
            log_call $1
            start_process fstunnel
            ;;
        debug_fstunnel)
            log_call $1
            start_process fstunnel debug
            ;;
        stop_fstunnel)
            log_call $1
            stop_process fstunnel
            ;;
        reload_fstunnel)
            log_call $1
            reload fstunnel
            ;;
        clean)
            log_call $1
            clean
            ;;
        clean_license)
            log_call $1
            clean license
            ;;
        clean_logs)
            log_call $1
            clean logs
            ;;
        clean_data)
            log_call $1
            clean data
            ;;
        copy_ram_files)
            log_call $1
            copy_ram_files
            ;;
        respawn)
            # log_call inside
            respawn
            ;;
        logrotate)
            # log_call inside
            logrotate
            ;;
        *)
            $BB cat <<- EOS
F-Secure SENSE common management script
Usage: $0 [-f] COMMAND
  start_orspservice | debug_orspservice | stop_orspservice
  start_serviceapi | debug_serviceapi | stop_serviceapi | reload_serviceapi
  start_proxyagent | debug_proxyagent | stop_proxyagent | reload_proxyagent
  start_fstunnel | debug_fstunnel | stop_fstunnel | reload_fstunnel
  clean | clean_license | clean_logs | clean_data
  respawn | logrotate
EOS
            exit 1
            ;;
    esac
}

if [ "$1" = "-f" ]; then
    shift
    run $1 >>$SERVICES_LOG 2>&1
else
    run $1
fi
