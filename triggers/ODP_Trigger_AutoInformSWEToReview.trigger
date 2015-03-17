/*
Functional Description
1, If all the contributor complete the stage work element (all contributor.complete have been checked)
   set Stage Work Element.Status = 'Ready for Review'
   Email notificatino to the stage work element owner
03/14/2014 - Ning Kang : Email Notification to Accountable Team Member not stage work element created by when all contributor complete their work

*/


trigger ODP_Trigger_AutoInformSWEToReview on Contributor__c (after update) {
    if(Trigger.isUpdate)
    {
         for(Contributor__c conNew:trigger.new)
         {
            Contributor__c conOld = null;       
            for(Contributor__c con:trigger.old)
            {
                if(con.Id == conNew.Id)
                {
                    conOld = con;
                    break;
                }
            }
            if(conNew.Completed__c == true && conOld.Completed__c == false)
            {
                List<Contributor__c> peerContributors = [
                    select Completed__c
                    from Contributor__c
                    where Stage_Work_Element__c=:conNew.Stage_Work_Element__c
                ];
                Boolean allCompleted = true;
                for(Contributor__c con:peerContributors)
                {
                    if(con.Completed__c == false)
                    {
                        allCompleted = false;
                        break;
                    }
                }
                if(allCompleted)
                {
                    Stage_Work_Element__c swe = [
                      select Status__c,Accountable_Team_Member__r.User__r.Id,Name__C,Release_Stage_ID__c,Stage_Name__c,Release_Name__c,
                        Release_Stage_ID__r.Offering_Release_ID__c,
                        Release_Stage_ID__r.Offering_Release_ID__r.Owner.Name,
                        Release_Stage_ID__r.Offering_Release_ID__r.Owner.email,
                        Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Name,
                        Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.email
                        from Stage_Work_Element__c
                        where Id=:conNew.Stage_Work_Element__c
                    ];
                    if(swe.Status__c == 'In Progress')
                    {
                        swe.Status__c = 'Ready for Review';
                        update swe;
                    }
                    if(swe.Accountable_Team_Member__r.User__r.Id != null){
                        ODP_Class_EmailNotification.SendToPerson(String.valueOf(swe.Accountable_Team_Member__r.User__r.Id),
                                  'The stage work element "' + swe.Name__C + '" has been set to Ready For Review.',
                                  'The stage work element "' + swe.Name__C + '" has been completed by all the contributors. Status has been set to Ready For Review. Please set Status to Under Review to begin the stage work element review process if there are no more question. Detailed information as below',
                                  '<a href="{base}/'+swe.Release_Stage_ID__r.Offering_Release_ID__c+'"> ' + swe.Release_Name__c + '</a>',
                                  '<a href="{base}/'+swe.Release_Stage_ID__c+'"> ' + swe.Stage_Name__c + '</a>',
                                  null,
                                  '<a href="{base}/'+swe.Id+'"> ' + swe.Name__C + '</a>',
                                  'Business Engagement Partner : <a href="mailto:' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                
                    }
                }
            }
         }
    }
}