#!/bin/sh
#./web_set_hiddenAP.sh <INTERFACE> <0:show ssid ; 1:hidden ssid>



CONFIG_ROOT_DIR=/var/tmp/rtl8192c









############# check config file path  ##########################

if [ -d $CONFIG_ROOT_DIR ]; then
        echo "config file path is" $CONFIG_ROOT_DIR
else
        echo $0 " ERROR : Can't find config file path. Path=" $CONFIG_ROOT_DIR
        exit 1
fi



CONFIG_DIR=$CONFIG_ROOT_DIR/$1
if [ -d  $CONFIG_DIR ]; then
	echo "config file path is" $CONFIG_DIR
else
	echo "ERROR : Can't find config file path . Path=" $CONFIG_DIR
	exit 1
fi

IWPRIV_PATH=`cat $CONFIG_ROOT_DIR/iwpriv_path`
if [ -f $IWPRIV_PATH/iwpriv ]; then
        echo "iwpriv path is" $IWPRIV_PATH/iwpriv
else
        echo $0 " ERROR : Can't find iwpriv path. Path=" $IWPRIV_PATH/iwpriv
        exit 1
fi

export IWPRIV_PATH=$IWPRIV_PATH


############# check Parameter is valid ##########################
if [ $# -lt 2 ]; then
echo "ERROR : incomplete command."
echo "Usage:" $0 " <INTERFACE> <0:show ssid ; 1:hidden ssid>"
exit 1
fi

##############################################################################


IWPRIV_PATH=`cat $CONFIG_ROOT_DIR/iwpriv_path`
if [ -f $IWPRIV_PATH/iwpriv ]; then
        echo "iwpriv path is" $IWPRIV_PATH/iwpriv
else
        echo $0 " ERROR : Can't find iwpriv path. Path=" $IWPRIV_PATH/iwpriv
        exit 1
fi

export IWPRIV_PATH=$IWPRIV_PATH




SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"







case $2 in
	0)
		;;
	1)
		;;
	*)
		echo "ERROR : Parameter Must be 0 or 1";
		exit 1;;
esac


$SET_WLAN_PARAM hiddenAP=$2
echo $2 > $CONFIG_DIR/hiddenAP



