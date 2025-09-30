
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
var WebShowWifi5g = 0;

var MainMenu = [
    // MainMenu[0]
    {
        "id": "m1_status",
        "show": 7,
        "submenu": [
            {
                "id": "devinfo",
                "show": 7,
                "submenu": null
            },
            {
                "id": "gponinfo",
                "show": 0,
                "submenu": null
            },
            {
                "id": "waninfo",
                "show": 0,
                "submenu": null
            },
            {
                "id": "wan3gstatus",
                "show": 0,
                "submenu": null
            },
            {
                "id": "laninfo",
                "show": 7,
                "submenu": null
            },
            {
                "id": "vlaninfo",
                "show": 7,
                "submenu": null
            },
            {
                "id": "wifiinfo",
                "show": 0,
                "submenu": null
            },
            {
                "id": "wifi5info",
                "show": 0,
                "submenu": null
            },
            {
                "id": "devtable",
                "show": 0,
                "submenu": null
            },
            {
                "id": "rttable",
                "show": 0,
                "submenu": null
            },
            {
                "id": "restable",
                "show": 0,
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
                "show": 7,
                "submenu": null
            }
        ]
    },

    // MainMenu[2]
    {
        "id": "m1_wireless",
        "show": 0,
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
		                "show": 7,
		                "submenu": null
		            }
                ]
            },
            {
                "id": "wifi5",
                "show": 0,
                "submenu": [
                    {
                        "id": "wifi5basic",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "wifi5ssid",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "wifi5secu",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "wifi5adv",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "wifi5wps",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "wifi5acc",
                        "show": 0,
                        "submenu": null
                    }
                ]
            }
        ]
    },

    // MainMenu[3]
    {
        "id": "m1_advanced",
        "show": 7,
        "submenu": [
            {
                "id": "ipnetwork",
                "show": 7,
                "submenu": [
                    {
                        "id": "lan",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "lanadvanced",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "lanipv6",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "wan",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "nat",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "ddns",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "alg",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "aoe",
                        "show": 0,
                        "submenu": null
                    }
                ]
            },
            {
                "id": "uplinkinterfaces",
                "show": 0,
                "submenu": [
                    {
                        "id": "wan3g",
                        "show": 7,
                        "submenu": null
                    }
                ]
            },            
            {
                "id": "bridge",
                "show": 0,
                "submenu": [
                    {
                        "id": "brg",
                        "show": 7,
                        "submenu": null
                    }
                ]
            },
            {
                "id": "qos",
                "show": 0,
                "submenu": null
            },
            {
                "id": "usb",
                "show": 0,
                "submenu": [
                    {
                        "id": "usbstr",
                        "show": 7,
                        "submenu": null
                    }
                ]
            },
            {
                "id": "routing",
                "show": 0,
                "submenu": [
                    {
                        "id": "sroute",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "ip6sroute",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "proute",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "ip6proute",
                        "show": 7,
                        "submenu": null
                    }
                ]
            }
        ]
    },
    
    // MainMenu[4]
    {
        "id": "m1_secu",
        "show": 7,
        "submenu": [
            {
                "id": "management",
                "show": 7,
                "submenu": [
                    {
                        "id": "password",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "loid",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "rmtweb",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "telnet",
                        "show": 0,
                        "submenu": null
                    },
                    {
                        "id": "ssh",
                        "show": 0,
                        "submenu": null
                    }
                ]
            },
            {
                "id": "security",
                "show": 0,
                "submenu": [
                    {
                        "id": "ipfilter",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "ipv6firewall",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "macfilter",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "webfilter",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "portfwd",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "dmz",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "upnp",
                        "show": 7,
                        "submenu": null
                    }
                ]
            }
        ]
    },

    // MainMenu[5]
    {
        "id": "m1_voip",
        "show": 0,
        "submenu": [
            {
                "id": "voip",
                "show": 0,
                "submenu": [
                    {
                        "id": "voipbasic",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "voipadv",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "sipcodecs",
                        "show": 7,
                        "submenu": null
                    }
                ]
            },
            {
                "id": "sip",
                "show": 0,
                "submenu": [
                    {
                        "id": "sipbasic",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "sipadv",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "sipfax",
                        "show": 7,
                        "submenu": null
                    },
                    {
                        "id": "sipdmap",
                        "show": 7,
                        "submenu": null
                    }
                ]
            },
//            {
//                "id": "h248",
//                "show": 7,
//                "submenu": [
//                  {
//                      "id": "h248basic",
//                      "show": 7,
//                      "submenu": null
//                  },
//                  {
//                      "id": "h248fax",
//                      "show": 7,
//                      "submenu": null
//                  },
//                  {
//                      "id": "h248dmap",
//                      "show": 7,
//                      "submenu": null
//                  }
//              ]
//            }
        ]
    },

    // MainMenu[6]
    {
        "id": "m1_utilities",
        "show": 7,
        "submenu": [
            {
                "id": "reboot",
                "show": 7,
                "submenu": null
            },
            {
                "id": "init",
                "show": 7,
                "submenu": null
            },
            {
                "id": "upgrade",
                "show": 7,
                "submenu": null
            },
            {
                "id": "ping",
                "show": 0,
                "submenu": null
            },
            {
                "id": "traceroute",
                "show": 0,
                "submenu": null
            },
            {
                "id": "tcpdump",
                "show": 0,
                "submenu": null
            },
            {
                "id": "backup",
                "show": 0,
                "submenu": null
            },
            {
                "id": "restore",
                "show": 0,
                "submenu": null
            },
            {
                "id": "log",
                "show": 7,
                "submenu": null
            },
            {
                "id": "ntp",
                "show": 0,
                "submenu": null
            },
            {
                "id": "loopdetect",
                "show": 0,
                "submenu": null
            },
            {
                "id": "sys",
                "show": 0,
                "submenu": null
            }
        ]
    },

    // MainMenu[7]
    {
        "id": "m1_support",
        "show": 0,
        "submenu": [
            {
                "id": "tr069",
                "show": 7,
                "submenu": null
            },
            {
                "id": "iptvmulticast",
                "show": 7,
                "submenu": null
            }
         ]
    }
];
