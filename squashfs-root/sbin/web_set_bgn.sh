#!/bin/sh
#iwpriv wlan0 band=<bgn_mode>


CONFIG_ROOT_DIR=/var/tmp/rtl8192c


##################### check interface name , This is invalid in VAP interface ################
if_name=$1
len=`echo ${#if_name}`
if [ $len -lt 11 ]; then
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


############# check Parameter number is valid ##########################
if [ $# -lt 2 ]; then
echo "ERROR : incomplete command."
echo "Example:" $0 "<interface name>"
exit 1
fi


###########################################################################################




SET_WLAN="$IWPRIV_PATH/iwpriv $1"
SET_WLAN_PARAM="$SET_WLAN set_mib"
IFCONFIG=ifconfig



case $2 in
	b_mode)
		deny_legacy=0;
		use40M=0;
		op_mode=1;;	
	g_mode)
		deny_legacy=1;
		use40M=0;
		op_mode=2;;
	g_n_mode)
		deny_legacy=1;
		use40M=1;
		op_mode=10;;
	b_g_mode)
		deny_legacy=1;
		use40M=1;
		op_mode=3;;
	n_mode)
		deny_legacy=3;
		use40M=1;
		op_mode=8;;
	mixed)
		deny_legacy=0;
		use40M=1;
		op_mode=11;;
	*)                             
		echo "ERROR : op_mode. it should be b_mode,g_mode,n_mode or mixed";
		exit 1;;
esac

$SET_WLAN_PARAM band=$op_mode
$SET_WLAN_PARAM use40M=$use40M
$SET_WLAN_PARAM deny_legacy=$deny_legacy

echo $op_mode > $CONFIG_DIR/band
echo $use40M > $CONFIG_DIR/use40M
echo $use40M > $CONFIG_DIR/deny_legacy


