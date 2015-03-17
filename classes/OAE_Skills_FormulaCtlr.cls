public with sharing class OAE_Skills_FormulaCtlr {
    public String inputVals {get;set;}		//values input by the user in the VF page
    private String thisBase;				//base object (eg Case) passed in the URL
    private String objType;					//the name of the object passed in the URL
    public String thisPath {get;set;}		//path to the field, sent in the URL
    private String thisLabel;				//label of field, sent in the URL
	private String parentObjectType;
	private String fieldName;
			
    public OAE_Skills_FormulaCtlr() {
        inputVals = '';
        thisBase = ApexPages.currentPage().getParameters().get('oBase');
        thisPath = ApexPages.currentPage().getParameters().get('oPath');
        thisLabel = ApexPages.currentPage().getParameters().get('oLabel');
        objType = ApexPages.currentPage().getParameters().get('oObject');
        parentObjectType = ApexPages.currentPage().getParameters().get('oParent');

		//determine field name
		if (thisPath.contains('.')) {
			String[] breakup = thisPath.split('\\x2E',0);  //splitting on period, hex 2E ("." is special)
			fieldName = breakup[breakup.size()-1];
		} else
			fieldName = thisPath;
    }

	public PageReference doRedirect() {
		//check if this field has been already identified for another purpose		
		EnginePicklists__c matchingEP;
		for (EnginePicklists__c ep : EnginePicklists__c.getAll().values()) {
			if (ep.ObjectName__c != null && ep.field__c != null && 
					ep.ObjectName__c.equalsIgnoreCase(parentObjectType) && ep.field__c.equalsIgnoreCase(fieldName)) {
				matchingEP = ep;
			}
		}
		//if so, we're done!
		if (matchingEp != null) {
			//do the save
			saveFieldAndPickLists(matchingEP.PickValues1__c, matchingEP.PickValues2__c);
			PageReference curr = new PageReference('/apex/OAE_Skills_Object');
			curr.setRedirect(true);
			return curr;
		} else 
			return null;
	}

    public PageReference setVals() {
        List<String> valSplit = inputVals.split('\r\n',0);
        String scDelim = '';
        for (String s : valSplit) 
            scDelim = scDelim + s + ';';

        if (scDelim.length() > 0)
            scDelim = scDelim.substring(0,scDelim.length()-1);
		
        if (scDelim.length() < 255)
			saveFieldAndPicklists(scDelim,'');
        else 
            saveFieldAndPicklists(scDelim.substring(0,255),scDelim.substring(255,Math.min(510,scDelim.length())));
            
        PageReference curr = new PageReference('/apex/OAE_Skills_Object');
        curr.setRedirect(true);
        return curr;
    }
    
    private void saveFieldAndPicklists(String pick1, String pick2) {
		Long nextNum = OAE_VFUtils.addFieldToUserSetting(thisLabel,objType,thisPath,'Custom',thisBase);

		OAE_VFUtils.addCustomRulePicklist('M'+objType+nextNum, parentObjectType, fieldName, pick1, pick2);		
/*
		//get the roster for this object
		InUseRoster__c thisRoster = InUseRoster__c.getInstance('M'+objType);
		//find the next available number
		Long nextNum = OAE_VFUtils.nextHole(thisRoster);

		EnginePicklists__c epk = new EnginePicklists__c();
		epk.Name = 'M' + objType + nextNum;
		epk.ObjectName__c = parentObjectType;
		epk.field__c = fieldName;
		
		epk.PickValues1__c = pick1;
		epk.PickValues2__c = pick2;
		
		insert epk;
*/
    }
}