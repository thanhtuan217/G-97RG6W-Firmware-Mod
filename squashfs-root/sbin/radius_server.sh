#!/bin/sh
#./radius.sh <interface> <auth_type> <encrypt_type> <radius_serveer_ip>
#<auth_type> : 
#		wpa , wpa2 , wpa_wpa2_mixed
#
#<encrypt_type> : 
#	tkip , aes ,  tkip_aes_mixed
#


AUTH_PATH=/sbin/auth
FLASH_PATH=/sbin/flash_rtk
IWCONTROL_PATH=/sbin/iwcontrol
CONFIG_ROOT_DIR=/var/tmp/rtl8192c

interface_name=$2
rs_ip=$3
RS_interafce=$4
rs_password=$5
VAP_DEV_DIR=$CONFIG_ROOT_DIR/$interface_name

IWPRIV_PATH=`cat $CONFIG_ROOT_DIR/iwpriv_path`
SET_WLAN="$IWPRIV_PATH/iwpriv $interface_name"
SET_WLAN_PARAM="$SET_WLAN set_mib"

FOFO_NAME=/var/tmp/auth-$interface_name.fifo




generate_config_parameter() {
#wlan_mode :  AP=0, CLIENT=1
echo "0" > $VAP_DEV_DIR/wlan_mode
echo "$rs_ip" > $VAP_DEV_DIR/rs_ip
echo "1812" > $VAP_DEV_DIR/rs_port
echo "$rs_password" > $VAP_DEV_DIR/rs_password
echo "3" > $VAP_DEV_DIR/rs_maxretry
echo "5" > $VAP_DEV_DIR/rs_interval_time
echo "0" > $VAP_DEV_DIR/mac_auth_enabled
echo "0" > $VAP_DEV_DIR/enable_supp_nonwpa
echo "0" > $VAP_DEV_DIR/supp_nonwpa
echo "0" > $VAP_DEV_DIR/wpa2_pre_auth
echo "86400" > $VAP_DEV_DIR/gk_rekey

echo "0" > $VAP_DEV_DIR/account_rs_enabled
echo "0.0.0.0" > $VAP_DEV_DIR/account_rs_ip
echo "0" > $VAP_DEV_DIR/account_rs_port
echo "" > $VAP_DEV_DIR/account_rs_password
echo "0" > $VAP_DEV_DIR/account_rs_update_enabled
echo "0" > $VAP_DEV_DIR/account_rs_update_delay
echo "0" > $VAP_DEV_DIR/account_rs_maxretry
echo "0" > $VAP_DEV_DIR/account_rs_interval_time

echo "0" > $VAP_DEV_DIR/enable_1x


encmode_type=`cat $VAP_DEV_DIR/encmode`

echo "1" > $VAP_DEV_DIR/wep


is_WPA=n
case $encmode_type in
	1)
		echo WEP_64;
		echo "1" > $VAP_DEV_DIR/encrypt;
		echo "1" > $VAP_DEV_DIR/wep;;
	5)
		echo WEP_128;
		echo "1" > $VAP_DEV_DIR/encrypt;
		echo "2" > $VAP_DEV_DIR/wep;;
	2)
		echo tkip;
		is_WPA=y;;
	4)
		echo aes;
		is_WPA=y;;
	0)
		echo No_Encrypt;
		echo "0" > $VAP_DEV_DIR/encrypt;;
	*)
		echo uknow_encmode_type $encmode_type;
		exit 1;;
esac



