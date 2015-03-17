/*global console, setTimeout, document, global, alert, Storage, localStorage*/

var HP = HP || {};
HP.console = HP.console || {};
HP.console.log = function (msg, status) {
	'use strict';
	if (typeof HP.debug !== 'undefined' && HP.debug === false && (typeof status === "undefined" || status !== "important")) {return; }
	if (typeof (console) !== 'undefined') {
		console.log(msg);
	}
};
HP.console.log("=> search-common.js");
HP.bindEvent = function (element, type, handler) {
	'use strict';
	if (element.addEventListener) {
		element.addEventListener(type, handler, false);
	} else {
		element.attachEvent('on' + type, handler);
	}
};
HP.$ = function (id) {
	'use strict';
	var el;
	HP.console.log("=> HP.$ id =" + id);
	el = document.getElementById(id);
	if (el) {
		return document.getElementById(id);
	}
};

HP.Cookie = {}
HP.Cookie.set = function(c_name,c_value,c_expiredays) {
	HP.console.log("=> HP.Cookie.set")
    var exdate=new Date();
    exdate.setDate(exdate.getDate()+c_expiredays);
    document.cookie=c_name+ "=" +escape(c_value) + ((c_expiredays==null) ? "" : ";expires="+exdate.toGMTString());
}

HP.Cookie.get = function (c_name) {
	var i,x,y,ARRcookies=document.cookie.split(";");
	for (i=0;i<ARRcookies.length;i++) {
		x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
		y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
		x=x.replace(/^\s+|\s+$/g,"");
		if (x==c_name) {
			return unescape(y);
		}
	}
}

HP.Storage = {};
HP.Storage.insert = function (name, value) {
	'use strict';
	var result = true;
	HP.console.log("=> insert");
	if (typeof Storage !== "undefined") {
		localStorage[name] = value;
	} else {
		HP.console.log("Browser does not support storage");
		HP.Cookie.set(name, value, 7);
		result = false;
	}
	return result;
};

HP.Storage.read = function (name) {
	'use strict';
	HP.console.log("=> read");
	var result;
	if (typeof Storage !== "undefined") {
		result = localStorage[name];
    } else {
		HP.console.log("Browser does not support storage");
		result = HP.Cookie.get(name)
	}
	return result;
};

HP.Storage.delete2 = function (name) {
	'use strict';
	var result;
	if (typeof Storage !== "undefined") {
		//delete localStorage[name];
		localStorage.removeItem(name);
		result = true;
	} else {
		HP.console.log("Browser does not support storage");
    }
	return result;
};
//enhance JavaScript function
Function.prototype.method = function (name, func) {
	'use strict';
	if (!this.prototype[name]) {
		this.prototype[name] = func;
		return this;
	}
};
Function.method('curry', function () {
	'use strict';
	var slice = Array.prototype.slice, args = slice.apply(arguments), that = this;
	return function () {
		return that.apply(null, args.concat(slice.apply(arguments)));
	};
});

if(!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(needle) {
        for(var i = 0; i < this.length; i++) {
            if(this[i] === needle) {
                return i;
            }
        }
        return -1;
    };
}