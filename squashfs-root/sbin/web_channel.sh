#!/bin/sh
#./web_channel.sh  <interface> <channel>


CONFIG_ROOT_DIR=/var/tmp/rtl8192c


##################### check interface name , This is invalid in VAP interface ################
if_name=$1
len=`echo ${#if_name}`
if [ $len -lt 6 ]; then
	echo ""
else
	echo "Error : Interface name error"
	exit 1
fi


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


############# check Parameter number is valid ##########################
if [ $# -lt 2 ]; then
echo "ERROR : incomplete command."
echo "Example:" $0 "<interface name>"
exit 1
fi


###########################################################################################





SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"
IFCONFIG=ifconfig

$SET_WLAN_PARAM channel=$2
echo $2 > $CONFIG_DIR/channel




