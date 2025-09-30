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

if [ $# -lt 3 ]; then
echo "ERROR : incomplete command."
echo "Example:" $0 "<interface name> <encrypt item> <ssid> {<MAC address>}"
exit 1
fi


#####################################################################################



CONFIG_DIR=$CONFIG_ROOT_DIR/$1
mkdir -p $CONFIG_DIR
SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"
IFCONFIG=ifconfig







################ wifi MIB initial value ###################
regdomain=3
channel=0
opmode=16
ssid=$3
band=11
hiddenAP=0
qos_enable=1
use40M=1
wifi_specific=2
ampdu=1
phyBandSelect=1
vap_enable=1
use802_1x=0
led_type=12
ledBlinkingFreq=4
shortGI20M=1
shortGI40M=1
bcnint=100
if [ $# -gt 5 ]; then
bcnint=$6
fi
rtsthres=2347
fragthres=2346
disable_protection=1
MIMO_TR_mode=2
if [ $# -gt 4 ]; then
MIMO_TR_mode=$5
fi
tssi_1=0
tssi_2=0
ther=0
trswitch=0
xcap=0
basicrates=15
supported_rate=4095
rts_threshold=2347
frag_threshold=2346
expired_time=30000
preamble_type=0
dtim_period=1
ch_hi=13
ch_low=1
iapp_enable=0
aclnum=0
aclmode=0
deny_legacy=0




################ write initial value to wifi device ###################
$SET_WLAN_PARAM regdomain=$regdomain
$SET_WLAN_PARAM channel=$channel
$SET_WLAN_PARAM opmode=$opmode
$SET_WLAN_PARAM ssid=$ssid
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
$SET_WLAN_PARAM ledBlinkingFreq=$ledBlinkingFreq
$SET_WLAN_PARAM shortGI20M=$shortGI20M
$SET_WLAN_PARAM shortGI40M=$shortGI40M
$SET_WLAN_PARAM bcnint=$bcnint
$SET_WLAN_PARAM rtsthres=$rtsthres
$SET_WLAN_PARAM fragthres=$fragthres
$SET_WLAN_PARAM disable_protection=$disable_protection
$SET_WLAN_PARAM MIMO_TR_mode=$MIMO_TR_mode
$SET_WLAN_PARAM tssi1=$tssi_1
$SET_WLAN_PARAM tssi2=$tssi_2
$SET_WLAN_PARAM ther=$ther
$SET_WLAN_PARAM trswitch=$trswitch
$SET_WLAN_PARAM xcap=$xcap
$SET_WLAN_PARAM basicrates=$basicrates
$SET_WLAN_PARAM oprates=$supported_rate
$SET_WLAN_PARAM rtsthres=$rts_threshold
$SET_WLAN_PARAM fragthres=$frag_threshold
$SET_WLAN_PARAM expired_time=$expired_time
$SET_WLAN_PARAM preamble=$preamble_type
$SET_WLAN_PARAM dtimperiod=$dtim_period
$SET_WLAN_PARAM ch_hi=$ch_hi
$SET_WLAN_PARAM ch_low=$ch_low
$SET_WLAN_PARAM iapp_enable=$iapp_enable
$SET_WLAN_PARAM aclnum=$aclnum
$SET_WLAN_PARAM aclmode=$aclmode
$SET_WLAN_PARAM deny_legacy=$deny_legacy


################ Save initial value into files ###################
echo $regdomain > $CONFIG_DIR/regdomain
echo $channel > $CONFIG_DIR/channel
echo $opmode > $CONFIG_DIR/opmode
echo $ssid > $CONFIG_DIR/ssid
echo $band > $CONFIG_DIR/band
echo $phyBandSelect > $CONFIG_DIR/phyBandSelect
echo $hiddenAP > $CONFIG_DIR/hiddenAP
echo $qos_enable > $CONFIG_DIR/qos_enable
echo $use40M > $CONFIG_DIR/use40M
echo $wifi_specific > $CONFIG_DIR/wifi_specific
echo $ampdu > $CONFIG_DIR/ampdu
echo $vap_enable > $CONFIG_DIR/vap_enable
echo $use802_1x > $CONFIG_DIR/802_1x
echo $led_type		> $CONFIG_DIR/led_type
echo $ledBlinkingFreq		> $CONFIG_DIR/ledBlinkingFreq
echo $shortGI20M	> $CONFIG_DIR/shortGI20M
echo $shortGI40M	> $CONFIG_DIR/shortGI40M
echo $bcnint			>	$CONFIG_DIR/bcnint
echo $rtsthres		> $CONFIG_DIR/rtsthres
echo $fragthres		> $CONFIG_DIR/fragthres
echo $disable_protection	> $CONFIG_DIR/disable_protection
echo $MIMO_TR_mode	> $CONFIG_DIR/MIMO_TR_mode
echo $tssi_1				> $CONFIG_DIR/tssi_1
echo $tssi_2				> $CONFIG_DIR/tssi_2
echo $ther					> $CONFIG_DIR/ther
echo $trswitch			> $CONFIG_DIR/trswitch
echo $xcap			> $CONFIG_DIR/xcap
echo $xcap					> $CONFIG_DIR/xcap
echo $basicrates		> $CONFIG_DIR/basicrates
echo $supported_rate >  $CONFIG_DIR/supported_rate
echo $rts_threshold	> $CONFIG_DIR/rts_threshold
echo $frag_threshold	>  $CONFIG_DIR/frag_threshold
echo $expired_time	>  $CONFIG_DIR/expired_time
echo $preamble_type	>  $CONFIG_DIR/preamble_type
echo $dtim_period > $CONFIG_DIR/dtim_period
echo $ch_hi > $CONFIG_DIR/ch_hi
echo $ch_low > $CONFIG_DIR/ch_low
echo $iapp_enable > $CONFIG_DIR/iapp_enable
echo $aclnum > $CONFIG_DIR/aclnum
echo $aclmode > $CONFIG_DIR/aclmode
echo $deny_legacy	> $CONFIG_DIR/deny_legacy








################ Set Tx Rate ###################
#echo "auto : auto select "
#echo "CCK  : cck_1M , cck_2M , cck_5.5M , cck_11M"
#echo "OFDM : cck_1M , cck_2M , OFDM_12M , OFDM_18M , OFDM_24M , OFDM_36M , OFDM_48M , OFDM_54M"
#echo "MCS  : mcs0~mcs15"
################################################
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




############## initialize authenication /encryption type #############
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
		#$SET_WLAN_PARAM authtype=0;
		#$SET_WLAN_PARAM encmode=0;
		#echo 0 > $CONFIG_DIR/authtype;
		#echo 0 > $CONFIG_DIR/encmode;
		web_no_encry.sh $1;;

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
		web_wpa_setting.sh $1 wpa tkip ;;
	15)
		#./web_wpa-encrypt.sh $1 wpa aes ;;
		web_wpa_setting.sh $1 wpa aes ;;
	16)
		#./web_wpa-encrypt.sh $1 wpa tkip_aes_mixes ;;
		web_wpa_setting.sh $1 wpa wpa tkip_aes_mixes ;;
	17)
		#./web_wpa-encrypt.sh $1 wpa2 tkip ;;
		web_wpa_setting.sh $1 wpa2 tkip ;;
	18)
		#./web_wpa-encrypt.sh $1 wpa2 aes;;
		web_wpa_setting.sh $1 wpa2 aes;;
	19)
		#./web_wpa-encrypt.sh $1 wpa2 tkip_aes_mixes ;;
		web_wpa_setting.sh $1 wpa2 tkip_aes_mixes ;;
	20)
		#./web_wpa-encrypt.sh $1 wpa_wpa2_mixed tkip;;
		web_wpa_setting.sh $1 wpa_wpa2_mixed tkip;;

	21)
		#./web_wpa-encrypt.sh $1 wpa_wpa2_mixed aes;;
		web_wpa_setting.sh $1 wpa_wpa2_mixed aes;;
	22)
		#./web_wpa-encrypt.sh $1 wpa_wpa2_mixed tkip_aes_mixes;;
		web_wpa_setting.sh $1 wpa_wpa2_mixed tkip_aes_mixes;;
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

