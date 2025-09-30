#!/bin/sh
#./web_wps_setting.sh <interface> <wlan_mode> <wsc auth>
#<wlan_mode> : 
#		ap=0, client=1, wds_mode=2, ap_wds_mode=3
#
#<wsc auth> : 
#	wep , wpa , wpa2  or wpa_wpa2_mixed
#
#<wsc encrypt> : 
#		tkip_aes_mixed , aes
#


CONFIG_ROOT_DIR=/var/run/rtl8192c
FLASH_PATH=/sbin/flash_rtk
IWCONTROL_PATH=/sbin/iwcontrol
WSCD_PATH=/sbin/wscd
SIMPLECFG_PATH=/sbin/simplecfgservice.xml
IN_CONFIG_FILE_PATH=/sbin/wscd.conf
OUT_CONFIG_FILE_PATH=/var/run/wsc-$1.conf
FIFO_FILE=/var/run/wscd-$1.fifo
PIDFILE=/var/run/run/wscd-$1.pid
XML_DIR=/var/run/wps
FI=-fi

############# set fi ##########################
if [ "wlan1" = $1 ];then
	FI=-fi2
fi


############# check Parameter number is valid ##########################
if [ $# -lt 2 ]; then
	echo "ERROR : incomplete command."
	echo "Example:" $0 "<interface> <open or close>"
exit 1
fi


case $2 in
	close)
		if [ -f $PIDFILE ] ; then
			PID=`cat $PIDFILE`
			echo "KILL WSCD_PID=$PID"
			if [ $PID != 0 ]; then
				kill -9 $PID 2>/dev/null
			fi
			rm -f $PIDFILE   
			rm -f $FIFO_FILE
			rm -f $OUT_CONFIG_FILE_PATH
		fi 
		exit 1;;
	open)
		;;
	*)
		echo "Error : Unknow command";
		exit 1;;
esac


########################### check environment ####################################

if [ -f $FLASH_PATH ]; then
       	echo "flash path is" $FLASH_PATH
else
       	echo $0 " ERROR : Can't find flash path. Path=" $FLASH_PATH
       	exit 1
fi

if [ -f $IWCONTROL_PATH ]; then
       	echo "iwcontrol path is" $IWPRIV_PATH/iwpriv
else
       	echo $0 " ERROR : Can't find iwcontrol path. Path=" $IWCONTROL_PATH
       	exit 1
fi

if [ -f $WSCD_PATH ]; then
       	echo "wscd path is" $WSCD_PATH
else
       	echo $0 " ERROR : Can't find wscd path. Path=" $WSCD_PATH
       	exit 1
fi

if [ -f $SIMPLECFG_PATH ]; then
       	echo "wscd path is" $SIMPLECFG_PATH
       	rm $XML_DIR -rf
       	mkdir $XML_DIR
				cp $SIMPLECFG_PATH $XML_DIR
else
       	echo $0 " ERROR : Can't find simplecfg*.xml path. Path=" $SIMPLECFG_PATH
       	exit 1
fi
	

if [ -f $IN_CONFIG_FILE_PATH ]; then
       	echo "wscd path is" $IN_CONFIG_FILE_PATH
else
       	echo $0 " ERROR : Can't find config file path. Path=" $IN_CONFIG_FILE_PATH
       	exit 1
fi

##################### check interface name , This is invalid in VAP interface ################
if_name=$1
len=`echo ${#if_name}`
if [ $len -lt 6 ]; then
	echo ""
else
	echo "Error : Interface name error"
	exit 1
fi

############# check config file path  ##########################

if [ -d $CONFIG_ROOT_DIR ]; then
        echo "root config folder path is" $CONFIG_ROOT_DIR
else
        echo $0 " ERROR : Can't find root config folder path. Path=" $CONFIG_ROOT_DIR
        exit 1
fi


CONFIG_DIR=$CONFIG_ROOT_DIR/$1
if [ -d  $CONFIG_DIR ]; then
	echo "device config folder path is" $CONFIG_DIR
else
	echo "ERROR : Can't find device config folder path . Path=" $CONFIG_DIR
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





########################################################################




SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"
IFCONFIG=ifconfig







