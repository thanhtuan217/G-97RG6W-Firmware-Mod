#!/bin/sh



CONFIG_ROOT_DIR=/var/tmp/rtl8192c
IWPRIV_PATH=/sbin



mkdir -p $CONFIG_ROOT_DIR


############# check iwpriv exist  ##########################

if [ -f $IWPRIV_PATH/iwpriv ]; then
        echo "iwpriv path is" $IWPRIV_PATH/iwpriv
else
        echo $0 " ERROR : Can't find iwpriv path. Path=" $IWPRIV_PATH/iwpriv
        exit 1
fi

echo $IWPRIV_PATH > $CONFIG_ROOT_DIR/iwpriv_path
export IWPRIV_PATH=$IWPRIV_PATH




############# check Parameter number is vaild ##########################

if [ $# -lt 4 ]; then
echo "ERROR : incomplete command."
echo "Example:" $0 "<interface name> <encrypt item> <ssid> <MAC address>"
exit 1
fi


#####################################################################################



CONFIG_DIR=$CONFIG_ROOT_DIR/$1
mkdir -p $CONFIG_DIR
SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"
IFCONFIG=ifconfig








regdomain=1
channel=0
opmode=16
ssid=$3
bcnint=100
if [ $# -gt 5 ]; then
bcnint=$6
fi
band=12
hiddenAP=0
qos_enable=1
use40M=1
wifi_specific=2
ampdu=1
phyBandSelect=2
vap_enable=1
use802_1x=0
led_type=0
shortGI20M=1
shortGI40M=1

$SET_WLAN_PARAM regdomain=$regdomain
$SET_WLAN_PARAM channel=$channel
$SET_WLAN_PARAM opmode=$opmode
$SET_WLAN_PARAM ssid=$ssid
$SET_WLAN_PARAM bcnint=$bcnint
$SET_WLAN_PARAM band=$band
$SET_WLAN_PARAM phyBandSelect=$phyBandSelect
$SET_WLAN_PARAM hiddenAP=$hiddenAP
$SET_WLAN_PARAM qos_enable=$qos_enable
$SET_WLAN_PARAM use40M=$use40M
$SET_WLAN_PARAM wifi_specific=$wifi_specific
$SET_WLAN_PARAM ampdu=$ampdu
$SET_WLAN_PARAM vap_enable=$vap_enable
$SET_WLAN_PARAM 802_1x=$use802_1x
$SET_WLAN_PARAM led_type=$led_type
$SET_WLAN_PARAM shortGI20M=$shortGI20M
$SET_WLAN_PARAM shortGI40M=$shortGI40M

echo $regdomain > $CONFIG_DIR/regdomain
echo $channel > $CONFIG_DIR/channel
echo $opmode > $CONFIG_DIR/opmode
echo $ssid > $CONFIG_DIR/ssid
echo $bcnint > $CONFIG_DIR/bcnint
echo $band > $CONFIG_DIR/band
echo $phyBandSelect > $CONFIG_DIR/phyBandSelect
echo $hiddenAP > $CONFIG_DIR/hiddenAP
echo $qos_enable > $CONFIG_DIR/qos_enable
echo $use40M > $CONFIG_DIR/use40M
echo $wifi_specific > $CONFIG_DIR/wifi_specific
echo $ampdu > $CONFIG_DIR/ampdu
echo $vap_enable > $CONFIG_DIR/vap_enable
echo $use802_1x > $CONFIG_DIR/802_1x
echo $led_type > $CONFIG_DIR/led_type
echo $shortGI20M > $CONFIG_DIR/shortGI20M
echo $shortGI40M > $CONFIG_DIR/shortGI40M

web_tx_rate.sh $1 auto
#./set_tx_rate.sh $1 cck_1M
#./set_tx_rate.sh $1 cck_11M
#./set_tx_rate.sh $1 OFDM_18M
#./set_tx_rate.sh $1 OFDM_54M
#./set_tx_rate.sh $1 mcs1
#./set_tx_rate.sh $1 mcs4
if [ $? -eq 1 ]; then
	echo "execute set_tx_rate.sh failue"
	exit 1
fi




hex_64_key1="1111111111"
hex_64_key2="2222222222"
hex_64_key3="3333333333"
hex_64_key4="4444444444"


hex_128_key1="11223344556677889900aabbcc"
hex_128_key2="22223344556677889900aabbcc"
hex_128_key3="33223344556677889900aabbcc"
hex_128_key4="44223344556677889900aabbcc"


ascii_64_key1="3032333435"
ascii_64_key2="3132333435"
ascii_64_key3="3232333435"
ascii_64_key4="333233343"5

ascii_128_key1="30313233343536373839616263"
ascii_128_key2="31313233343536373839616263"
ascii_128_key3="32313233343536373839616263"
ascii_128_key4="33313233343536373839616263"

case $2 in
	1)
		$SET_WLAN_PARAM authtype=0;
		$SET_WLAN_PARAM encmode=0;
		echo 0 > $CONFIG_DIR/authtype;
		echo 0 > $CONFIG_DIR/encmode;;

	2)
		#./web_wep_encrypt.sh  $1 open  wep_hex_64  $hex_64_key1 $hex_64_key2 $hex_64_key3 $hex_64_key4;;
		web_wep_setting.sh $1 open wep_64 1;
		web_wep_key.sh $1 64_hex 1 hex_64_key1;
		web_wep_key.sh $1 64_hex 2 hex_64_key2;
		web_wep_key.sh $1 64_hex 3 hex_64_key3;
		web_wep_key.sh $1 64_hex 4 hex_64_key4;;

	3)
		#./web_wep_encrypt.sh $1 open  wep_hex_128  $hex_128_key1 $hex_128_key2 $hex_128_key3 $hex_128_key4 ;;
		web_wep_setting.sh $1 open wep_128 1;
		web_wep_key.sh $1 128_hex 1 hex_128_key1;
		web_wep_key.sh $1 128_hex 2 hex_128_key2;
		web_wep_key.sh $1 128_hex 3 hex_128_key3;
		web_wep_key.sh $1 128_hex 4 hex_128_key4;;


	4)
		#./web_wep_encrypt.sh $1 open  wep_ascii_64  $ascii_64_key1 $ascii_64_key2 $ascii_64_key3 $ascii_64_key4 ;;
		web_wep_setting.sh $1 open wep_64 1;
		web_wep_key.sh $1 64_asc 1 ascii_64_key1;
		web_wep_key.sh $1 64_asc 2 ascii_64_key2;
		web_wep_key.sh $1 64_asc 3 ascii_64_key3;
		web_wep_key.sh $1 64_asc 4 ascii_64_key4;;

	5)
		#./web_wep_encrypt.sh $1 open  wep_ascii_128 $ascii_128_key1 $ascii_128_key2 $ascii_128_key3 $ascii_128_key4 ;;
		web_wep_setting.sh $1 open wep_128 1;
		web_wep_key.sh $1 128_asc 1 ascii_128_key1;
		web_wep_key.sh $1 128_asc 2 ascii_128_key2;
		web_wep_key.sh $1 128_asc 3 ascii_128_key3;
		web_wep_key.sh $1 128_asc 4 ascii_128_key4;;
	6)
		#./web_wep_encrypt.sh $1 share wep_hex_64    $hex_64_key1 $hex_64_key2 $hex_64_key3 $hex_64_key4;;
		web_wep_setting.sh $1 share wep_64 1;
		web_wep_key.sh $1 64_hex 1 hex_64_key1;
		web_wep_key.sh $1 64_hex 2 hex_64_key2;
		web_wep_key.sh $1 64_hex 3 hex_64_key3;
		web_wep_key.sh $1 64_hex 4 hex_64_key4;;





	7)
		#./web_wep_encrypt.sh $1 share wep_hex_128  $hex_128_key1 $hex_128_key2 $hex_128_key3 $hex_128_key4 ;;
		web_wep_setting.sh $1 share wep_128 1;
		web_wep_key.sh $1 128_hex 1 hex_128_key1;
		web_wep_key.sh $1 128_hex 2 hex_128_key2;
		web_wep_key.sh $1 128_hex 3 hex_128_key3;
		web_wep_key.sh $1 128_hex 4 hex_128_key4;;



	8)
		#./web_wep_encrypt.sh $1 share wep_ascii_64  $ascii_64_key1 $ascii_64_key2 $ascii_64_key3 $ascii_64_key4 ;;
		web_wep_setting.sh $1 share wep_64 1;
		web_wep_key.sh $1 64_asc 1 ascii_64_key1;
		web_wep_key.sh $1 64_asc 2 ascii_64_key2;
		web_wep_key.sh $1 64_asc 3 ascii_64_key3;
		web_wep_key.sh $1 64_asc 4 ascii_64_key4;;

	9)
		#./web_wep_encrypt.sh $1 share wep_ascii_128 $ascii_128_key1 $ascii_128_key2 $ascii_128_key3 $ascii_128_key4 ;;
		web_wep_setting.sh $1 share wep_128 1;
		web_wep_key.sh $1 128_asc 1 ascii_128_key1;
		web_wep_key.sh $1 128_asc 2 ascii_128_key2;
		web_wep_key.sh $1 128_asc 3 ascii_128_key3;
		web_wep_key.sh $1 128_asc 4 ascii_128_key4;;


	10)
		#./web_wep_encrypt.sh $1 auto  wep_hex_64    $hex_64_key1 $hex_64_key2 $hex_64_key3 $hex_64_key4;;
		web_wep_setting.sh $1 auto wep_64 1;
		web_wep_key.sh $1 64_hex 1 hex_64_key1;
		web_wep_key.sh $1 64_hex 2 hex_64_key2;
		web_wep_key.sh $1 64_hex 3 hex_64_key3;
		web_wep_key.sh $1 64_hex 4 hex_64_key4;;


	11)
		#./web_wep_encrypt.sh $1 auto  wep_hex_128  $hex_128_key1 $hex_128_key2 $hex_128_key3 $hex_128_key4 ;;
		web_wep_setting.sh $1 auto wep_128 1;
		web_wep_key.sh $1 128_hex 1 hex_128_key1;
		web_wep_key.sh $1 128_hex 2 hex_128_key2;
		web_wep_key.sh $1 128_hex 3 hex_128_key3;
		web_wep_key.sh $1 128_hex 4 hex_128_key4;;



	12)
		#./web_wep_encrypt.sh $1 auto  wep_ascii_64  $ascii_64_key1 $ascii_64_key2 $ascii_64_key3 $ascii_64_key4 ;;
		web_wep_setting.sh $1 auto wep_64 1;
		web_wep_key.sh $1 64_asc 1 ascii_64_key1;
		web_wep_key.sh $1 64_asc 2 ascii_64_key2;
		web_wep_key.sh $1 64_asc 3 ascii_64_key3;
		web_wep_key.sh $1 64_asc 4 ascii_64_key4;;



	13)
		#./web_wep_encrypt.sh $1 auto  wep_ascii_128 $ascii_128_key1 $ascii_128_key2 $ascii_128_key3 $ascii_128_key4 ;;
		web_wep_setting.sh $1 auto wep_128 1;
		web_wep_key.sh $1 128_asc 1 ascii_128_key1;
		web_wep_key.sh $1 128_asc 2 ascii_128_key2;
		web_wep_key.sh $1 128_asc 3 ascii_128_key3;
		web_wep_key.sh $1 128_asc 4 ascii_128_key4;;

	14)
		#./web_wpa-encrypt.sh $1 wpa tkip ;;
		web_wpa-setting.sh $1 wpa tkip ;;
	15)
		#./web_wpa-encrypt.sh $1 wpa aes ;;
		web_wpa-setting.sh $1 wpa aes ;;
	16)
		#./web_wpa-encrypt.sh $1 wpa tkip_aes_mixes ;;
		web_wpa-setting.sh $1 wpa wpa tkip_aes_mixes ;;
	17)
		#./web_wpa-encrypt.sh $1 wpa2 tkip ;;
		web_wpa-setting.sh $1 wpa2 tkip ;;
	18)
		#./web_wpa-encrypt.sh $1 wpa2 aes;;
		web_wpa-setting.sh $1 wpa2 aes;;
	19)
		#./web_wpa-encrypt.sh $1 wpa2 tkip_aes_mixes ;;
		web_wpa-setting.sh $1 wpa2 tkip_aes_mixes ;;
	20)
		#./web_wpa-encrypt.sh $1 wpa_wpa2_mixed tkip;;
		web_wpa-setting.sh $1 wpa_wpa2_mixed tkip;;

	21)
		#./web_wpa-encrypt.sh $1 wpa_wpa2_mixed aes;;
		web_wpa-setting.sh $1 wpa_wpa2_mixed aes;;
	22)
		#./web_wpa-encrypt.sh $1 wpa_wpa2_mixed tkip_aes_mixes;;
		web_wpa-setting.sh $1 wpa_wpa2_mixed tkip_aes_mixes;;
	*)
		echo "ERROR PARAMETER";
		exit 1;;
esac

if [ $? -eq 1 ]; then
	echo "execute encrypt.sh failue"
	exit 1
fi

if [ $# -gt 3 ]; then
	ifconfig $1 hw ether $4
fi

#$IFCONFIG $1 up

