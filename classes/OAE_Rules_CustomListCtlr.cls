public with sharing class OAE_Rules_CustomListCtlr {
	public String inputVals {get;set;}
	public String objType {get;set;}
	public String thisPath {get;set;}
	public String thisLabel {get;set;}
	private String objForward;

	public OAE_Rules_CustomListCtlr() {
		inputVals = '';
		objForward = ApexPages.currentPage().getParameters().get('oParent');
		thisPath = ApexPages.currentPage().getParameters().get('oPath');
		thisLabel = ApexPages.currentPage().getParameters().get('oLabel');
		objType = ApexPages.currentPage().getParameters().get('oObject');
	}
    
	public PageReference setVals() {
		List<String> valSplit = inputVals.split('\r\n',0);
		String scDelim = '';
		for (String s : valSplit) 
			scDelim = scDelim + s + ';';
        
		if (scDelim.length() > 0)
			scDelim = scDelim.substring(0,scDelim.length()-1);

		Long nextNum = OAE_VFUtils.addFieldToCustomSetting(thisLabel,objType,thisPath,'Custom');

		//add the picklist values to the custom setting
		OAE_VFUtils.addCustomRulePicklist('R'+objType+nextNum, objForward, thisPath, scDelim);
/*
        EnginePicklists__c epk = new EnginePicklists__c();
        epk.Name = 'R' + objType + nextNum;
		epk.ObjectName__c = objForward;
		
		//determine field name
		if (thisPath.contains('.')) {
			String[] breakup = thisPath.split('\\x2E',0);  //splitting on period, hex 2E ("." is special)
			epk.field__c = breakup[breakup.size()-1];
		} else
			epk.field__c = thisPath;
		
        if (scDelim.length() < 255)
            epk.PickValues1__c = scDelim;
        else {
            epk.PickValues1__c = scDelim.substring(0,255);
            epk.PickValues2__c = scDelim.substring(255,Math.min(510,scDelim.length()));
        }
        insert epk;
*/
		PageReference curr = new PageReference('/apex/OAE_Rules_FieldAdd?oObject='+objType);
		curr.setRedirect(true);
		return curr;
	}
}