/*global console, setTimeout, document, global, alert, HP */
/*
	This shall be placed after search-common & search-validation
*/
var HP = HP || {};

HP.console.log('=> search-config.js');
HP.prefix = "PageID:FormId:searchsection:";


//HP.prefix = "";
HP.required = ["name2", "tax", "mdcp_id", "duns"];
HP.alert= "PageID:FormId:searchsection:alert";
HP.query = HP.prefix + "query";
HP.debug = false;
HP.conditions = [
	{name: 'undefined', label: '<Choose field>', placeholder: '', mdcp: 'undefined'},
	// {name: 'amid2', label: 'AMID 2', placeholder: 'Specify numeric value', mdcp: 'amid2', validate: HP.validate.numeric},
	{name: 'city', label: 'City', placeholder: 'Specify at least 3 characters', mdcp: 'latinCity', validate: HP.validate.length.curry(3)},
	{name: 'country', label: 'Country', placeholder: 'Specify at least 3 characters', mdcp: 'countryName', validate: HP.validate.length.curry(3)},
	{name: 'duns', label: 'DUNS', placeholder: 'Data Universal Numbering System', mdcp: 'duns', validate: HP.validate.numeric},
	{name: 'mdcp_id', label: 'MDCP Id', placeholder: 'Enter MDCP Organization ID', mdcp: 'organizationId', validate: HP.validate.numeric},
	//dont change name2 to something else
	{name: 'name2', label: 'Name', placeholder: 'Account name (at least 2 characters)', mdcp: 'organizationExtendedName', validate: HP.validate.length.curry(2)},
	//{name: 'region', label: 'Region', placeholder: 'Specify Region (APJ, AMS or EMEA)', mdcp: 'worldRegion', validate: HP.validate.length.curry(2)},
	{name: 'state', label: 'State / Province', placeholder: 'Specify State / Province', mdcp: 'state', validate: HP.validate.length.curry(2)},
	{name: 'postal', label: 'Postal Code', placeholder: 'Specify Postal Code', mdcp: 'postalCode', validate: HP.validate.length.curry(2)},
	{name: 'tax', label: 'Tax ID', placeholder: 'Specify Tax Id', mdcp: 'taxId', validate: HP.validate.length.curry(2)}
];
/* end of configuration stuff*/