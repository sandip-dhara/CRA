/*global console, setTimeout, document, global, alert */
/*
	This script shall be included AFTER search-common.js
*/
//use HP namespace
var HP = HP || {};
HP.console.log("=> search-validation.js");
//validate function
HP.validate = {};
HP.validate.length = function (length, input) {
	'use strict';
	HP.console.log("=> HP.validate.length");
	var result = {};
	if (input.length >= length) {
		result = {is_valid: true, message: ""};
		HP.console.log("valid");
	} else {
		HP.console.log("invalid");
		result.is_valid = false;
		result.message = "Enter minimum " + length + " characters";
	}
	return result;
};
HP.validate.boolen = function (input) {
	'use strict';
	HP.console.log("=> HP.validate.boolen");	
	var result = {};
	if (String(input)=='y'||String(input)=='n'||String(input)=='Y'||String(input)=='N') {
		result = {is_valid: true, message: ""};
		HP.console.log("valid");
	} else {
		HP.console.log("invalid");
		result.is_valid = false;
		result.message = "Please Enter y or n";
	}
	return result;
};

HP.validate.numeric = function (input) {
	'use strict';
	HP.console.log("=> HP.validate.numeric");
	HP.console.log(input);
	var result = {}, isWhole_re       = /^[0-9]*$/;
	if (String(input).search(isWhole_re) !== -1) {
		result.is_valid = true;
		result.message = "";
		HP.console.log("valid");
	} else {
		HP.console.log("invalid");
		result.is_valid = false;
		result.message = "Enter number only";
	}
	return result;
};

HP.validate.all = function () {
	'use strict';
	HP.console.log("=> validate.all");
	var i, c, e, valid, required_f_present;
	valid = true;
	required_f_present = false;
	for (i = 0; i < HP.conditions.length; i = i + 1) {
		c = HP.conditions[i];
		e = HP.$("input_for_" + c.name);
		if (e && e.value !== "" && !c.validate(e.value).is_valid) {
			valid = false;
			// check if at least one required fields are present
		} 
		HP.console.log("*****************************");
		if (!required_f_present && e && e.value !== "" && c.validate(e.value).is_valid && HP.required.indexOf(c.name) > -1) {			  HP.console.log("========================");
			required_f_present = true;
		}
	}
	HP.state.save();
	HP.console.log(valid);
	HP.required = ["name2", "tax", "mdcp_id", "duns"];

	if(required_f_present) {
		HP.$(HP.alert).innerHTML = "";
	} else {
		HP.$(HP.alert).innerHTML = "At least either one of Name, Tax, MDCP Id, or DUNS must be specified"
	};
	
	//force to unsubmitted , used for debugging
	if(HP.stop) { valid = false; }
	
	return valid && required_f_present;
};