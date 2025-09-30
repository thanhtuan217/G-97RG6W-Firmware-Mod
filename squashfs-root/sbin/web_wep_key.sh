#!/bin/sh
# ./web_wep_key.sh wlan0 < key type > <key_num> <key>
#< key type > :
#	64_hex , 128_hex , 64_asc , 128_asc


CONFIG_ROOT_DIR=/var/tmp/rtl8192c








main_if=`echo $1 | cut -b -5`
CONFIG_DIR=/var/rtl8192c/$main_if





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
echo "Usage:" $0 "<interface name> <encryption methot> <key_num> <key>"
echo "<encryption methot> : "
echo "	\"64_hex\" or \"128_hex\" or \"64_asc\" \"128_asc\" "
echo "<key_num> : "
echo "	which key(1~4)"
echo "<key> : "
exit 1
fi
###########################################################################################



SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"

len=`echo ${#4}`

case $2 in
	64_hex | 64_asc)
		if [ $len -ne 10  ]; then
			echo "Password length error.It Should be 10 character"
			exit 1
		fi
		;;
	128_hex | 128_asc )
		if [ $len -ne 26  ]; then
			echo "Password length error.It Should be 26 character"
			exit 1
		fi
		;;
	*)
		echo "ERROR : error <key type>"
		echo "the vaild parameter should are \"64_hex\" or \"128_hex\" or \"64_asc\" or \"128_asc\" "
		exit 1
esac


case $3 in
	1)
		;;
	2)
		;;
	3)
		;;
	4)
		;; 
	*)
		echo "the vaild key number should are 1~4 "
		exit 1
esac	

key_name=`echo "wepkey"$3`

$SET_WLAN_PARAM $key_name=$4
echo $4 > $CONFIG_DIR/$key_name
exit 0
