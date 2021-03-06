/* jshint browser:true */
/* global $ */

var ref;
var cordovaWin;

function listenPostMessage() {
	$(window).on('storage', function() {
		if (localStorage.hasOwnProperty('postedMessage')) {
			var postedMessage = JSON.parse(localStorage.postedMessage);
			delete localStorage.postedMessage;
			$.event.trigger({
				type: "message",
				originalEvent: {
					data: postedMessage,
					origin: window.location.protocol + "//" + window.location.host
				}
			});
			ref.close();
		}
	});
}

function openWindow(url, name, specs, replace) {
	name = name || "_blank";
	specs = specs || "location=no";
	ref = cordovaWin(url, name, specs, replace);
}

if (window.phonegap || window.cordova) {
	listenPostMessage();

	document.addEventListener('deviceready', function() {
		cordovaWin = window.open;

		setTimeout(function() {
			window.open = openWindow;
		}, 100);
	}, false);
}
