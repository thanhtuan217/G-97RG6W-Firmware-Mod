#!/bin/sh
#./web_channel.sh  <interface> <channel>


CONFIG_ROOT_DIR=/var/tmp/rtl8192c


#################################################
# check interface name
# This is invalid in VAP interface 
#################################################
if_name=$1
len=`echo ${#if_name}`
if [ $len -lt 6 ]; then
	echo ""
else
	echo "Error : Interface name error"
	exit 1
fi


#################################################
# check config file path  
#################################################

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



#################################################
# get iwpriv path  
#################################################
IWPRIV_PATH=`cat $CONFIG_ROOT_DIR/iwpriv_path`
if [ -f $IWPRIV_PATH/iwpriv ]; then
        echo "iwpriv path is" $IWPRIV_PATH/iwpriv
else
        echo $0 " ERROR : Can't find iwpriv path. Path=" $IWPRIV_PATH/iwpriv
        exit 1
fi

export IWPRIV_PATH=$IWPRIV_PATH


SET_WLAN="$IWPRIV_PATH/iwpriv $1"
EFUSE_SET_WLAN_PARAM="$SET_WLAN efuse_set"
IFCONFIG=ifconfig














#################################################
# For 2.4G band 
#################################################
# EFUSE MAP
# 8192c_reg.h keyword : EEPROM_TxPowerCCK
#offset 0x5A : HW_TX_POWER_CCK_A : channel 1~3
#offset 0x5B : HW_TX_POWER_CCK_A : channel 4~9
#offset 0x5C : HW_TX_POWER_CCK_A : channel 10~14
#offset 0x5D : HW_TX_POWER_CCK_B : channel 1~3
#offset 0x5E : HW_TX_POWER_CCK_B : channel 4~9
#offset 0x5F : HW_TX_POWER_CCK_B : channel 10~14
#offset 0x60 : HW_TX_POWER_HT40_1S_A : channel 1~3
#offset 0x61 : HW_TX_POWER_HT40_1S_A : channel 4~9
#offset 0x62 : HW_TX_POWER_HT40_1S_A : channel 10~14
#offset 0x63 : HW_TX_POWER_HT40_1S_B : channel 1~3
#offset 0x64 : HW_TX_POWER_HT40_1S_B : channel 4~9
#offset 0x65 : HW_TX_POWER_HT40_1S_B : channel 10~14
#offset 0x66 : HW_TX_POWER_DIFF_HT40_2S : channel 1~3
#offset 0x67 : HW_TX_POWER_DIFF_HT40_2S : channel 4~9
#offset 0x68 : HW_TX_POWER_DIFF_HT40_2S : channel 10~14
#offset 0x69 : HW_TX_POWER_DIFF_HT20 : channel 1~3
#offset 0x6a : HW_TX_POWER_DIFF_HT20 : channel 4~9
#offset 0x6b : HW_TX_POWER_DIFF_HT20 : channel 10~14
#offset 0x6c : HW_TX_POWER_DIFF_OFDM : channel 1~3
#offset 0x6d : HW_TX_POWER_DIFF_OFDM : channel 4~9
#offset 0x6e : HW_TX_POWER_DIFF_OFDM : channel 10~14
#offset 0x16~1b : HW_WLAN0_WLAN_ADDR
#offset 0x78 : HW_11N_THER
#===================================================




HW_TX_POWER_CCK_A=202122232425262728292A2B2C2D
HW_TX_POWER_CCK_B=303132333435363738393A3B3C3D
HW_TX_POWER_HT40_1S_A=0102030405060708090A0B0C0D
HW_TX_POWER_HT40_1S_B=0102030405060708090A0B0C0D
HW_TX_POWER_DIFF_HT40_2S=0102030405060708090A0B0C0D
HW_TX_POWER_DIFF_HT20=0102030405060708090A0B0C0D
HW_TX_POWER_DIFF_OFDM=ffffffffffffffffffffffffffff
HW_WLAN0_WLAN_ADDR=ffffffffffffffffffffffffffff
HW_11N_THER=00



$EFUSE_SET_WLAN_PARAM HW_TX_POWER_CCK_A=$HW_TX_POWER_CCK_A
$EFUSE_SET_WLAN_PARAM HW_TX_POWER_CCK_B=$HW_TX_POWER_CCK_B
$EFUSE_SET_WLAN_PARAM HW_TX_POWER_HT40_1S_A=$HW_TX_POWER_HT40_1S_A
$EFUSE_SET_WLAN_PARAM HW_TX_POWER_HT40_1S_B=$HW_TX_POWER_HT40_1S_B
$EFUSE_SET_WLAN_PARAM HW_TX_POWER_DIFF_HT40_2S=$HW_TX_POWER_DIFF_HT40_2S
$EFUSE_SET_WLAN_PARAM HW_TX_POWER_DIFF_HT20=$HW_TX_POWER_DIFF_HT20
$EFUSE_SET_WLAN_PARAM HW_TX_POWER_DIFF_OFDM=$HW_TX_POWER_DIFF_OFDM
$EFUSE_SET_WLAN_PARAM HW_WLAN0_WLAN_ADDR=$HW_WLAN0_WLAN_ADDR
$EFUSE_SET_WLAN_PARAM HW_11N_THER=$HW_11N_THER






#################################################
# For 5G band
#################################################
# EFUSE MAP
# 8192d_reg.h keyword : EEPROM_2G_TxPowerCCK
#################################################
#HW_TX_POWER_5G_HT40_1S_A
#HW_TX_POWER_5G_HT40_1S_B
#HW_TX_POWER_DIFF_5G_HT40_2S
#HW_TX_POWER_DIFF_5G_HT20
#HW_TX_POWER_DIFF_5G_OFDM
#HW_11N_TRSWPAPE_C9
#HW_11N_TRSWPAPE_CC
#HW_11N_XCAP
#$EFUSE_SET_WLAN_PARAM HW_TX_POWER_5G_HT40_1S_A=$HW_TX_POWER_5G_HT40_1S_A
#$EFUSE_SET_WLAN_PARAM HW_TX_POWER_5G_HT40_1S_B=$HW_TX_POWER_5G_HT40_1S_B
#$EFUSE_SET_WLAN_PARAM HW_TX_POWER_DIFF_5G_HT40_2S=$HW_TX_POWER_DIFF_5G_HT40_2S
#$EFUSE_SET_WLAN_PARAM HW_TX_POWER_DIFF_5G_HT20=$HW_TX_POWER_DIFF_5G_HT20
#$EFUSE_SET_WLAN_PARAM HW_TX_POWER_DIFF_5G_OFDM=$HW_TX_POWER_DIFF_5G_OFDM
#$EFUSE_SET_WLAN_PARAM HW_11N_TRSWPAPE_C9=$HW_11N_TRSWPAPE_C9
#$EFUSE_SET_WLAN_PARAM HW_11N_TRSWPAPE_CC=$HW_11N_TRSWPAPE_CC
#$EFUSE_SET_WLAN_PARAM HW_11N_XCAP=$HW_11N_XCAP
####################################################

$SET_WLAN efuse_sync
