trigger AfterReleaseStageInsert on Offering_Release_Stage__c (after insert) {
    /*if(Trigger.isInsert)
    {
        for(Offering_Release_Stage__c orsc:trigger.new)
        {
            List<Stage_Deliverable__c> deliverables = [Select id,Deliverable_ID__c,Deliverable_ID__r.Name__c,
                                                       Deliverable_ID__r.RecordType.Name
                                                       From Stage_Deliverable__c
                                                       Where Stage_ID__c = :orsc.Stage_ID__c];
            for(Stage_Deliverable__c sdc:deliverables)
            {
                Release_Deliverable__c c = new Release_Deliverable__c(
                    Offering_Release_Stage_ID__c = orsc.id,
                    Stage_Deliverable_ID__c = sdc.Id,
                    Release_Deliverable_Name__c = sdc.Deliverable_ID__r.Name__c,
                    //Description__c = sdc.Deliverable_ID__r.Description__c,
                    RecordTypeId = PLMTransferTools.TransferRecordType(sdc.Deliverable_ID__r.RecordType.Name,'Release_Deliverable__c'));
                insert c;
                //PLMTransferTools.CopyAttachmentToOtherObject(sdc.Deliverable_ID__c, c.id);
            }
        }
    }*/
}