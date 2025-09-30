

function WebCreatMenu()
{
	var main_menu = $("#main_menu");
	var TotalMenuNumber = 0;
	var CurMenuNumber = 0;
	
	$.each(window.top.MainMenu, function(mi, mv) {
	    if (window.top.XHas80211acWifi && (mv.id.match("wifi5") != null) && (1 != window.top.XCurrentUser)) {
	        mv.show = 7;
		}

		// disable the menu if slot do not defined
	    if ((0 == window.top.num_5g_wifi) && (0 == window.top.num_wifi) && 
			(mv.id.match("m1_wireless") != null)) {
	        mv.show = 0;
        }
	   //disable the menu of voip when the number of POTS is 0. 
	    if ((0 == window.top.WebPotsNumber) && (mv.id.match("m1_voip") != null)) {
	        mv.show = 0;
        }
	    
		if (mv.show > 0) {
			TotalMenuNumber++;
		}
		if ((mv.show & window.top.XCurrentUser) != 0) {
			var page = mv.submenu[0].id;
			var cls = "";
			CurMenuNumber++;
			if (mv.submenu[0].submenu)
			{
				page = mv.submenu[0].submenu[0].id;
			}
			if (mi == window.top.CurMainMenu)
			{
				cls = "selected";
			}
			var title = eval('MenuString.' + mv.id);
			main_menu.append("<li id='mm" + mi + "' class=" + mv.id + "><a href='" + page + ".html' class='" + cls +"'><span>" + title + "</span></a></li>");
		}
	});

	var MenuAWidth = parseInt($("#mm0 a").css("width"));
	var MenuWidth = MenuAWidth * CurMenuNumber;
	var MenuPadding = parseInt(main_menu.css("padding-left")) + (MenuAWidth/2) * (TotalMenuNumber - CurMenuNumber);
	main_menu.css("width", MenuWidth);
	main_menu.css("padding-left", MenuPadding);
	main_menu.css("padding-right", MenuPadding);

	main_menu.children("li").click(function(e) {
		var id = e.currentTarget.id;
		var idx = parseInt(id.substring(2, id.length));
		window.top.CurMainMenu = idx;
		var mv = window.top.MainMenu[idx];
		if (mv.submenu) {
			if (!mv.submenu[0].submenu) {
				window.top.CurSubMenu = mv.submenu[0].id;
			} else {
				window.top.CurSubMenu = mv.submenu[0].submenu[0].id;
			}
		}
	});

	WebCreatSubMenu();
}
	
function WebCreatSubMenu()
{
	var sub_menu = $("#sub_menu");
	var cm = window.top.MainMenu[window.top.CurMainMenu];
	$.each(cm.submenu, function(si, sv) {
		//alert(si+","+sv.id);
	    if (window.top.XHas80211acWifi && (sv.id.match("wifi5") != null) && (1 != window.top.XCurrentUser)) {
	        sv.show = 7;
		}

		// disable the menu if slot do not defined
		if ((sv.id.match("wifi5") != null) && (0 == window.top.num_5g_wifi)) {
			sv.show = 0;
		}

		if ((sv.id.match("wifi") != null) && (0 == window.top.num_wifi)) {
			sv.show = 0;
		}

		if ((sv.id.match("wifi5info") != null) && (0 == window.top.num_5g_wifi)) {
			sv.show = 0;
		}

		if ((sv.id.match("wifiinfo") != null) && (0 == window.top.num_wifi)) {
			sv.show = 0;
		}

		if ((sv.id.match("usb") != null) && (0 == window.top.num_usb)) {
			sv.show = 0;
		}
         
 		if ((sv.show & window.top.XCurrentUser) != 0) {
			var page = sv.id;
			var cls = "";
			if (sv.submenu)
			{
				page = sv.submenu[0].id;
			}
			if (page == window.top.CurSubMenu)
			{
				cls = "selected";
			}
			
			var title = eval('MenuString.' + sv.id);
			sub_menu.append("<li id='" + sv.id + "'><a href='" + page + ".html' class='" + cls +"'>" + title + "</a></li>");
			if (sv.submenu)
			{
				$("#"+sv.id).append("<ul></ul>");
				$.each(sv.submenu, function(ssi, ssv) {
					cls = "";
					if (ssv.id == window.top.CurSubMenu)
					{
						cls = "selected";
						$("#"+sv.id+" a:first").addClass("selected");

					}
            	    if (window.top.XHas80211acWifi && (ssv.id.match("wifi5") != null) && (1 != window.top.XCurrentUser)) {
            	        ssv.show = 7;
                    }
					if ((ssv.id.match("usbstr") != null) && (0 == window.top.num_usb)) {
						ssv.show = 0;
					}

					if ((ssv.id.match("usbprinter") != null) && (0 == window.top.num_usb)) {
						ssv.show = 0;
					}

					if ((ssv.id.match("wifiwps") != null) && (0 == window.top.num_5g_wifi)) {
						// do not show WPS for RG3T
						ssv.show = 0;
					}
					if ((ssv.show & window.top.XCurrentUser) != 0) {
						title = eval('MenuString.' + ssv.id);
						$("#"+sv.id+" ul").append("<li id='" + ssv.id + "'><a href='" + ssv.id + ".html' class='" + cls +"'>" + title + "</a></li>");
					}
				});
			}
		}
	});
	
	sub_menu.addClass("sub_menu"); //for ie6,ie7
	sub_menu.children("li:last-child").addClass("last_li");

	sub_menu.find("a").click(function(e) {
		window.top.CurSubMenu = e.currentTarget.href.replace(/(.*\/){0,}([^.]+).*/ig, "$2");
	});

	var content_title = $("#content_title")
	var title = eval('MenuString.' + window.top.CurSubMenu);
	var desc = eval('DescString.' + window.top.CurSubMenu);
	content_title.html(title);
	if (desc.length > 0)
	{//for ie
		content_title.append(" <span>" + desc + "</span>");
	}
}

