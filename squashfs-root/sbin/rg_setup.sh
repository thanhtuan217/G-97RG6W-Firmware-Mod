
#mount -t $FSTYPE $USERFS /mnt/usrfs > /dev/null 2>&1
#if [ $? -eq 0 ] ; then
#	echo "mount $USERFS as $FSTYPE (/mnt/usrfs) ok "
#else
#	echo "mount $USERFS as $FSTYPE (/mnt/usrfs) failed "
#fi

insmod /lib/modules/3.18.24/kernel/net/netfilter/nf_conntrack_ftp.ko
insmod /lib/modules/3.18.24/kernel/net/netfilter/nf_conntrack_tftp.ko
insmod /lib/modules/3.18.24/kernel/net/netfilter/nf_conntrack_sip.ko
insmod /lib/modules/3.18.24/kernel/net/netfilter/nf_nat_ftp.ko
insmod /lib/modules/3.18.24/kernel/net/netfilter/nf_nat_tftp.ko
insmod /lib/modules/3.18.24/kernel/net/netfilter/nf_nat_sip.ko
