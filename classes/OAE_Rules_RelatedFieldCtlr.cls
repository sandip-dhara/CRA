public with sharing class OAE_Rules_RelatedFieldCtlr {
    public String objType {get;set;}
    public String objForward {get;set;}
    public String IDLabel {get;set;}
    public String fieldType {get;set;}
    public String priorPath {get;set;}
    public String fullPath {get;set;}
    public String addThisField { get; set; }
    public String objectForward { get; set; }
    public List<TableCols> unusedParams { get;set;}
    public List<TableCols> childObjs { get; set;}
    private Map<String, Schema.SObjectField> objSchema;
    
    public OAE_Rules_RelatedFieldCtlr() {
        objType = ApexPages.currentPage().getParameters().get('oType');
        objForward = ApexPages.currentPage().getParameters().get('oName');
        fullPath = ApexPages.currentPage().getParameters().get('oFull');
        priorPath = ApexPages.currentPage().getParameters().get('oPath');
        IDLabel = ApexPages.currentPage().getParameters().get('oLabel');

        if (objForward != null && priorPath != null) {
            //initialize
            unusedParams = new List<TableCols>();
            childObjs = new List<TableCols>();
    
            objSchema = Schema.getGlobalDescribe().get(objForward).getDescribe().fields.getMap();
    
            Map<String,String> dupes = new Map<String,String>();
    
            //get current from custom settings
            for (EngineFields__c ef : EngineFields__c.getAll().values()) {
                dupes.put(ef.Path__c,'');
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
                        TableCols tc = new TableCols(sdr.getLabel(), sdr.getReferenceTo()[0].getDescribe().getName(), sdr.getRelationshipName());
                        childObjs.add(tc);
                    }
                } else if (!dupes.containskey(priorPath + '.' + thisName)) {

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
            
        } else {
            //error!
        }
    }
    public PageReference objAssign() {
        OAE_VFUtils.addFieldToCustomSetting(IDLabel,objType,fullPath,'ID');

        PageReference curr = new PageReference('/apex/OAE_Rules_FieldAdd');
        curr.setRedirect(true);
        return curr;
    }

    public PageReference objLoop() {
        PageReference curr = new PageReference('/apex/OAE_Rules_RelatedField?oType='+objType+'&oName='+objectForward+'&oPath='
                +priorPath+'.'+addThisField+'&oFull='+fullPath+'.'+addThisField+'&oLabel='+fullPath+'.'+fieldType);
        curr.setRedirect(true);
        return curr;
    }

    public PageReference fieldAdd() {
        PageReference curr;
        if (fieldType.equalsignorecase('Formula')) {
            String paramString = OAE_VFUtils.customParamString(objSchema.get(addThisField),objType,priorPath+'.',objForward);
            curr = new PageReference('/apex/OAE_Rules_CustomList?'+paramString);
        } else {
            OAE_VFUtils.addFieldToCustomSetting(objSchema.get(addThisField),objType,priorPath+'.',fieldType);
            curr = new PageReference('/apex/OAE_Rules_FieldAdd?oObject='+objType);
        }
        curr.setRedirect(true);
        return curr;
    }
}