if [ "$is_WPA" = 'y' ]; then
	auth_type=`cat $VAP_DEV_DIR/psk_enable`
	wpacipher=`cat $VAP_DEV_DIR/WPA_CIPHER`
	wpa2cipher=`cat $VAP_DEV_DIR/WPA2_CIPHER`
	echo is_WPA=y
	case $auth_type in
		0)
			echo "PSK_DISABLE";;
		1)
			echo "auth_type is wpa";
			echo "2" > $VAP_DEV_DIR/encrypt;;
		2)
			echo "auth_type is wpa2";
			echo "4" > $VAP_DEV_DIR/encrypt;;
		3)
			echo "auth_type is wpa_wpa2_mixed";
			echo "6" > $VAP_DEV_DIR/encrypt;;
		*)
			echo uknow_auth_type $auth_type;
			exit 1
	esac
	
	
	case $wpacipher in
		2)
			echo "1" > $VAP_DEV_DIR/wpa_cipher;;
		8)
			echo "2" > $VAP_DEV_DIR/wpa_cipher;;
		10)
			echo "3" > $VAP_DEV_DIR/wpa_cipher;;
		*)
			echo "wpa_cipher don't have setting";
			exit 1;;
	esac
	
	case $wpa2cipher in
		2)
			echo "1" > $VAP_DEV_DIR/wpa2_cipher;;
		8)
			echo "2" > $VAP_DEV_DIR/wpa2_cipher;;
		10)
			echo "3" > $VAP_DEV_DIR/wpa2_cipher;;
		*)
			echo "wpa2_cipher don't have setting";
			exit 1;;
	esac
else
	echo "1" > $VAP_DEV_DIR/enable_1x
	echo "0" > $VAP_DEV_DIR/wpa_cipher
	echo "0" > $VAP_DEV_DIR/wpa2_cipher
fi



# 1: DOT11_AuthKeyType_RSN
# 2: DOT11_AuthKeyType_RSNPSK
echo "1" > $VAP_DEV_DIR/wpa_auth

echo "" > $VAP_DEV_DIR/wpa_psk

#0 - ACSII, 1 - hex ,For auth daemon
echo "0" > $VAP_DEV_DIR/psk_format

}






check_environment() {

	if [ -f $AUTH_PATH ]; then
        	echo "iwpriv path is" $AUTH_PATH
	else
        	echo $0 " ERROR : Can't find auth path. Path=" $AUTH_PATH
        	exit 1
	fi

	if [ -f $FLASH_PATH ]; then
        	echo "flash path is" $FLASH_PATH
	else
        	echo $0 " ERROR : Can't find flash path. Path=" $FLASH_PATH
        	exit 1
	fi


############# check config file path  ##########################
	if [ -d $CONFIG_ROOT_DIR ]; then
	        echo "config file path is" $CONFIG_ROOT_DIR
	else
	        echo $0 " ERROR : Can't find config file path. Path=" $CONFIG_ROOT_DIR
	        exit 1
	fi


	if [ -d  $VAP_DEV_DIR ]; then
		echo "config file path is" $VAP_DEV_DIR
	else
		echo "ERROR : Can't find config file path . Path=" $VAP_DEV_DIR
		exit 1
	fi


	if [ -f $IWPRIV_PATH/iwpriv ]; then
	        echo "iwpriv path is" $IWPRIV_PATH/iwpriv
	else
	        echo $0 " ERROR : Can't find iwpriv path. Path=" $IWPRIV_PATH/iwpriv
	        exit 1
	fi
}






run_radius_server() {

	############# check Parameter number is valid ##########################
	if [ $# -lt 4 ]; then
		echo "ERROR : incomplete command."
		echo "Example:" $0 "<option> <interface> <radius_serveer_ip> <auth interface>"
		echo "<option> : "
		echo "	open , close "
		echo "<auth interface> : "
		echo "	The interface located the side of radius server"
		exit 1
	fi

	check_environment


	ifconfig $interface_name down
	$SET_WLAN_PARAM psk_enable=0
#	echo 0 > $VAP_DEV_DIR/psk_enable
	ifconfig $interface_name up

	
	#config parameter for flash
	generate_config_parameter
	
	
	
	#geterate_config_file
	$FLASH_PATH wpa  $interface_name /var/tmp/wpa-$interface_name.conf $interface_name
	

	
	$AUTH_PATH $interface_name $RS_interafce auth /var/tmp/wpa-$interface_name.conf
	
}


rtl_close_interface() {
	for WLAN in $* ; do
		PIDFILE=/var/run/auth-$WLAN.pid
		if [ -f $PIDFILE ] ; then
			PID=`cat $PIDFILE`
			if [ $PID != 0 ]; then
				kill -9 $PID 2>/dev/null
			fi
			rm -f $PIDFILE
			rm -f $FOFO_NAME
		fi
	done	
}

mkdir /tmp/run -p


case $1 in
	close)
		rtl_close_interface $*;
		;;
	open)
		run_radius_server $*;
		;;
	*)
		echo "Error : Unknow command";;
esac






