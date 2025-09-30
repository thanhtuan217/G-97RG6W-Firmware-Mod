#!/bin/sh
# ./web_wep_setting.sh <INTERFACE> < auth_type > < type >  < default key > 
# < auth_type > : open , share , auto
#< type > : wep_64 , wep_128
#< default key number > 


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
if [ $# -lt 4 ]; then
echo "ERROR : incomplete command."
echo "Usage:" $0 " <INTERFACE> < auth_type > < type >  < default key > "
exit 1
fi

###########################################################################################

SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"

case $2 in
	open)
		auth_type=0;
		echo "authentication open";;
	share)
		auth_type=1;
		echo "authenticationshare";;
	auto)
		auth_type=2;
		echo "authentication auto";;
	*)
		echo "ERROR : error <authentication methot> parameter"
		echo "the vaild parameter should are \"open\" or \"share\" or \"auto\"(both) "
		exit 1
esac


case $3 in
	wep_64)
		encmode=1;
		echo "wep_64";;
		
	wep_128)
		encmode=5;
		echo "wep_128";;
	*)
		echo "ERROR : error <Encrypt mode> parameter"
		echo "the vaild parameter should are \"wep_64\" or \"wep_128\""
		exit 1
esac


case $4 in
	1)
		wepdkeyid=0;;
	2)
		wepdkeyid=1;;
	3)
		wepdkeyid=2;;
	4)
		wepdkeyid=3;; 
	*)
		echo "the vaild key number should be 1~4 "
		exit 1
esac	

$SET_WLAN_PARAM 802_1x=0
echo 0 > $CONFIG_DIR/802_1x

$SET_WLAN_PARAM encmode=$encmode
echo $encmode > $CONFIG_DIR/encmode


$SET_WLAN_PARAM authtype=$auth_type
echo $auth_type > $CONFIG_DIR/authtype

$SET_WLAN_PARAM wepdkeyid=$wepdkeyid
echo $wepdkeyid > $CONFIG_DIR/wepdkeyid

wpacipher=0
wpa2cipher=0

$SET_WLAN_PARAM wpa_cipher=$wpacipher
echo $wpacipher > $CONFIG_DIR/WPA_CIPHER

$SET_WLAN_PARAM wpa2_cipher=$wpa2cipher
echo $wpa2cipher > $CONFIG_DIR/WPA2_CIPHER

exit 0
