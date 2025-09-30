#!/bin/sh
#./web_wpa-setting.sh <interface> <wpa/wpa2/wpa_wpa2_mixed> <tkip/aes/tkip_aes_mixes> 


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
echo "Usage:" $0 "<interface name> <authentication methot> <Encrypt mode>"
echo "<authentication methot> : "
echo "	\"wpa\" or \"wpa2\" or \"wpa_wpa2_mixed\""
echo "<Encrypt mode> : "
echo "	\"tkip\" or \"aes\" or \"tkip_aes_mixed\""
exit 1
fi
###########################################################################################




SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"
IFCONFIG=ifconfig




case $2 in
	wpa)
		psk_en=1;
		echo "wpa authentication";;
	wpa2)
		psk_en=2;
		echo "wpa2 authenticationshare";;
	wpa_wpa2_mixed)
		psk_en=3;
		echo "wpa_wpa2_mixed authenticationshare";;
	*)
		echo "ERROR : error <authentication methot> parameter"
		echo "the vaild parameter should are \"wpa\" or \"wpa2\" \"wpa_wpa2_mixed\""
		exit 1
esac




case $3 in
	tkip)
		encmode=2;
		wpacipher=2;
		wpa2cipher=2;;
	aes)
		encmode=4;
		wpacipher=8;
		wpa2cipher=8;;
	tkip_aes_mixed)
		encmode=2;
		wpacipher=10;
		wpa2cipher=10;;
	*)
		echo "ERROR : error <Encrypt mode> parameter"
		echo "the vaild parameter should are \"tkip\" or \"aes\" or \"tkip_aes_mixed\""
		exit 1
esac

$SET_WLAN_PARAM encmode=$encmode
echo $encmode > $CONFIG_DIR/encmode


$SET_WLAN_PARAM 802_1x=0
echo 0 > $CONFIG_DIR/802_1x

#$SET_WLAN_PARAM deny_legacy=0
#echo 0 > $CONFIG_DIR/deny_legacy


$SET_WLAN_PARAM psk_enable=$psk_en
echo $psk_en > $CONFIG_DIR/psk_enable


$SET_WLAN_PARAM wpa_cipher=$wpacipher
echo $wpacipher > $CONFIG_DIR/WPA_CIPHER


$SET_WLAN_PARAM wpa2_cipher=$wpa2cipher
echo $wpa2cipher > $CONFIG_DIR/WPA2_CIPHER


$SET_WLAN_PARAM passphrase=12345678
echo 12345678 > $CONFIG_DIR/passphrase

# For WPS setting
echo 12345678 > $CONFIG_DIR/wpa_psk


exit 0
