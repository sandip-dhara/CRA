public with sharing class OAE_Rules_FieldAddCtlr {

    public final String objType { get; set; }
    public final String objLabel { get; set; }
    public String addThisField { get; set; }
    public String fieldType { get; set; }
    public String objectForward { get; set; }

    private Map<Decimal,TableCols> inUseParamMap { get; set;}
    public List<TableCols> unusedParams { get;set;}
    public List<TableCols> childObjs { get; set;}
    private Map<String,EngineFields__c> fNames;
    private Map<String, Schema.SObjectField> objSchema;
    
    public OAE_Rules_FieldAddCtlr() {
        //initialize
        objType = ApexPages.currentPage().getParameters().get('oObject');
		objLabel = Schema.getGlobalDescribe().get(objType).getDescribe().getLabel();

        inUseParamMap = new Map<Decimal,TableCols>();
        unusedParams = new List<TableCols>();
        childObjs = new List<TableCols>();

        objSchema = Schema.getGlobalDescribe().get(objType).getDescribe().fields.getMap();

        Map<String,String> dupes = new Map<String,String>();
        String efType;
        
        //get current from custom settings
        fNames = EngineFields__c.getAll();
        for (EngineFields__c ef : fNames.values()) {
        	if (ef.object__c.equalsIgnoreCase(objType)) {
	            efType = ef.Type__c;
	            TableCols tc;
	            if (efType.equalsignorecase('PICKLIST')) {
	                tc = new TableCols(ef.Label__c, ef.Type__c, ef.Path__c, OAE_VFUtils.getPickVals(objSchema,ef.Path__c), ef.Name);
	            } else if (efType.equalsignorecase('CHECKBOX')) {
	                tc = new TableCols(ef.Label__c, ef.Type__c, ef.Path__c, 'True, False',ef.Name);
	            } else {
	                tc = new TableCols(ef.Label__c, ef.Type__c, ef.Path__c, OAE_VFUtils.getCustomVals('R'+ef.Name),ef.Name);
	            }
	            inUseParamMap.put(ef.order__c,tc);
	            dupes.put(ef.Path__c,'');
        	}
        }
        //get other options from schema
        String thisType;
        String thisName;
                
        for (Schema.SObjectField s : objSchema.values()) {
            Schema.DescribeFieldResult sdr = s.getDescribe(); 
            thisType = sdr.getType().name();
            thisName = sdr.getName();

            if (thisType.equalsIgnoreCase('REFERENCE')) {
                if ( sdr.getRelationshipName() != null &&  sdr.getRelationshipName() != '') {
                    TableCols tc = new TableCols(sdr.getLabel(), sdr.getReferenceTo()[0].getDescribe().getName(), 
                        sdr.getRelationshipName(),sdr.getName());
                    childObjs.add(tc);
                }
            } else if (!dupes.containskey(thisName)) {
                if (s.getDescribe().isCalculated()) { 
                    TableCols tc = new TableCols(sdr.getLabel(), 'Formula', thisName);
                    unusedParams.add(tc);
                } else if (thisType.equalsIgnoreCase('PICKLIST')) {
                    TableCols tc = new TableCols(sdr.getLabel(), 'Picklist', thisName);
                    unusedParams.add(tc);
                } else if (thisType.equalsIgnoreCase('BOOLEAN')) {
                    TableCols tc = new TableCols(sdr.getLabel(), 'Checkbox', thisName);
                    unusedParams.add(tc);
                }
            }
        }
    	unusedParams = OAE_VFUtils.sortTC(unusedParams);
    	childObjs = OAE_VFUtils.sortTC(childObjs);
    }
    
    public PageReference objLoop() {
        PageReference curr = new PageReference('/apex/OAE_Rules_RelatedField?oType='+objType+'&oName='
                +objectForward+'&oFull='+addThisField+'&oPath='+addThisField+'&oLabel='+fieldType);
        curr.setRedirect(true);
        return curr;
    }

    public PageReference fieldAdd() {
        PageReference curr;
        if (fieldType.equalsignorecase('Formula')) {
            String paramString = OAE_VFUtils.customParamString(objSchema.get(addThisField),objType,'',objType);
            curr = new PageReference('/apex/OAE_Rules_CustomList?'+paramString);
        } else {
            OAE_VFUtils.addFieldToCustomSetting(objSchema.get(addThisField),objType,'',fieldType);
            curr = new PageReference('/apex/OAE_Rules_FieldAdd?oObject='+objType);
        }
        curr.setRedirect(true);
        return curr;
    }

    public PageReference fieldDelete() {
		EngineFields__c ef = fNames.get(addThisField);
		OAE_VFUtils.removeFieldFromCustomSetting(ef);
		PageReference curr = new PageReference('/apex/OAE_Rules_FieldAdd?oObject='+objType);		
        curr.setRedirect(true);
        return curr;
    }

    public List<TableCols> getFieldGrid() { 
        List<TableCols> retVal = new List<TableCols>();
        
        //get the keys into a list for sorting
        List<Decimal> sortkeys = new List<Decimal>();
        sortkeys.addAll(inUseParamMap.keySet());
        sortkeys.sort();
    
        for (Decimal dc : sortkeys) 
            retVal.add(inUseParamMap.get(dc));

        return retVal;
    }
}