#!/bin/sh

CONFIG_ROOT_DIR=/var/tmp/rtl8192c



############# Get interface name & VAP name ##########################
main_if=`echo $1 | cut -b -5`
if_name=$1
len=`echo ${#if_name}`
if [ $len -lt 6 ]; then
	vap_if=""
	is_root=1
else
	vap_if=`echo $1 | cut -b 6-`
	is_root=0
fi



############# check config file path  ##########################

if [ -d $CONFIG_ROOT_DIR ]; then
        echo "config file path is" $CONFIG_ROOT_DIR
else
        echo $0 " ERROR : Can't find config file path. Path=" $CONFIG_ROOT_DIR
        exit 1
fi



if [ $is_root = 1 ]; then
	echo "root_devie"
	CONFIG_DIR=$CONFIG_ROOT_DIR/$1
	VIRTUAL_DEVICE_DIR=$CONFIG_ROOT_DIR/$1

else
	echo "virtual_devie"
	CONFIG_DIR=$CONFIG_ROOT_DIR/$main_if
	VIRTUAL_DEVICE_DIR=$CONFIG_ROOT_DIR/$1

fi


if [ -d  $CONFIG_DIR ]; then
		echo "config CONFIG_DIR path is" $CONFIG_DIR
else
		echo "ERROR : Can't CONFIG_DIR path . Path=" $CONFIG_DIR
		exit 1
fi

if [ -d  $VIRTUAL_DEVICE_DIR ]; then
		echo "config file VIRTUAL_DEVICE_DIR is" $VIRTUAL_DEVICE_DIR
else
		echo "ERROR : Can't find VIRTUAL_DEVICE_DIR path . Path=" $VIRTUAL_DEVICE_DIR
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
echo "Example:" $0 "<interface name>"
exit 1
fi

SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"


#CONFIG_FILE=`echo regdomain channel opmode ssid band phyBandSelect hiddenAP qos_enable use40M wifi_specific ampdu vap_enable 802_1x`
CONFIG_FILE="regdomain channel opmode band phyBandSelect qos_enable use40M wifi_specific ampdu vap_enable 802_1x autorate fixrate led_type shortGI20M shortGI40M bcnint rtsthres fragthres disable_protection MIMO_TR_mode tssi_1 tssi_2 ther trswitch xcap basicrates supported_rate rts_threshold frag_threshold expired_time preamble_type dtim_period ch_hi ch_low iapp_enable aclnum aclmode deny_legacy"

CONFIG_VAP_FILE="ssid hiddenAP authtype encmode wepdkeyid wepkey1 wepkey2 wepkey3 wepkey4 deny_legacy psk_enable WPA_CIPHER WPA2_CIPHER passphrase"



for FILE in $CONFIG_FILE ; do
	if [ -f $CONFIG_DIR/$FILE ]; then
		GET_VALUE=`cat $CONFIG_DIR/$FILE`
		$SET_WLAN_PARAM $FILE=$GET_VALUE
	else
		echo "ERROR can't config file " $CONFIG_DIR/$FILE
		exit 1
	fi
done





for FILE in $CONFIG_VAP_FILE ; do

	if [ -f $VIRTUAL_DEVICE_DIR/$FILE ]; then
		GET_VALUE=`cat $VIRTUAL_DEVICE_DIR/$FILE`
		$SET_WLAN_PARAM $FILE=$GET_VALUE
	else
		echo "ERROR can't config file " $VIRTUAL_DEVICE_DIR/$FILE
#		exit 1
	fi

done

exit 0


