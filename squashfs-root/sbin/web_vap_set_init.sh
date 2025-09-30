#!/bin/sh
#./web_vap_setting.sh <INTERFACE> <ssid> <MAC address>



CONFIG_ROOT_DIR=/var/tmp/rtl8192c




main_if=`echo $1 | cut -b -5`
vap_if=`echo $1 | cut -b 7-`
CONFIG_DIR=$CONFIG_ROOT_DIR/$main_if
VIRTUAL_DEV_DIR=$CONFIG_ROOT_DIR/$1
############# check config file path  ##########################

if [ -d $CONFIG_ROOT_DIR ]; then
        echo "config file path is" $CONFIG_ROOT_DIR
else
        echo $0 " ERROR : Can't find config file path. Path=" $CONFIG_ROOT_DIR
        exit 1
fi


CONFIG_DIR=$CONFIG_ROOT_DIR/$main_if
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

############# check Parameter number is vaild ##########################
if [ $# -lt 3 ]; then
echo "ERROR : incomplete command."
echo "Example:" $0 "<INTERFACE> <ssid> <MAC address>"
exit 1
fi
###########################################################################################

mkdir -p $VIRTUAL_DEV_DIR


SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"
IFCONFIG=ifconfig




hiddenAP=0




GET_VALUE=`cat $CONFIG_DIR/regdomain`
$SET_WLAN_PARAM regdomain=$GET_VALUE

GET_VALUE=`cat $CONFIG_DIR/channel`
$SET_WLAN_PARAM channel=$GET_VALUE

GET_VALUE=`cat $CONFIG_DIR/opmode`
$SET_WLAN_PARAM opmode=$GET_VALUE

GET_VALUE=`cat $CONFIG_DIR/band`
$SET_WLAN_PARAM band=$GET_VALUE

GET_VALUE=`cat $CONFIG_DIR/phyBandSelect`
$SET_WLAN_PARAM phyBandSelect=$GET_VALUE

GET_VALUE=`cat $CONFIG_DIR/hiddenAP`
$SET_WLAN_PARAM hiddenAP=$GET_VALUE


GET_VALUE=`cat $CONFIG_DIR/qos_enable`
$SET_WLAN_PARAM qos_enable=$GET_VALUE

GET_VALUE=`cat $CONFIG_DIR/use40M`
$SET_WLAN_PARAM use40M=$GET_VALUE

GET_VALUE=`cat $CONFIG_DIR/wifi_specific`
$SET_WLAN_PARAM wifi_specific=$GET_VALUE

GET_VALUE=`cat $CONFIG_DIR/ampdu`
$SET_WLAN_PARAM ampdu=$GET_VALUE

GET_VALUE=`cat $CONFIG_DIR/vap_enable`
$SET_WLAN_PARAM vap_enable=$GET_VALUE



$SET_WLAN_PARAM ssid=$2
echo $2 > $VIRTUAL_DEV_DIR/ssid

$SET_WLAN_PARAM hiddenAP=$hiddenAP
echo $hiddenAP > $VIRTUAL_DEV_DIR/hiddenAP



$SET_WLAN_PARAM authtype=0
$SET_WLAN_PARAM encmode=0
echo 0 > $VIRTUAL_DEV_DIR/authtype
echo 0 > $VIRTUAL_DEV_DIR/encmode

ifconfig $1 hw ether $3

$IFCONFIG $1 up



