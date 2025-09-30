#!/bin/sh

mkdir -p /tmp/web/html/mirror

ln -sfn	/web/html/fpt/aoe.html	/tmp/web/html/aoe.html
ln -sfn	/web/html/fpt/ipfilter.html	/tmp/web/html/ipfilter.html
ln -sfn	/web/html/fpt/loopdetect.html	/tmp/web/html/loopdetect.html
ln -sfn	/web/html/fpt/qos.html	/tmp/web/html/qos.html
ln -sfn	/web/html/fpt/wan.html	/tmp/web/html/wan.html
ln -sfn	/web/html/fpt/wifiadv.html	/tmp/web/html/wifiadv.html
ln -sfn	/web/html/fpt/brg.html	/tmp/web/html/brg.html
ln -sfn	/web/html/fpt/ipratelimit.html	/tmp/web/html/ipratelimit.html
ln -sfn	/web/html/fpt/macfilter.html	/tmp/web/html/macfilter.html
ln -sfn	/web/html/fpt/rebootswitchtimer.html	/tmp/web/html/rebootswitchtimer.html
ln -sfn	/web/html/fpt/waninfo.html	/tmp/web/html/waninfo.html
ln -sfn	/web/html/fpt/wifilist.html	/tmp/web/html/wifilist.html
ln -sfn	/web/html/fpt/connection.html	/tmp/web/html/connection.html
ln -sfn	/web/html/fpt/lan.html	/tmp/web/html/lan.html
ln -sfn	/web/html/fpt/portal.html	/tmp/web/html/portal.html
ln -sfn	/web/html/fpt/selftest.html	/tmp/web/html/selftest.html
ln -sfn	/web/html/fpt/webfilter.html	/tmp/web/html/webfilter.html
ln -sfn	/web/html/fpt/wifilog.html	/tmp/web/html/wifilog.html
ln -sfn	/web/html/fpt/devinfo.html	/tmp/web/html/devinfo.html
ln -sfn	/web/html/fpt/lanipv6.html	/tmp/web/html/lanipv6.html
ln -sfn	/web/html/fpt/pptpd.html	/tmp/web/html/pptpd.html
ln -sfn	/web/html/fpt/voipadv.html	/tmp/web/html/voipadv.html
ln -sfn	/web/html/fpt/wifi5list.html	/tmp/web/html/wifi5list.html
ln -sfn	/web/html/fpt/wifiswitchtimer.html	/tmp/web/html/wifiswitchtimer.html
ln -sfn	/web/html/fpt/mirror.html	/tmp/web/html/mirror.html

if ( test "$1" = "RG3T" )
then
	ln -sfn	/web/html/fpt/images/wifi_portal_help1_3T.jpg	/tmp/web/html/images/wifi_portal_help1.jpg
	ln -sfn	/web/html/fpt/images/wifi_portal_help2_3T.jpg	/tmp/web/html/images/wifi_portal_help2.jpg
else
	ln -sfn	/web/html/fpt/images/wifi_portal_help1_6W.jpg	/tmp/web/html/images/wifi_portal_help1.jpg
	ln -sfn	/web/html/fpt/images/wifi_portal_help2_6W.jpg	/tmp/web/html/images/wifi_portal_help2.jpg
fi

ln -sfn /web/html/fpt/images/help.png   /tmp/web/html/images/help.png
ln -sfn	/web/html/fpt/images/wifi_portal.jpg	/tmp/web/html/images/wifi_portal.jpg
ln -sfn	/web/html/fpt/images/wifiwarning.jpg	/tmp/web/html/images/wifiwarning.jpg
ln -sfn /web/html/fpt/images/logo_fpt.png /tmp/web/html/images/logo.png

ln -sfn /web/html/fpt/script/rg_menu.js   /tmp/web/html/script/rg_menu.js
ln -sfn /web/html/fpt/script/rg_sfu_menu.js /tmp/web/html/script/rg_sfu_menu.js

ln -sfn /web/html/fpt/mirror/mirror.html /tmp/web/html/mirror/mirror.html
