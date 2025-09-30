#!/bin/sh

#copy from inittab
/sbin/ifconfig lo 127.0.0.1 up
/sbin/route add -net 127.0.0.0 netmask 255.0.0.0 lo

mount -a

cp /etc/pam/passwd /tmp/
cp /etc/pam/group /tmp/

# for udev function, dynamic dev node
/bin/echo /sbin/mdev > /proc/sys/kernel/hotplug
/bin/mount -t tmpfs mdev /dev
mdev -s
sleep 1

mkdir -p /dev/pts
/bin/mount -t devpts devpts /dev/pts

if [ -f /debug ]; then
mknod -m 0666 /dev/null c 1 3
mknod -m 0666 /dev/zero c 1 5
mknod -m 0600 /dev/console c 5 1
mknod -m 0622 /dev/ttyS0 c 4 64
mknod -m 0666 /dev/aipc_dev       c 253 0
fi

#for voip dev
mkdir -p /dev/voip
mknod -m 0660 /dev/voip/dtmfdet0  c 243 76
mknod -m 0660 /dev/voip/dtmfdet1  c 243 77
mknod -m 0660 /dev/voip/ipc       c 243 66
mknod -m 0660 /dev/voip/ivr8k     c 243 16
mknod -m 0660 /dev/voip/log_ioctl c 243 40
mknod -m 0660 /dev/voip/mgr       c 243  1
mknod -m 0660 /dev/voip/pcmrx0    c 243 65
mknod -m 0660 /dev/voip/pcmrx1    c 243 74
mknod -m 0660 /dev/voip/pcmtx0    c 243 64
mknod -m 0660 /dev/voip/pcmtx1    c 243 73
mknod -m 0666 /dev/dsp_console    c 252 0






#mdev -s
#sleep 1

	
#cp -f /etc/resolv.conf.rwdir /mnt/rwdir/resolv.conf

mount -t jffs2 /dev/mtdblock10 /mnt/midware > /dev/null 2>&1

if [ $? -eq 0 ] ; then
        echo " #mount midware ok "
else
        flash_eraseall /dev/mtd10
        mount -t jffs2 /dev/mtdblock10 /mnt/midware > /dev/null 2>&1
fi
touch /tmp/voip_resolv.conf
touch /tmp/rg_resolv.conf


FSTYPE=squashfs
DEVICE=/dev/mtdblock2
USERFS=/dev/mtdblock6


export FSTYPE DEVICE USERFS

########

#tar xzvf /etc/ramdisk.tgz -C /tmp > /dev/null
#mount -o loop /tmp/ramdisk /mnt/ramdisk

#/tmp/log/messages for syslogd
mkdir -p /tmp/log
syslogd -S -s 1000

mkdir -p /tmp/run

#ftp server use this directory to save firmware Image file
#mkdir -p  /tmp/home/root
#bftpd -d

dmesg -n 2

#install your modules here

insmod /lib/modules/3.18.24/kernel/drivers/kvos.ko
insmod /lib/modules/3.18.24/kernel/drivers/klog.ko
insmod /lib/modules/3.18.24/kernel/drivers/misc_mod.ko
#insmod /lib/modules/3.18.24/kernel/drivers/mdr_dbg_mod.ko
insmod /lib/modules/3.18.24/kernel/drivers/enet_drv.ko platform_type=1
insmod /lib/modules/3.18.24/kernel/drivers/cig_gpon.ko
insmod /lib/modules/3.18.24/kernel/net/netfilter/nf_conntrack_urlfilter.ko
insmod /lib/modules/3.18.24/kernel/drivers/net/tun.ko

####
if [ -f "/lib/modules/3.18.24/kernel/drivers/voip_manager.ko" ]; then
insmod /lib/modules/3.18.24/kernel/drivers/voip_manager.ko
fi


#set the max number of message queue
echo 32 >  /proc/sys/kernel/msgmni
echo 65536 >  /proc/sys/kernel/msgmnb
echo 65536 >  /proc/sys/kernel/msgmax

cp -R /etc/nginx /tmp
cd /tmp
cp -rf /web /tmp/
cd -
[ -f /sbin/rg_setup.sh ] && sh /sbin/rg_setup.sh
#change kernal min memory
echo 4096 > /proc/sys/vm/min_free_kbytes

mkdir /tmp/download

#[ -f /sbin/rg_setup.sh ] && sh /sbin/rg_setup.sh
#insmod wifi ko
#[ -f /sbin/wifi_drv_install.sh ] && sh /sbin/wifi_drv_install.sh 

echo 1 > /proc/fc/ctrl/flow_skipL2CtTracking
echo 1 > /proc/fc/ctrl/wifiSlowPathRxbyNic
echo 2 > /proc/fc/ctrl/flow_sync_period
echo 300 > /proc/fc/ctrl/non_fdb_uc_timeout_sec


mount -t jffs2 /dev/mtdblock4 /mnt/rwdir

#function request in issue 10391
if [ $? -eq 0 ] ; then
	echo " #mount rwdir (ont.mib) ok "
else
	flash_eraseall /dev/mtd4
	mount -t jffs2 /dev/mtdblock4 /mnt/rwdir > /dev/null 2>&1
fi

if [ ! -d /mnt/rwdir/ct ] ; then
	mkdir /mnt/rwdir/ct
fi

mount -t jffs2 /dev/mtdblock5 /mnt/rwdir2

if [ $? -eq 0 ] ; then
	echo " #mount rwdir2 (ont.mib) ok "
else
	flash_eraseall /dev/mtd5
	mount -t jffs2 /dev/mtdblock5 /mnt/rwdir2 > /dev/null 2>&1
	echo "not mount"
fi

#for cramfs debug interface, you can do all like this:
#1. copy /sbin/setup.sh to /mnt/rwdir 
#then modify /mnt/rwdir/setup.sh
#2. delete flash_erase /dev/mtd1
#3. delete [ -f /mnt/rwdir/setup.sh ] && /mnt/rwdir/setup.sh && exit
[ -f /mnt/rwdir/setup.sh ] && /mnt/rwdir/setup.sh && exit

#init senseSDK
mkdir -p /tmp/fsc/bin

/bin/Console &
/bin/telnetd &
/usr/sbin/dropbear 1>/dev/null 2>&1
/bin/GponCLI --script &
/bin/GponCLI --hook &
/bin/GponCLI --web-cli &


Ssp
dmesg -n 2

#/bin/sh
