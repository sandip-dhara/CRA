/*global console, setTimeout, document, global, alert, HP, window */
var HP = HP || {};
HP.console.log('=> search-app.js', "important");
HP.state = {};
HP.state.now = {};
HP.state.save = function () {
	'use strict';
	HP.console.log("=> HP.state.save");
	var i, c, e, state;
	state = {};
	for (i = 0; i < HP.conditions.length; i = i + 1) {
		c = HP.conditions[i];
		e = HP.$("input_for_" + c.name);
		//if (e && e.value !== "" && c.validate(e.value).is_valid) {
		if (e) {
			state[c.name] = e.value;
		}
	}
	HP.state.now = state;
	HP.console.log(state);
	HP.Storage.insert("current_state", JSON.stringify(state));
};

HP.state.read = function () {
	'use strict';
	HP.console.log("HP.state.read");
	var string_state = HP.Storage.read("current_state");
	if (string_state) {
		HP.state.now = JSON.parse(string_state);
	} else {
		HP.state.now = {};
	}
};

HP.clearForm = function () {
	'use strict';
	HP.console.log("=> clearForm");
	var i, c, e;
	for (i = 0; i < HP.conditions.length; i = i + 1) {
		c = HP.conditions[i];
		//HP.Storage.delete2(c.name);
		e = HP.$("input_for_" + c.name);
		if (e && e.value !== "") {
			e.value = "";
		}
	}
	HP.runSearch();
};

HP.deleteChild = function (node) {
	'use strict';
	HP.console.log("=> fade");
	var level = 1, step;
	step = function () {
		var sForm, hex = level.toString(16);
		node.style.backgroundColor = "#FFFF" + hex + hex;
		if (level < 15) {
			level += 1;
			setTimeout(step, 10);
		} else {
			HP.console.log("deleting");
			sForm = HP.$("sForm");
			sForm.removeChild(node);
			HP.runSearch();
			HP.state.save();
		}
	};
	setTimeout(step, 100);
};

HP.runSearch = function () {
	'use strict';
	HP.console.log("=> runSearch");
	var i, c, e, query, queryHidden;
	query = "";
	for (i = 0; i < HP.conditions.length; i = i + 1) {
		c = HP.conditions[i];
		e = HP.$("input_for_" + c.name);
		if (e && e.value !== "" && c.validate(e.value).is_valid) {
			query = (query === "") ? query : query + " AND ";
			if(c.name=='name2'){
			query = query + "(+ organizationExtendedName:(" + e.value + "\) OR organizationNonLatinExtendedName:(" + e.value + ") OR organizationReportingName:(" + e.value + ") OR organizationLegalName:(" + e.value + ") OR tradeStyleName:(" + e.value + "))";
			}else if(c.name=='city'){
			query = query + "(+ latinCity:(" + e.value + "\) OR cityRegion:(+ " + e.value + "))" ;
			}else{
			query = query + c.mdcp + ":\(+" + e.value + "\)";			
			}
		}
		// inefficient
		//if (!e) {HP.Storage.delete2(c.name); }
	}
	if (HP.isLatinName() !== true) { // nonLatin
		query = query.replace("organizationExtendedName", "organizationNonLatinExtendedName");
	}
	var count = query.match(/&/g);  
	if(count!=null)
	{
	for(var i=0;i<count.length;i++)
	{
	query=query.replace("&"," "); 
	}
	}
	HP.console.log("=> query = " + query);
	queryHidden = HP.$(HP.query);
	queryHidden.value = query;
};

HP.isLatinName = function () {
	'use strict';
	var foreignCharacters, rlatins, name;
	HP.console.log("=> isLatinName");
	name = HP.$("input_for_name2");
	if (!name) { return true; }
	foreignCharacters = name.value;
	rlatins = /[^\u0000-\u007f]/;
	if (rlatins.test(foreignCharacters)) {
		return false;
	}
	return true;
};

HP.findCondition = function (name) {
	'use strict';
	var c, i;
	for (i = 0; i < HP.conditions.length; i = i + 1) {
		c = HP.conditions[i];
		if (c.name === name) {
			return c;
		}
	}
};

