#!/bin/sh
#./web_no_encry.sh <INTERFACE>
#

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
if [ $# -lt 1 ]; then
echo "ERROR : incomplete command."
echo "Usage:" $0 " <INTERFACE> <key_num> "
exit 1
fi
###########################################################################################




SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"

$SET_WLAN_PARAM authtype=0
echo 0 > $CONFIG_DIR/authtype

$SET_WLAN_PARAM encmode=0
echo 0 > $CONFIG_DIR/encmode

$SET_WLAN_PARAM 802_1x=0
echo 0 > $CONFIG_DIR/802_1x

wpacipher=0
wpa2cipher=0

$SET_WLAN_PARAM wpa_cipher=$wpacipher
echo $wpacipher > $CONFIG_DIR/WPA_CIPHER

$SET_WLAN_PARAM wpa2_cipher=$wpa2cipher
echo $wpa2cipher > $CONFIG_DIR/WPA2_CIPHER

exit 0
