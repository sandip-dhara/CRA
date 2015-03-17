trigger AfterReleaseStageUpdate on Offering_Release_Stage__c (after update) {
    /*if(Trigger.isUpdate)
    {
        for(Offering_Release_Stage__c orsc:trigger.new)
        {
            List<Stage_Deliverable__c> deliverables = [Select id,Deliverable_ID__c,Deliverable_ID__r.Name__c,
                                                       Deliverable_ID__r.RecordType.Name
                                                       From Stage_Deliverable__c
                                                       Where Stage_ID__c = :orsc.Stage_ID__c];
            List<Release_Deliverable__c> rds = [Select Id,Stage_Deliverable_ID__c,Stage_Deliverable_ID__r.Deliverable_ID__c,RecordType.Name
                        From Release_Deliverable__c
                        Where Offering_Release_Stage_ID__c = :orsc.id];
            for(Stage_Deliverable__c sdc:deliverables)
            {
                if(PLMCheckExistTools.CheckStageDeliverableNotExists(rds, sdc.Id))
                {
                    system.debug('add:'+ sdc.Deliverable_ID__r.Name__c);
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
            
            for(Offering_Release_Stage__c oldOrsc:trigger.old)
            {
                if(oldOrsc.Id == orsc.Id)
                {
                    if(oldOrsc.Status__c == 'Not Started' && orsc.Status__c == 'In Progress')
                    {
                        for(Release_Deliverable__c rdc:rds)
                        {
                            if(rdc.RecordType.Name == 'Attachment' && rdc.Stage_Deliverable_ID__c != null)
                            {
                                 List<Attachment> attList = [select id, name, body from Attachment where ParentId = :rdc.Id];
                                 if(attList.Size() < 1)
                                 {
                                     PLMTransferTools.CopyAttachmentToOtherObject(rdc.Stage_Deliverable_ID__r.Deliverable_ID__c, rdc.id);
                                 }
                             }
                        }
                    }
                }
            }
        }
    }*/
}