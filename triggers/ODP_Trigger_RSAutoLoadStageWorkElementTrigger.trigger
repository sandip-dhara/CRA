trigger ODP_Trigger_RSAutoLoadStageWorkElementTrigger on Release_Stage__c (after insert) {
    if(Trigger.isInsert)
    {
        try{
            for(Release_Stage__c rsc:trigger.new)
            {
                ODP_Class_DataLoadUtility.AutoLoadStageWorkElementByRelStage(rsc.Id);
            }
        }
        catch(exception ex){
            System.debug(ex.getMessage());
        }
    }

}