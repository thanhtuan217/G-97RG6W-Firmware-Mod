
var CurUserLevel = 4;
var CurMainMenu = 0;
var CurSubMenu = "devinfo";

var CurLoginUser = 0;
var CurWifiConfig = 0;
var CurUsbConfig = 0;
var DisableTr069 = 0;
var DisableLoidCfg = 0;

var WebProject = "general";
var WebPotsNumber = 2;
var WebShowIpv6 = 1;
var WebShowWifi5g = 1;


var MainMenu = [
    // MainMenu[0]
    {
        "id": "m1_status",
        "show": 6,
        "submenu": [
            {
                "id": "devinfo",
                "show": 6,
                "submenu": null
            },
            {
                "id": "gponinfo",
                "show": 6,
                "submenu": null
            },
            {
                "id": "waninfo",
                "show": 6,
                "submenu": null
            },
            {
                "id": "wan3gstatus",
                "show": 0,
                "submenu": null
            },
            {
                "id": "laninfo",
                "show": 6,
                "submenu": null
            },
            {
                "id": "wifiinfo",
                "show": 6,
                "submenu": null
            },
            {
                "id": "wifi5info",
                "show": 6,
                "submenu": null
            },
            {
                "id": "devtable",
                "show": 6,
                "submenu": null
            },
            {
                "id": "rttable",
                "show": 6,
                "submenu": null
            },
            {
                "id": "restable",
                "show": 6,
                "submenu": null
            }
        ]
    },

    // MainMenu[1]
    {
        "id": "m1_wizard",
        "show": 0,
        "submenu": [
            {
                "id": "wizard",
                "show": 6,
                "submenu": null
            }
        ]
    },

    // MainMenu[2]
    {
        "id": "m1_wireless",
        "show": 7,
        "submenu": [
            {
                "id": "wifi24",
                "show": 7,
                "submenu": [
		            {
		                "id": "wifibasic",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifissid",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifisecu",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifiadv",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifiwps",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifiacc",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifilist",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifilog",
		                "show": 0,
		                "submenu": null

		            }
		        ]
            },
            {
                "id": "wifi5",
                "show": 7,
                "submenu": [
		            {
		                "id": "wifi5basic",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifi5ssid",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifi5secu",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifi5adv",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifi5wps",
		                "show": 7,
		                "submenu": null
		            },
		            {
		                "id": "wifi5acc",
		                "show": 7,
		                "submenu": null
		            },
			    {
		                "id": "wifi5list",
		                "show": 7,
		                "submenu": null

		            }
		        ]
            }
        ]
    },

    // MainMenu[3]
    {
        "id": "m1_advanced",
        "show": 6,
        "submenu": [
            {
                "id": "ipnetwork",
                "show": 6,
                "submenu": [
		            {
		                "id": "lan",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "lanadvanced",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "lanipv6",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "wan",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "nat",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "ddns",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "alg",
		                "show": 6,
		                "submenu": null
		            }
		        ]
            },
            {
                "id": "bridge",
                "show": 6,
                "submenu": [
		            {
		                "id": "brgif",
		                "show": 0,
		                "submenu": null
		            },
		            {
		                "id": "brg",
		                "show": 6,
		                "submenu": null
		            }
		        ]
            },
            {
                "id": "qos",
                "show": 6,
                "submenu": null
            },
            {
                "id": "usb",
                "show": 6,
                "submenu": [
		            {
		                "id": "usbstr",
		                "show": 6,
		                "submenu": null
		            }
		        ]
            },
            {
                "id": "routing",
                "show": 6,
                "submenu": [
		            {
		                "id": "sroute",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "ip6sroute",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "proute",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "ip6proute",
		                "show": 6,
		                "submenu": null
		            }
		        ]
            }
        ]
    },
    
    // MainMenu[4]
    {
        "id": "m1_secu",
        "show": 6,
        "submenu": [
            {
                "id": "management",
                "show": 6,
                "submenu": [
		            {
		                "id": "password",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "loid",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "rmtweb",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "telnet",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "ssh",
		                "show": 6,
		                "submenu": null
		            }
		        ]
            },
            {
            	"id": "security",
                "show": 6,
                "submenu": [
		            {
		                "id": "ipfilter",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "ipv6firewall",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "macfilter",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "webfilter",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "portfwd",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "dmz",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "upnp",
		                "show": 6,
		                "submenu": null
		            }
		        ]
            }
		]
	},

    // MainMenu[5]
    {
        "id": "m1_voip",
        "show": 6,
        "submenu": [
            {
                "id": "voip",
                "show": 6,
                "submenu": [
		            {
		                "id": "voipbasic",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "voipadv",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "sipcodecs",
		                "show": 6,
		                "submenu": null
		            }
		        ]
            },
            {
                "id": "sip",
                "show": 6,
                "submenu": [
		            {
		                "id": "sipbasic",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "sipadv",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "sipfax",
		                "show": 6,
		                "submenu": null
		            },
		            {
		                "id": "sipdmap",
		                "show": 6,
		                "submenu": null
		            }
		        ]

            },
            {
                "id": "h248",
                "show": 0,
                "submenu": [
		            {
		                "id": "h248basic",
		                "show": 0,
		                "submenu": null
		            },
		            {
		                "id": "h248fax",
		                "show": 0,
		                "submenu": null
		            },
		            {
		                "id": "h248dmap",
		                "show": 0,
		                "submenu": null		            
					}
		        ]
            }

        ]
    },

    // MainMenu[6]
    {
        "id": "m1_utilities",
        "show": 6,
        "submenu": [
            {
                "id": "reboot",
                "show": 6,
                "submenu": null
            },
            {
                "id": "init",
                "show": 6,
                "submenu": null
            },
            {
                "id": "upgrade",
                "show": 6,
                "submenu": null
            },
            {
                "id": "ping",
                "show": 6,
                "submenu": null
            },
            {
                "id": "traceroute",
                "show": 6,
                "submenu": null
            },
            {
                "id": "backup",
                "show": 6,
                "submenu": null
            },
            {
                "id": "restore",
                "show": 6,
                "submenu": null
            },
            {
                "id": "log",
                "show": 6,
                "submenu": null
            },
            {
                "id": "ntp",
                "show": 6,
                "submenu": null
            },
            {
                "id": "sys",
                "show": 6,
                "submenu": null
            }
        ]
    },

    // MainMenu[7]
    {
        "id": "m1_support",
        "show": 6,
        "submenu": [
            {
                "id": "iptvmulticast",
                "show": 6,
                "submenu": null
            },
			{
                "id": "tr069",
                "show": 0,
                "submenu": null
            },

         ]
    }
];
