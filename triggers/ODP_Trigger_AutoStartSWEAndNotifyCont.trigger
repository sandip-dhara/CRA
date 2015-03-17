/*
Functional Description
1, If Release Stage.Status has been change from 'Not Started' to 'In Progress', set all the sub stage work element.status to 'In Progress'
   Email notification to all the stage work element contributors  and they can start the work
2, Email content include the list of stage work element for one stage
Change History
 -- Email to the contributors with the list of stage work element for one stage
--------------Hunter 3/26/2014 ---------------------
 -- When Release Stage status changed to "In Progress", all SWE status = "Under Review" if no contributor exists AND SWE include = true
 -- Email the accountable team member
--------------Hunter 4/15/2014 ---------------------
-- If the owner start the stage  Enmail the facilitator
-- If the facilitator start the stage Email the Owner
*/


trigger ODP_Trigger_AutoStartSWEAndNotifyCont on Release_Stage__c (after update) {
     if(Trigger.isUpdate)
     {
         for(Release_Stage__c rsNew:trigger.new)
         {
            Release_Stage__c rsOld = null;       
            for(Release_Stage__c rs:trigger.old)
            {
                if(rs.Id == rsNew.Id)
                {
                    rsOld = rs;
                    break;
                }
            }
            //SQL Improve Hunter 2 move this script block into the if block
            //Offering_Release__c offeringRelease = [select Owner.Name,Owner.Email
            //                                      from Offering_Release__c
            //                                      where Id=:rsNew.Offering_Release_ID__c];
            
            if(rsNew.Status__c == 'In Progress' && rsOld.Status__c == 'Not Started')
            {
                Map<Id,String> informMembers = new Map<Id,String>();
                Id userID = UserInfo.getUserId();
                Offering_Release__c offeringRelease = [select Owner.Name,Owner.Email,Owner.Id,Facilitator__c,Facilitator__r.Name,Facilitator__r.Email
                                                  from Offering_Release__c
                                                  where Id=:rsNew.Offering_Release_ID__c];
                String activeByWho = '';
                if(userID == offeringRelease.Owner.Id)
                {
                    activeByWho = 'Owner('+offeringRelease.Owner.Name+')';
                    if(offeringRelease.Facilitator__c != null && offeringRelease.Facilitator__c != userID)
                    {
                        informMembers.put(offeringRelease.Facilitator__c, 
                                          ' You are Business Engagement Partner for this stage');
                    }
                }
                else if(userID == offeringRelease.Facilitator__c)
                {
                    activeByWho = 'Business Engagement Partner('+offeringRelease.Facilitator__r.Name+')';
                    if(offeringRelease.Owner.Id != null && offeringRelease.Owner.Id != userID)
                    {
                        informMembers.put(offeringRelease.Owner.Id, 
                                          ' You are Owner for this stage');
                    }
                }
                else
                {
                    activeByWho = 'Administrator('+UserInfo.getUserName()+')';
                    informMembers.put(offeringRelease.Owner.Id, 
                                          ' You are Owner for this stage');
                    if(offeringRelease.Facilitator__c != null && offeringRelease.Facilitator__c != offeringRelease.Owner.Id)
                    {
                        informMembers.put(offeringRelease.Facilitator__c, 
                                          ' You are Business Engagement Partner for this stage');
                    }
                }
                
                List<Stage_Work_Element__c> stageWorkElements = [
                    select Id,Status__c,Accountable_Team_Member__r.User__c,Name__c
                    from Stage_Work_Element__c
                    where Release_Stage_ID__c=:rsNew.Id and Include__c=true
                ];
                List<Stage_Work_Element__c> updateStageWorkElements = new List<Stage_Work_Element__c>();
                
                for(Stage_Work_Element__c stageWorkElement:stageWorkElements)
                {
                    if(stageWorkElement.Status__c=='Not Started')
                    {
                        List<Contributor__c> contributors = [
                            select Id from Contributor__c
                            where Stage_Work_Element__c = :stageWorkElement.Id
                        ];
                        if(contributors.size() > 0)
                        {
                            stageWorkElement.Status__c='In Progress';
                        }
                        else
                        {
                            stageWorkElement.Status__c='Under Review';
                        }
                        updateStageWorkElements.add(stageWorkElement);
                    }
                    if(!informMembers.containsKey(stageWorkElement.Accountable_Team_Member__r.User__c))
                    {
                        informMembers.put(stageWorkElement.Accountable_Team_Member__r.User__c, 
                                          '<a href="{base}/apex/ODP_NewContributionsPage"> ' + stageWorkElement.Name__c + '</a>(Accountabler)');
                    }
                    else
                    {
                        if(stageWorkElement.Accountable_Team_Member__c != null){
                            string str = informMembers.get(stageWorkElement.Accountable_Team_Member__r.User__c);
                            informMembers.put(stageWorkElement.Accountable_Team_Member__r.User__c, str + '<br><a href="{base}/apex/ODP_NewContributionsPage"> ' + stageWorkElement.Name__c + '</a>(Accountabler)');
                        }
                    }
                }
                if(updateStageWorkElements.Size() > 0)
                {
                    update updateStageWorkElements;
                }
                List<Contributor__c> contributors = [
                    select Team_Members__r.User__c, Stage_Work_Element_Name__c, Stage_Work_Element__c
                    from Contributor__c
                    where Stage_Work_Element__r.Release_Stage_ID__c = :rsNew.Id
                ];
                
                for(Contributor__c contributor:contributors)
                {
                    if(contributor.Team_Members__c != null){
                        if(!informMembers.containsKey(contributor.Team_Members__r.User__c))
                        {
                            informMembers.put(contributor.Team_Members__r.User__c, 
                                              '<a href="{base}/apex/ODP_ContributorPage?id='+contributor.id+'">' + contributor.Stage_Work_Element_Name__c + '</a>(Contributor)');
                        }
                        else
                        {
                            string str = informMembers.get(contributor.Team_Members__r.User__c);
                            informMembers.put(contributor.Team_Members__r.User__c, str + '<br><a href="{base}/apex/ODP_ContributorPage?id='+contributor.id+'">' + contributor.Stage_Work_Element_Name__c + '</a>(Contributor)');
                        }
                    }
                }
                if(informMembers.size() > 0){
                    List<User> tempUserList = [select id,email, Name from User where id in :informMembers.KeySet()];
                    Map<Id,User> tempUserMap = new Map<Id,User>();
                    for(User u:tempUserList){
                        tempUserMap.put(u.Id, u);
                    }
                    ODP_Class_BatchMail batchMail = new ODP_Class_BatchMail();
                    for(Id uId:informMembers.KeySet())
                    {
                        
                        /*ODP_Class_EmailNotification.SendToPerson(String.valueOf(uid),
                              'The release stage "' + rsNew.Stage_Name__c + '" has been activated. Start to work now',
                              'The release stage "' + rsNew.Stage_Name__c + '" has been activated by '+activeByWho+'. You are the Accountabler/contributor for the following list of work elements. Please get the detailed information and start to work with your priority.',
                              '<a href="{base}/'+rsNew.Offering_Release_ID__c+'"> ' + rsNew.Release_Name__c + '</a>',
                              '<a href="{base}/'+rsNew.Id+'"> ' + rsNew.Stage_Name__c + '</a>',
                                                                 Null,
                              informMembers.get(uId),
                              'Business Project Manager : <a href="mailto:' + offeringRelease.Owner.email  + '">  ' + offeringRelease.Owner.Name + ' </a>');
*/
                        batchMail.AddMail(tempUserMap.get(uId),
                              'The release stage "' + rsNew.Stage_Name__c + '" has been activated. Start to work now',
                              'The release stage "' + rsNew.Stage_Name__c + '" has been activated by '+activeByWho+'. You are the Accountabler/contributor for the following list of work elements. Please get the detailed information and start to work with your priority.',
                              '<a href="{base}/'+rsNew.Offering_Release_ID__c+'"> ' + rsNew.Release_Name__c + '</a>',
                              '<a href="{base}/'+rsNew.Id+'"> ' + rsNew.Stage_Name__c + '</a>',
                                                                 Null,
                              informMembers.get(uId),
                              'Business Engagement Partner : <a href="mailto:' + offeringRelease.Facilitator__r.email  + '">  ' + offeringRelease.Facilitator__r.Name + ' </a>');
                    }
                    Messaging.sendEmail(batchMail.LstMail);
                }
            }
         }
    }
    
}