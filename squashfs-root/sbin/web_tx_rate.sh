#!/bin/sh


CONFIG_ROOT_DIR=/var/tmp/rtl8192c


##################### check interface name , This is invalid in VAP interface ################
if_name=$1
len=`echo ${#if_name}`
if [ $len -lt 12 ]; then
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
        exit 1#
fi

CONFIG_DIR=$CONFIG_ROOT_DIR/$1

if [ -d $CONFIG_DIR ]; then
        echo "config file path is" $CONFIG_DIR
else
        echo $0 " ERROR : Can't find config file path. Path=" $CONFIG_DIR
        exit 1
fi


IWPRIV_PATH=`cat $CONFIG_ROOT_DIR/iwpriv_path`
if [ -f $IWPRIV_PATH/iwpriv ]; then
        echo "iwpriv path is" $IWPRIV_PATH/iwpriv
else
        echo $0 " ERROR : Can't find iwpriv path. Path=" $IWPRIV_PATH/iwpriv
        exit 1
fi



############# check Parameter is valid ##########################
if [ $# -lt 2 ]; then
echo "ERROR : incomplete command."
echo "Example:" $0 "<interface name>" "<data rate>"
echo "<data rate> : "
echo "AUTO : auto"
echo "CCK  : cck_1M , cck_2M , cck_5.5M , cck_11M"
echo "OFDM : cck_1M , cck_2M , OFDM_12M , OFDM_18M , OFDM_24M , OFDM_36M , OFDM_48M , OFDM_54M"
echo "MCS  : mcs0~mcs15"
exit 1
fi











#########################################################################################################

SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"
IFCONFIG=ifconfig

case $2 in
	auto)
		#datarare_16=00000000;
		datarare=00000000;
		echo "auto";;
		
	cck_1M)
		#datarare_16=00000001;
		datarare=1;
		echo "cck_1M";;
		
	cck_2M)
		#datarare_16=00000002;
		datarare=2;
		echo "cck_2M";;
		
	cck_5.5M)
		#datarare_16=00000004;
		datarare=4;regdomain 
		echo "cck_5.5M";;
		
	cck_11M)
		#datarare_16=00000008;
		datarare=8;
		echo "cck_11M";;
		
	OFDM_6M)
		#datarare_16=00000010;
		datarare=16;
		echo "OFDM_6M";;
	OFDM_9M)
		#datarare_16=00000020;
		datarare=32;
		echo "OFDM_9M";;
	OFDM_12M)
		#datarare_16=00000040;
		datarare=64;
		echo "OFDM_12M";;
	OFDM_18M)
		#atarare_16=00000080;
		datarare=128;
		echo "OFDM_18M";;
	OFDM_24M)
		#datarare_16=00000100;
		datarare=256;
		echo "OFDM_24M";;
	OFDM_36M)
		#datarare_16=00000200;
		datarare=512;
		echo "OFDM_36M";;
	OFDM_48M)
		#datarare_16=00000400;
		datarare=1024;
		echo "OFDM_48M";;
	OFDM_54M)
		#datarare_16=00000800;
		datarare=2048;
		echo "OFDM_54M";;
	mcs0)
		#datarare_16=00001000;
		datarare=4096;
		echo "mcs0";;
	mcs1)
		#datarare_16=00002000;
		datarare=8192;
		echo "mcs1";;
	mcs2)
		#datarare_16=00004000;
		datarare=16384;
		echo "mcs2";;
	mcs3)
		#datarare_16=00008000;
		datarare=32768;
		echo "mcs3";;
	mcs4)
		#datarare_16=00010000;
		datarare=65536;
		echo "mcs4";;
	mcs5)
		#datarare_16=00020000;
		datarare=131072;
		echo "mcs5";;
	mcs6)
		#datarare_16=00040000;
		datarare=262144;
		echo "mcs6";;
	mcs7)
		#datarare_16=00080000;
		datarare=524288;
		echo "mcs7";;
	mcs8)
		#datarare_16=00100000;
		datarare=1048576;
		echo "mcs8";;
	mcs9)
		#datarare_16=00200000;
		datarare=2097152;
		echo "mcs9";;
	mcs10)
		#datarare_16=00400000;
		datarare=4194304;
		echo "mcs10";;
	mcs11)
		#datarare_16=00800000;
		datarare=8388608;
		echo "mcs10";;
	mcs12)
		#datarare_16=01000000;
		datarare=16777216;
		echo "mcs12";;
	mcs13)
		#datarare_16=02000000;
		datarare=33554432;
		echo "mcs13";;
	mcs14)
		#datarare_16=04000000;
		datarare=67108864;
		echo "mcs14";;
	mcs15)
		#datarare_16=08000000;
		datarare=134217728;
		echo "mcs15";;
	all)
		#datarare_16=0fffffff;
		datarare=268435455;
		echo "all";;
	*)
		echo "ERROR : error parameter";
		exit 1
esac

#datarare=$((16#$datarare_16))

if [ $datarare -eq 0 ]; then
	$SET_WLAN_PARAM autorate=1
	#$SET_WLAN_PARAM fixrate=0

	echo 1 > $CONFIG_DIR/autorate
	echo 0 > $CONFIG_DIR/fixrate

	echo "autorate"
else
	$SET_WLAN_PARAM autorate=0
	$SET_WLAN_PARAM fixrate=$datarare

	echo 0 > $CONFIG_DIR/autorate
	echo $datarare > $CONFIG_DIR/fixrate

	echo "fixrate=" $datarare
fi
exit 0