HP.init = function () {
	'use strict';
	var plus, search, clear, total, val, key;
	HP.console.log("=> init");
// try to display same set of condition
	total = 0;
	HP.state.read();
	for (key in HP.state.now) {
		total = total + 1;
		val = HP.state.now[key];
		HP.createCondition(key);
	}
	if (total === 0) {
		HP.createCondition("name2");
		//HP.createCondition("city");
		HP.createCondition("country");
	}
	plus = HP.$("plus");
	HP.bindEvent(plus, "click", HP.createCondition);
	HP.bindEvent(plus, "tap", HP.createCondition);
	//bind search button
	search = HP.$(HP.prefix + "search");
	//HP.bindEvent(search, "click", HP.runSearch);
	//HP.bindEvent(search, "tap", HP.runSearch);
	HP.bindEvent(search, "click", HP.validate.all);
	HP.bindEvent(search, "tap", HP.validate.all);
	//bind search button
	clear = HP.$(HP.prefix + "clearForm");
	HP.bindEvent(clear, "click", HP.clearForm);
	//HP.bindEvent(clear, "tap", HP.clearForm);
	HP.reinit();
	HP.runSearch();
};

HP.ready = function () {
	'use strict';
	HP.console.log("=> window ready");
	HP.init();
};
HP.bindEvent(window, "load", HP.ready);

//eventHandlers
HP.conditionSelected = function (select) {
	'use strict';
	HP.console.log("=> conditionSelected");
	var plus, input, test, message;
	plus = HP.$("plus");
	input = select.nextSibling;
	//avoid duplicate
	test = HP.$("input_for_" + select.value);
	if (test) {
		HP.console.log("=> Duplicate");
		alert("You could not specify the same field for searching more than once.");
		select.value = "undefined";
	}
	if (select.value !== 'undefined') {
		input.disabled = false;
		plus.disabled = false;
		input.placeholder = HP.findCondition(select.value).placeholder;
		input.id = "input_for_" + select.value;
		input.setAttribute("name", select.value);
	} else {
		input.disabled = true;
	}
	message = input.nextSibling;
	message.id = "message_for_" + select.value;
	HP.runSearch();
	HP.state.save();
};

HP.reinit = function () {
	'use strict';
	HP.console.log("=> HP.reinit");
	var e, key;
	for (key in HP.state.now) {
		e = HP.$("input_for_" + key);
		e = HP.$("input_for_" + key);
		HP.console.log(e);
		if (e) { e.value = HP.state.now[key]; }
	}
};

HP.createCondition = function (select_value) {
	'use strict';
	HP.console.log("=> createCondition");
	var sForm, li, select, i, c, option, input, minus, message, selected;
	sForm = HP.$("sForm");
	li = document.createElement("li");
	//create minus button
	minus = document.createElement('input');
	minus.setAttribute('type', 'button');
	minus.setAttribute('class', 'minus');
	minus.setAttribute('value', 'Del');
	HP.bindEvent(minus, "click", HP.deleteChild.curry(li));
	HP.bindEvent(minus, "tap", HP.deleteChild.curry(li));
	li.appendChild(minus);
	//create drop down 
	select = document.createElement("select");
	select.setAttribute('class', 'search_select');
	for (i = 0; i < HP.conditions.length; i = i + 1) {
		c = HP.conditions[i];
		option = document.createElement("option");
		option.appendChild(document.createTextNode(c.label)); //option label
		option.value = c.name; // option value
		select.appendChild(option);
	}
	li.appendChild(select);
	//event binding
	HP.bindEvent(select, "change", HP.conditionSelected.curry(select));
	//create text box
	input = document.createElement('input');
	input.setAttribute('type', 'input');
	input.setAttribute('size', '35');
	input.setAttribute('class', 'search_input');

	input.disabled = true;
	HP.bindEvent(input, "change", HP.inputChanged.curry(input));
	HP.bindEvent(input, "keyup", HP.inputChanged.curry(input));
	li.appendChild(input);
	//create message text
	message = document.createElement("span");
	message.innerHTML = "";
	message.setAttribute("class", "error_message");
	li.appendChild(message);	
	// have default value
	selected = HP.findCondition(select_value);
	if (selected && typeof select_value === 'string') {
		select.value = selected.name;
		input.placeholder = selected.placeholder;
		input.disabled = false;
		input.setAttribute("name", selected.name);
		input.id = "input_for_" + selected.name;
		message.id = "message_for_" + selected.name; 	     		       
	}              
	sForm.appendChild(li);
};
HP.inputChanged = function (input) {
	'use strict';
	HP.inputKeyup(input);
	HP.state.save();
};
HP.inputKeyup = function (input) {
	'use strict';
	HP.console.log("=> inputChanged");
	var c, message;
	c = HP.findCondition(input.name);
	if(typeof c.validate === "function") {var r = c.validate(input.value);}
	message = HP.$("message_for_" + input.name);
	if (r.is_valid === false) {
		message.innerHTML = r.message;	              
	} else {
		message.innerHTML = "";
	}
	HP.runSearch();
	//HP.state.save();
};