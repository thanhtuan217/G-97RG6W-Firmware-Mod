#!/bin/sh
#./web_wapi_psk.sh <interface>  <AS server IP>


CONFIG_ROOT_DIR=/var/tmp/rtl8192c
ap_cert_path=/var/myca/ap.cert
as_cert_path=/var/myca/ca4ap.cert
aeUdpClient_path=/sbin/aeUdpClient

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
echo "Usage: $0 <interface>  <ipaddr>"
exit 1
fi
###########################################################################################




SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"



if [ -f $ap_cert_path ]; then
        echo "find out AP certification path is" $ap_cert_path
else
        echo $0 " ERROR : Can't find AP certification path. Path=" $ap_cert_path
        exit 1
fi

if [ -f $as_cert_path ]; then
        echo "find out AP certification path is" $as_cert_path
else
        echo $0 " ERROR : Can't find AP certification path. Path=" $as_cert_path
        exit 1
fi


if [ -f $aeUdpClient_path ]; then
        echo "find out AP certification path is" $aeUdpClient_path
else
        echo $0 " ERROR : Can't find AP certification path. Path=" $aeUdpClient_path
        exit 1
fi





################ wifi MIB initial value ###################
encmode=0
authtype=0
wapiType=2
wapiUCastKeyType=0
wapiMCastKeyType=0
use802_1x=0
psk_enable=0
wpa_cipher=0
wpa2_cipher=0


################ write initial value to wifi device ###################
#cp /var/config/ap.cert /var/myca/
#cp /var/config/ca4ap.cert /var/myca/
$SET_WLAN_PARAM encmode=0
$SET_WLAN_PARAM authtype=0
$SET_WLAN_PARAM wapiType=1
$SET_WLAN_PARAM wapiUCastKeyType=0
$SET_WLAN_PARAM wapiMCastKeyType=0
$SET_WLAN_PARAM 802_1x=0
$SET_WLAN_PARAM psk_enable=0
$SET_WLAN_PARAM wpa_cipher=0
$SET_WLAN_PARAM wpa2_cipher=0

################ Save initial value into files ###################

echo $encmode						> $CONFIG_DIR/encmode
echo $authtype					> $CONFIG_DIR/authtype;
echo $wapiType					> $CONFIG_DIR/wapiType
echo $wapiUCastKeyType	> $CONFIG_DIR/wapiUCastKeyType
echo $wapiMCastKeyType	> $CONFIG_DIR/wapiMCastKeyType
echo $use802_1x					> $CONFIG_DIR/802_1x
echo $psk_enable				> $CONFIG_DIR/psk_enable
echo $wpa_cipher				> $CONFIG_DIR/WPA_CIPHER
echo $wpa2_cipher				> $CONFIG_DIR/WPA2_CIPHER

killall -9 aeUdpClient
$aeUdpClient_path -d $2 -i $1 &

exit 0
