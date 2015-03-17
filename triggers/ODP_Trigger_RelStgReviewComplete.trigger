/*
Functional Description
1, All the Stage Review.complete has been checked(completed) from 'unchecked' (uncomplete), then update release stage.Status
to 'Review Complete', Send email notification to release stage owner

Change History

*/

trigger ODP_Trigger_RelStgReviewComplete on Stage_Review__c (after update) {
    if(Trigger.isUpdate)
    {
         for(Stage_Review__c rvNew:trigger.new)
         {
            Stage_Review__c rvOld = null;       
            for(Stage_Review__c rv:trigger.old)
            {
                if(rv.Id == rvNew.Id)
                {
                    rvOld = rv;
                    break;
                }
            }
            if(rvNew.Complete__c == true && rvOld.Complete__c == false)
            {
                List<Stage_Review__c> peerReviewors = [
                    select Complete__c
                    from Stage_Review__c
                    where Release_Stage_ID__c=:rvNew.Release_Stage_ID__c
                ];
                Boolean allCompleted = true;
                for(Stage_Review__c rv:peerReviewors)
                {
                    if(rv.Complete__c == false)
                    {
                        allCompleted = false;
                        break;
                    }
                }
                if(allCompleted)
                {
                    Release_Stage__c releaseStage = [select Id,Stage_Name__c,CreatedById,Status__c,Offering_Release_ID__c,Release_Name__c,
                                                 Offering_Release_ID__r.OwnerId,
                                                 Offering_Release_ID__r.Owner.Name,Offering_Release_ID__r.Owner.email
                                   from Release_Stage__c
                                   where Id = :rvNew.Release_Stage_ID__c];
                    
                    if(releaseStage.Status__c != 'Review Complete')
                    {
                        releaseStage.Status__c = 'Review Complete';
                        update releaseStage;
                    }
                    ODP_Class_EmailNotification.SendToPerson(String.valueOf(releaseStage.CreatedById),
                                  'The Release Stage "' + releaseStage.Stage_Name__c + '" review has completed.',
                                  'The Release Stage "' + releaseStage.Stage_Name__c + '" review has completed, Please check the detail information as below.',
                                  '<a href="{base}/'+releaseStage.Offering_Release_ID__c+'"> ' + releaseStage.Release_Name__c + '</a>',
                                  '<a href="{base}/'+releaseStage.Id+'"> ' + releaseStage.Stage_Name__c + '</a>',
                                                             null,null,
                                  'Offering Manager : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Owner.email  + '">  ' + releaseStage.Offering_Release_ID__r.Owner.Name + ' </a>');
                }
            }
         }
    }
}