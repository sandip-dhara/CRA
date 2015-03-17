public with sharing class OAE_Skills_LevelCtlr {

    public String inputVals {get;set;}		//values input by the user in the VF page
    private String thisBase;				//name of UMF this list is for
    public String strToRemove {get;set;}	//a value asked to be removed
	private EnginePicklists__c existingEP;	
	public Set<String> existingList {get;set;}
	public Boolean showExisting {get;set;}
			
    public OAE_Skills_LevelCtlr() {
        inputVals = '';
        thisBase = ApexPages.currentPage().getParameters().get('oName');
		existingList = new Set<String>();
		existingEP = EnginePicklists__c.getInstance('L'+thisBase);

		if (existingEP != null) {
            String pv = existingEP.PickValues1__c;
            if (existingEP.PickValues2__c != null)
                pv = pv + existingEP.PickValues2__c;
			List<String> strings = pv.split(';',0);
			for (String s : strings)
				existingList.add(s);
			showExisting = true;
        } else
        	showExisting = false;
    }

    public PageReference setVals() {
		if (existingEP == null) {
	        EnginePicklists__c epk = new EnginePicklists__c();
	        epk.Name = 'L' + thisBase;
        	epk = fixFields(epk,true);	
	        insert epk;
		} else {
			existingEP = fixFields(existingEP,true);
			update existingEP;
		}

        PageReference curr = new PageReference('/apex/OAE_Skills_Object');
        curr.setRedirect(true);
        return curr;
    }

    public PageReference fieldRemove() {
		existingList.remove(strToRemove);

		existingEP = fixFields(existingEP,false);
		
		update existingEP;

    	return null;
    }

	private EnginePicklists__c fixFields(EnginePicklists__c currentEP, Boolean adding) {
        String scDelim = '';

		//grab from the existing strings
        for (String s : existingList) 
            scDelim = scDelim + s + ';';

		//if strings are being added, pull from the input field
		if (adding) {
	        List<String> valSplit = inputVals.split('\r\n',0);
	        for (String s : valSplit) 
	            scDelim = scDelim + s + ';';
		}
				
		//truncate last semicolon
        if (scDelim.length() > 0)
            scDelim = scDelim.substring(0,scDelim.length()-1);		

		String pick1;
		String pick2;		
        if (scDelim.length() < 255) {
        	pick1 = scDelim;
        	pick2 = '';
        } else {
        	pick1 = scDelim.substring(0,255);
        	pick2 = scDelim.substring(255,Math.min(510,scDelim.length()));
        }

		currentEP.PickValues1__c = pick1;
		currentEP.PickValues2__c = pick2;
		
		return currentEP;
	}
}