opmode=`cat $CONFIG_DIR/opmode`
case $opmode in
	16)
		echo "0" > $CONFIG_DIR/wlan_mode;
		echo "AP mode";;		
	8 | 32)
		echo "1" > $CONFIG_DIR/wlan_mode;
		echo "CLIENT mode";;
	*)                             
		echo "ERROR : unknow operate mode ";
		exit 1;;
esac



# mkdir wifi_conf
mkdir /tmp/run -p

# ifterface is enable or disable
echo "0" >  $CONFIG_DIR/wlan_disabled
echo "0" > $CONFIG_DIR/wsc_disabled

#auth : 1:ridus server 2:PSK
echo "2" > $CONFIG_DIR/wpa_auth

echo "0" > $CONFIG_DIR/wsc_upnp_enabled
echo "0" > /var/tmp/rtl8192c/repeater_enabled
echo "81333066" > $CONFIG_DIR/wsc_pin
echo "3" > $CONFIG_DIR/wsc_method
echo "1" > /var/tmp/rtl8192c/$1/wsc_configured
#pin method support internal registrar
case $3 in
	pin_method)
		echo "1" > /var/tmp/rtl8192c/$1/wsc_registrar_enabled
		;;
	*)
		;;
esac
echo "0" > /var/tmp/rtl8192c/$1/wsc_configbyextreg






encmode_type=`cat $CONFIG_DIR/encmode`
case $encmode_type in
	2)
		echo tkip;;
	4)
		echo aes;;
	*)
		echo "ERROR : wsc auth . WPS2.x only support WPA2 or WPA/WPA2 mixed mode ,so please type wpa2 or wpa_wpa2_mixed ";
		exit 1;;
esac


auth_type=`cat $CONFIG_DIR/psk_enable`
case $auth_type in
#	1)
#		echo "auth_type is wpa";
#		echo "2" > $CONFIG_DIR/wsc_auth;
#		echo "2" > $CONFIG_DIR/encrypt;;

	2)
		echo "auth_type is wpa2";
		echo "32" > $CONFIG_DIR/wsc_auth;
		echo "4" > $CONFIG_DIR/encrypt;;
	3)
		echo "auth_type is wpa_wpa2_mixed";
		echo "34" > $CONFIG_DIR/wsc_auth;
		echo "6" > $CONFIG_DIR/encrypt;;
	*)
		echo "ERROR : wsc auth . WPS2.x only support WPA2 or WPA/WPA2 mixed mode";
		exit 1;;
esac




#the value of WPA_CIPHER & WPA3_CIPHER must be same. 
wpacipher=`cat $CONFIG_DIR/WPA_CIPHER`
case $wpacipher in
#	2)
#		echo "TKIP mode";
#		echo "1" > $VAP_DEV_DIR/wpa_cipher;;
	8)
		echo "AES mode";
		echo "8" > $CONFIG_DIR/wsc_enc;;
	10)
		echo "TKIP_AES_MIXED mode";
		echo "12" > $CONFIG_DIR/wsc_enc;;
	*)
		echo "ERROR : wsc auth . WPS2.x only support AES or AES/TKIP mixed mode";
		exit 1;;
esac




if [ -f $CONFIG_DIR/passphrase ]; then
	wpa_psk=`cat $CONFIG_DIR/passphrase`
	echo $wpa_psk > $CONFIG_DIR/wpa_psk
else
	echo $0 " ERROR : Can't find PSK passwoed. Path=" $CONFIG_DIR/passphrase
	exit 1
fi




rm -f $OUT_CONFIG_FILE_PATH
$FLASH_PATH upd-wsc-conf $IN_CONFIG_FILE_PATH $OUT_CONFIG_FILE_PATH $1 
case $3 in
	pin_method)
		sed -i 's/^config_method.*/config_method = 8/g' $OUT_CONFIG_FILE_PATH
		$WSCD_PATH -start -c $OUT_CONFIG_FILE_PATH -w $1 $FI $FIFO_FILE -local_pin $4 -daemon
		;;
	*)
		$WSCD_PATH -start -c $OUT_CONFIG_FILE_PATH -w $1 $FI $FIFO_FILE -daemon
		;;
esac



