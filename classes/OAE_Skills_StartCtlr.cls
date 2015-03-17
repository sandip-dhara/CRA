public with sharing class OAE_Skills_StartCtlr {
    public final String targetObjectType { get; set; }

	public Set<String> objTypesInUse;

	public List<TableCols> objParams {get;set;}
    private Map<Decimal,UserMatchFields__c> custParams;
    private Map<Decimal,UserMatchFields__c> skedParams;
    private Map<Decimal,UserMatchFields__c> userParams;

	public Boolean showObj {get;set;}
	public Boolean showCust {get;set;}
	public Boolean showSked {get;set;}
	public Boolean showUser {get;set;}

    private Map<String, Schema.SObjectField> targetObjSchema;
    private Map<String, Map<String, Schema.SObjectField>> sourceObjSchemas;

	public OAE_Skills_StartCtlr() {
        //initialize
		targetObjectType = 'User';

        List<UserMatchFields__c> objParamsList = new List<UserMatchFields__c>();
        custParams = new Map<Decimal,UserMatchFields__c>();
        skedParams = new Map<Decimal,UserMatchFields__c>();
        userParams = new Map<Decimal,UserMatchFields__c>();

        //get current from custom settings
        String uBase;
        Map<String,UserMatchFields__c> umfNames = UserMatchFields__c.getAll();
        for (UserMatchFields__c umf : umfNames.values()) {
            uBase = umf.Base__c;
            if (uBase.equalsignorecase('SCHEDULE')) {
				skedParams.put(umf.order__c, umf);
            } else if (uBase.equalsignorecase('USERDATA__C')) {
				userParams.put(umf.order__c, umf);
            } else if (uBase.equalsignorecase('CUSTOM')) {
				custParams.put(umf.order__c, umf);
            } else {
				objParamsList.add(umf);
            }
        }

        targetObjSchema = Schema.getGlobalDescribe().get(targetObjectType).getDescribe().fields.getMap();

		//get schema for source objects
		sourceObjSchemas = new Map<String, Map<String, Schema.SObjectField>>();
		
        for (InUseRoster__c iur : InUseRoster__c.getAll().values()) {
			Schema.Sobjecttype thisSOType = Schema.getGlobalDescribe().get(iur.Name);
            if (thisSOType != null) {
	        	Map<String, Schema.SObjectField> thisSchema = thisSOType.getDescribe().fields.getMap();
				sourceObjSchemas.put(iur.Name.toUpperCase(), thisSchema);
            }
        }

		objParams = getTableCols(OAE_VFUtils.sortUMFList(objParamsList));

		showObj = objParams.size() > 0;
		showCust = custParams.size() > 0;
		showSked = skedParams.size() > 0;
		showUser = userParams.size() > 0;
		
	}

	public PageReference addObj() {
        PageReference curr = new PageReference('/apex/OAE_Skills_Object');
        curr.setRedirect(true);
        return curr;
	}

	public PageReference addCust() {
        PageReference curr = new PageReference('/apex/OAE_Skills_CustomSkill');
        curr.setRedirect(true);
        return curr;
	}

	public PageReference addUser() {
		return null;
	}

	public PageReference addSked() {
		return null;
	}
	
	public List<TableCols> getUserParams() {
		return getTableCols(OAE_VFUtils.sortedMap(userParams));
	}
	
	public List<TableCols> getCustParams() {
		return getTableCols(OAE_VFUtils.sortedMap(custParams));
	}
	
	public List<TableCols> getSkedParams() {
		return getTableCols(OAE_VFUtils.sortedMap(skedParams));
	}

	public List<TableCols> getTableCols(List<UserMatchFields__c> theList) {
		List<TableCols> retVal = new List<TableCols>();

		TableCols tc;
		String ufType;
		String fourth;
		for (UserMatchFields__c uf : theList) {
			ufType = uf.Type__c;
            if (ufType.equalsignorecase('PICKLIST')) {
            	//get picklist values for this field
            	//get the schema for the correct base object
				Map<String, Schema.SObjectField> thisSchema = sourceObjSchemas.get(uf.Base__c.toUpperCase());
				if (thisSchema != null) {
					fourth = OAE_VFUtils.getPickVals(thisSchema, uf.Path__c);
				}
            } else if (ufType.equalsignorecase('CHECKBOX')) {
				fourth = 'true, false';
            } else if (ufType.equalsignorecase('NUMERIC')) {
				fourth = 'n/a';
            } else { //custom
            	if (uf.Base__c == 'Custom')
					fourth = OAE_VFUtils.getCustomVals('M' + uf.Name);
				else
					fourth = OAE_VFUtils.getCustomVals(uf.Name);
            }
			if (uf.Base__c == 'Custom')
	            tc = new TableCols(uf.Name.replaceAll('\\d',''), uf.Label__c, fourth);
	        else
	            tc = new TableCols(uf.Name.replaceAll('\\d',''),uf.Label__c, uf.Type__c, uf.Path__c, fourth);
	        
            retVal.add(tc);
		}
		return retVal;
	}
}