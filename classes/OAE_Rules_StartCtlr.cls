public with sharing class OAE_Rules_StartCtlr {
    public List<TableCols> objectsInUse {get;set;}
    private Map<String, Schema.SObjectType> objectsAvailable {get;set;}
    public String objToEdit { get; set; }
    public String objToAdd { get; set; }
    Set<String> foundStrs;
    
    public OAE_Rules_StartCtlr() {
        objectsAvailable = Schema.getGlobalDescribe();

        //get all object strings, place them in a set
        foundStrs = new Set<String>();
        Map<String,EngineFields__c> fNames = EngineFields__c.getAll();
        for (EngineFields__c ef : fNames.values())
            foundStrs.add(ef.Object__c);
        //assign the set to the list for display
        objectsInUse = new List<TableCols>();
        for (String objName : foundStrs) {
            InUseRoster__c thisSetupObject = InUseRoster__c.getInstance(objName);
            if (thisSetupObject != null)
                objectsInUse.add(new TableCols(objName,objectsAvailable.get(objName).getDescribe().getLabel(),thisSetupObject.UD_WorkloadField__c,
                                                                thisSetupObject.TimeField__c,thisSetupObject.WorkloadIncrementField__c,
                                                                thisSetupObject.skedRecTypeID__c,thisSetupObject.DefaultQueue__c));
            else
                objectsInUse.add(new TableCols(objName,objectsAvailable.get(objName).getDescribe().getLabel(),'','','',''));
        }
    }

    public List<SelectOption> getAvailablePicklist() {
        //make a list and sort it
        List<String> unusedObjectLabels = new List<String>();
        Map<String, String> unusedObjectNameMap = new Map<String, String>();
        for (String s : objectsAvailable.keySet()) {
            if (!foundStrs.contains(s)) {
                String thisLabel = objectsAvailable.get(s).getDescribe().getLabel();
                if(objectsAvailable.get(s).getDescribe().isSearchable()){
                    unusedObjectLabels.add(thisLabel);
                    unusedObjectNameMap.put(thisLabel, s);
                }
            }
        }
        
        unusedObjectLabels.sort();
        
        List<SelectOption> options = new List<SelectOption>();
                
        //create select options for each item
        for (String s : unusedObjectLabels)
            options.add(new SelectOption(unusedObjectNameMap.get(s), s));

        return options;
    }
    public PageReference editNewObject() {
        //find if the inUseRoster already exists
        InUseRoster__c exists = InUseRoster__c.getInstance(objToAdd);
        if (exists == null) {
            //create one
            exists = new InUseRoster__c();
            exists.Name = objToAdd;
            exists.Bitz__c = 0;
            insert exists;
        }

        objToEdit = objToAdd;
        return editObject();
    }
    public PageReference editObject() {
        PageReference curr = new PageReference('/apex/oae_Rules_FieldAdd?oObject='+objToEdit);
        curr.setRedirect(true);
        return curr;
    }

}