trigger AfterStageDeliverableInsert on Stage_Deliverable__c (after insert) {
   /* if(Trigger.isInsert)
    {
        for(Stage_Deliverable__c sdc:trigger.new)
        {
            List<Offering_Release_Stage__c> releaseStages = [Select id
                                                       From Offering_Release_Stage__c
                                                       Where Stage_ID__c = :sdc.Stage_ID__c];
            Deliverable__c deliver = [Select Name__c,RecordType.Name
                                                       From Deliverable__c
                                                       Where id = :sdc.Deliverable_ID__c];
            for(Offering_Release_Stage__c orsc:releaseStages)
            {
                Release_Deliverable__c c = new Release_Deliverable__c(
                    Offering_Release_Stage_ID__c = orsc.id,
                    Stage_Deliverable_ID__c = sdc.Id,
                    Release_Deliverable_Name__c = deliver.Name__c,
                    //Description__c = deliver.Description__c,
                    RecordTypeId = PLMTransferTools.TransferRecordType(deliver.RecordType.Name,'Release_Deliverable__c'));
                insert c;
                if(deliver.RecordType.Name == 'Attachment')
                {
                    PLMTransferTools.CopyAttachmentToOtherObject(sdc.Deliverable_ID__c, c.id);
                }
            }
        }
    }*/
}