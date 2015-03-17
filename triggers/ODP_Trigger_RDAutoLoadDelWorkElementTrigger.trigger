trigger ODP_Trigger_RDAutoLoadDelWorkElementTrigger on Release_Deliverable__c (after insert) {
    if(Trigger.isInsert)
    {
        for(Release_Deliverable__c rdc:trigger.new)
        {
            ODP_Class_DataLoadUtility.AutoLoadStageWorkElementByDeliverable(rdc.Id);
        }
    }
}