#!/bin/sh
#./web_wapi_psk.sh <interface>  <password> <password length in hexadecimal>


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
if [ $# -lt 3 ]; then
echo "ERROR : incomplete command."
echo "Usage: $0 <interface>  <password> <password length in hexadecimal>"
exit 1
fi
###########################################################################################




SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"




################ wifi MIB initial value ###################
encmode=0
authtype=0
wapiPsk=$2
wapiPsk_len=$3
wapiType=2
wapiUCastKeyType=0
wapiMCastKeyType=0
use802_1x=0
psk_enable=0
wpa_cipher=0
wpa2_cipher=0


################ write initial value to wifi device ###################
$SET_WLAN_PARAM encmode=$encmode
$SET_WLAN_PARAM authtype=$authtype
$SET_WLAN_PARAM wapiPsk=$wapiPsk,$wapiPsk_len
$SET_WLAN_PARAM wapiType=$wapiType
$SET_WLAN_PARAM wapiUCastKeyType=$wapiUCastKeyType
$SET_WLAN_PARAM wapiMCastKeyType=$wapiUCastKeyType
$SET_WLAN_PARAM 802_1x=$use802_1x
$SET_WLAN_PARAM psk_enable=$psk_enable
$SET_WLAN_PARAM wpa_cipher=$wpa_cipher
$SET_WLAN_PARAM wpa2_cipher=$wpa2_cipher

################ Save initial value into files ###################

echo $encmode						> $CONFIG_DIR/encmode
echo $authtype					> $CONFIG_DIR/authtype;
echo $wapiPsk						> $CONFIG_DIR/wapiPsk
echo $wapiPsk_len				> $CONFIG_DIR/wapiPsk_len
echo $wapiType					> $CONFIG_DIR/wapiType
echo $wapiUCastKeyType	> $CONFIG_DIR/wapiUCastKeyType
echo $wapiMCastKeyType	> $CONFIG_DIR/wapiMCastKeyType
echo $use802_1x					> $CONFIG_DIR/802_1x
echo $psk_enable				> $CONFIG_DIR/psk_enable
echo $wpa_cipher				> $CONFIG_DIR/WPA_CIPHER
echo $wpa2_cipher				> $CONFIG_DIR/WPA2_CIPHER


exit 0
