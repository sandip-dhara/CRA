/*
Functional Description
1, If (all Review.complete has been checked),set Stage Work Element.Status = 'Review Complete', Email Notification
to Stage Work Element Owner. 

Change History
03/14/2014 - Ning Kang : Email Notification to Accountable Team Member not stage work element created by when review complete

*/

trigger ODP_Trigger_SWEReviewCompleted on Review__c (after update) {
    if(Trigger.isUpdate)
    {
         for(Review__c rvNew:trigger.new)
         {
            Review__c rvOld = null;       
            for(Review__c rv:trigger.old)
            {
                if(rv.Id == rvNew.Id)
                {
                    rvOld = rv;
                    break;
                }
            }
            if(rvNew.Complete__c == true && rvOld.Complete__c == false)
            {
                List<Review__c> peerReviewors = [
                    select Complete__c
                    from Review__c
                    where Stage_Work_Element__c=:rvNew.Stage_Work_Element__c
                ];
                Boolean allCompleted = true;
                for(Review__c rv:peerReviewors)
                {
                    if(rv.Complete__c == false)
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
                        where Id=:rvNew.Stage_Work_Element__c
                    ];
                    if(swe.Status__c == 'Under Review')
                    {
                        swe.Status__c = 'Review Complete';
                        update swe;
                    }
                    if(swe.Accountable_Team_Member__r.User__r.Id != null){
                        ODP_Class_EmailNotification.SendToPerson(String.valueOf(swe.Accountable_Team_Member__r.User__r.Id),
                                      'The work element "' + swe.Name__C + '" review has been completed.',
                                      'The work element "' + swe.Name__C + '" review has been completed by all the reviewers and status set to Review Complete. Please check the details as below and Mark it Complete or Rework',
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