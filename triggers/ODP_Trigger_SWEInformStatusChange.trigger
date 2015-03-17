/*
Functional Description
1, If(Stage Work Element.Status = 'Under Review'), Email Notification to SWE.Reviewer to start the review
2, If(Stage Work Element.Status = 'Complete'), Email Notification to Offering Release Owner (Offering Manager) 'SWE completed'
3, If(Stage Work Element.Status = 'Rework'), Email Notification to SWE.Reviewer and SWE.Contributor and stage work element owner (offering manager) to rework.
   set comtributor.complete as unchecked, set reviewer.complete as unchecked. 
Change History
-----Hunter 26/3/2014-----------
when swe completed the accountable user should be inform.

-----Hunter 9/5/2014-----------
when swe completed the not mark complete done users should be inform.
*/


trigger ODP_Trigger_SWEInformStatusChange on Stage_Work_Element__c (after update) {
    if(Trigger.isUpdate)
    {
         for(Stage_Work_Element__c sweNew:trigger.new)
         {
            Stage_Work_Element__c sweOld = null;       
            for(Stage_Work_Element__c swe:trigger.old)
            {
                if(swe.Id == sweNew.Id)
                {
                    sweOld = swe;
                    break;
                }
            }
            
            if(sweNew.Status__c == 'Under Review' && sweOld.Status__c != 'Under Review')
            {
                List<Review__c> reviewers = [
                  select Team_Member__r.User__c
                    from Review__c
                    where Stage_Work_Element__c=:sweNew.Id
                ];
                Release_Stage__c releaseStage = [select Offering_Release_ID__c,Release_Name__c,
                                                 Offering_Release_ID__r.Owner.Name,Offering_Release_ID__r.Owner.email,
                                                 Offering_Release_ID__r.Facilitator__r.Name,Offering_Release_ID__r.Facilitator__r.email
                                   from Release_Stage__c
                                   where Id = :sweNew.Release_Stage_ID__c];
                Set<Id> ReviewerSet = new Set<Id>();
                for(Review__c reviewer:reviewers)
                {
                    if(reviewer.Team_Member__r.User__c != null){
                        if(!ReviewerSet.Contains(reviewer.Team_Member__r.User__c))
                        {
                            ReviewerSet.add(reviewer.Team_Member__r.User__c);
                        }
                	}
                }
                for(Id reviewer:ReviewerSet)
                {
                    ODP_Class_EmailNotification.SendToPerson(String.valueOf(reviewer),
                                  'The Stage work element "' + sweNew.Name__C + '" is under review',
                                  'The Stage work element "' + sweNew.Name__C + '" is under review, Please check the detail information as below and start the review',
                                  '<a href="{base}/'+releaseStage.Offering_Release_ID__c+'"> ' + releaseStage.Release_Name__c + '</a>',
                                  '<a href="{base}/'+sweNew.Release_Stage_ID__c+'"> ' + sweNew.Stage_Name__c + '</a>',
                                                             null,
                                  '<a href="{base}/apex/ODP_ReviewPage"> ' + sweNew.Name__C + '</a>',
                                  'Business Engagement Partner : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + releaseStage.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                }
                
                List<Contributor__c> NotCompletedConList = [select Team_Members__r.User__c from Contributor__c where Stage_Work_Element__c=:sweNew.Id and Completed__c=false];
                if(NotCompletedConList.size() > 0)
                {
                    Set<Id> contributorSet = new Set<Id>();
                    for(Contributor__c con:NotCompletedConList){
                        if(con.Team_Members__r.User__c != null ){
                            if(!contributorSet.contains(con.Team_Members__r.User__c)){
                                contributorSet.add(con.Team_Members__r.User__c);
                                ODP_Class_EmailNotification.SendToPerson(String.valueOf(con.Team_Members__r.User__c),
                                      'The Stage work element "' + sweNew.Name__C + '" is under review',
                                      'The Stage work element "' + sweNew.Name__C + '" is under review, but your work did not mark to done, please contact project manager for detail message.',
                                      '<a href="{base}/'+releaseStage.Offering_Release_ID__c+'"> ' + releaseStage.Release_Name__c + '</a>',
                                      '<a href="{base}/'+sweNew.Release_Stage_ID__c+'"> ' + sweNew.Stage_Name__c + '</a>',
                                                                 null,
                                      '<a href="{base}/apex/ODP_ReviewPage"> ' + sweNew.Name__C + '</a>',
                                      'Business Engagement Partner : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + releaseStage.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                            }
                    	}
                    }
                }
            }
             
            if(sweNew.Status__c == 'Complete' && sweOld.Status__c != 'Complete')
            {
                Release_Stage__c releaseStage = [select Offering_Release_ID__c,Release_Name__c,
                                                 Offering_Release_ID__r.OwnerId,
                                                 Offering_Release_ID__r.Owner.Name,Offering_Release_ID__r.Owner.email,
												 Offering_Release_ID__r.Facilitator__r.Name,Offering_Release_ID__r.Facilitator__r.email
                                   from Release_Stage__c
                                   where Id = :sweNew.Release_Stage_ID__c];
                Set<Id> informMembers = new Set<Id>();
                if(releaseStage.Offering_Release_ID__r.OwnerId != null){
                    informMembers.Add(releaseStage.Offering_Release_ID__r.OwnerId);
                    ODP_Class_EmailNotification.SendToPerson(String.valueOf(releaseStage.Offering_Release_ID__r.OwnerId),
                              'The Stage work element "' + sweNew.Name__C + '" has completed.',
                              'The Stage work element "' + sweNew.Name__C + '" has completed, Please check the detail information as below.',
                              '<a href="{base}/'+releaseStage.Offering_Release_ID__c+'"> ' + releaseStage.Release_Name__c + '</a>',
                              '<a href="{base}/'+sweNew.Release_Stage_ID__c+'"> ' + sweNew.Stage_Name__c + '</a>',
                                                             null,
                              '<a href="{base}/'+sweNew.Id+'"> ' + sweNew.Name__C + '</a>',
                              'Business Engagement Partner : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + releaseStage.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                }
                //add by june 05/27/2014 send email to successor work element owner
                List<Stage_Work_Element_Predecessor__c> sweps =[select id,Name,
                                                               		  Predecessor_Stage_Work_Element_ID__c,
                                                                      Stage_Work_Element__c,Stage_Work_Element__r.Accountable_Team_Member__r.User__c,
                                                                	  Predecessor_Stage_Work_Element_ID__r.Name__c,Stage_Work_Element__r.Name__c,
                                                                	  Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c,
                                                                	  Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Name__c
                                                               from Stage_Work_Element_Predecessor__c 
                                                               where Predecessor_Stage_Work_Element_ID__c=:sweNew.id 
                                                               and Predecessor_Stage_Work_Element_ID__r.Release_Stage_ID__c=:sweNew.Release_Stage_ID__c];
                if(sweps.size()>0)
                {
                    for(Stage_Work_Element_Predecessor__c swep : sweps){
                        ODP_Class_EmailNotification.SendToPerson(String.valueOf(swep.Stage_Work_Element__r.Accountable_Team_Member__r.User__c),      
                    			'The Predecessor work element "' + swep.Predecessor_Stage_Work_Element_ID__r.Name__c + '" has completed.',
                                'The Predecessor work element "' + swep.Predecessor_Stage_Work_Element_ID__r.Name__c + '" has completed. You can start your work element "'+swep.Stage_Work_Element__r.Name__c+'" ',                  
                                 '<a href="{base}/'+swep.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c+'"> ' +swep.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Name__c+ '</a>',
                                 '<a href="{base}/'+sweNew.Release_Stage_ID__c+'"> ' + sweNew.Stage_Name__c + '</a>',                                
                              	null,
                                '<a href="{base}/'+swep.Stage_Work_Element__c+'"> ' +swep.Stage_Work_Element__r.Name__c+ '</a>',
                                 'Business Engagement Partner : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + releaseStage.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                    }
					
                }
                
                //--end--
                if(sweNew.Accountable_Team_Member__c != null)
                {
                    Core_Team_Member__c accountabler = [
                        select User__c
                        from Core_Team_Member__c
                        where Id = :sweNew.Accountable_Team_Member__c
                    ];
                    if(accountabler.User__c != releaseStage.Offering_Release_ID__r.OwnerId)
                    {
                        if(accountabler.User__c != null){
                            if(!informMembers.contains(accountabler.User__c)){
                                informMembers.add(accountabler.User__c);
                            }
                        }
                    }
                }
                
                //send email too the contributors who is not mark compelete done.
                List<Contributor__c> NotCompleteConList = [select Team_Members__r.User__c from Contributor__c where Stage_Work_Element__c=:sweNew.Id and Completed__c=false];
                if(NotCompleteConList.Size() > 0){
                    for(Contributor__c con :NotCompleteConList){
                        if(con.Team_Members__r.User__c != null){
                            if(!informMembers.contains(con.Team_Members__r.User__c)){
                                informMembers.add(con.Team_Members__r.User__c);
                            }
                        }    
                    }
                }
                if(informMembers.Size() > 0){
                    for(ID u:informMembers){
                        ODP_Class_EmailNotification.SendToPerson(String.valueOf(u),
                              'The Stage work element "' + sweNew.Name__C + '" has completed.',
                              'The Stage work element "' + sweNew.Name__C + '" has completed, Please check the detail information as below.',
                              '<a href="{base}/'+releaseStage.Offering_Release_ID__c+'"> ' + releaseStage.Release_Name__c + '</a>',
                              '<a href="{base}/'+sweNew.Release_Stage_ID__c+'"> ' + sweNew.Stage_Name__c + '</a>',
                                                             null,
                              '<a href="{base}/'+sweNew.Id+'"> ' + sweNew.Name__C + '</a>',
                              'Business Engagement Partner : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + releaseStage.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                    }
                }
                
                //add judge branch for all swe complete to inform owner
                List<Stage_Work_Element__c> brotherSwes = [select Status__c from Stage_Work_Element__c where Release_Stage_ID__c=:sweNew.Release_Stage_ID__c and Include__c=true];
                boolean allcompelete = true;
                for(Stage_Work_Element__c swe:brotherSwes)
                {
                    if(swe.Status__c != 'Complete')
                    {
                        allcompelete = false;
                        break;
                    }
                }
                if(allcompelete)
                {
                    if(releaseStage.Offering_Release_ID__r.OwnerId != null){
                        ODP_Class_EmailNotification.SendToPerson(String.valueOf(releaseStage.Offering_Release_ID__r.OwnerId),
                              'All the stage work elements for "' + sweNew.Stage_Name__c + '" has completed.',
                              'All the stage work elements for "' + sweNew.Stage_Name__c + '" has completed, Please start Stage Review via setting stage status to "In Review".',
                              '<a href="{base}/'+releaseStage.Offering_Release_ID__c+'"> ' + releaseStage.Release_Name__c + '</a>',
                              '<a href="{base}/'+sweNew.Release_Stage_ID__c+'"> ' + sweNew.Stage_Name__c + '</a>',
                                                             null,
                                                             null,
                              'Business Engagement Partner : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + releaseStage.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                	}
                }
            }
             
            if(sweNew.Status__c == 'Rework' && sweOld.Status__c != 'Rework')
            {
                Release_Stage__c releaseStage = [select Offering_Release_ID__c,Release_Name__c,
                                                 Offering_Release_ID__r.OwnerId,
                                                 Offering_Release_ID__r.Owner.Name,Offering_Release_ID__r.Owner.email,
												 Offering_Release_ID__r.Facilitator__r.Name,Offering_Release_ID__r.Facilitator__r.email
                                   from Release_Stage__c
                                   where Id = :sweNew.Release_Stage_ID__c];
                Set<Id> informToSet = new Set<Id>();
                List<Contributor__c> contributors = [
                  select Completed__c,Team_Members__r.User__c
                    from Contributor__c
                    where Stage_Work_Element__c=:sweNew.Id
                ];
                for(Contributor__c contributor:contributors)
                {
                    contributor.Completed__c = false;
                    if(contributor.Team_Members__r.User__c != null){
                        if(!informToSet.contains(contributor.Team_Members__r.User__c))
                        {
                            ODP_Class_EmailNotification.SendToPerson(String.valueOf(contributor.Team_Members__r.User__c),
                                      'The Stage work element "' + sweNew.Name__C + '" has been set to rework.',
                                      'The Stage work element "' + sweNew.Name__C + '" has been set to rework, Please check the detail information as below.',  
                                      '<a href="{base}/'+releaseStage.Offering_Release_ID__c+'"> ' + releaseStage.Release_Name__c + '</a>',
                                      '<a href="{base}/'+sweNew.Release_Stage_ID__c+'"> ' + sweNew.Stage_Name__c + '</a>',
                                                                     null,
                                      '<a href="{base}/'+sweNew.Id+'"> ' + sweNew.Name__C + '</a>',
                                      'Business Engagement Partner : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + releaseStage.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                            informToSet.add(contributor.Team_Members__r.User__c);
                        }
                    }    
                }
                update contributors;
                
                List<Review__c> reviewers = [
                  select Complete__c,Team_Member__r.User__c
                    from Review__c
                    where Stage_Work_Element__c=:sweNew.Id
                ];
                for(Review__c reviewer:reviewers)
                {
                    reviewer.Complete__c = false;
                    if(reviewer.Team_Member__r.User__c != null){
                        if(!informToSet.contains(reviewer.Team_Member__r.User__c))
                        {
                            ODP_Class_EmailNotification.SendToPerson(String.valueOf(reviewer.Team_Member__r.User__c),
                                      'The Stage work element "' + sweNew.Name + '" has been set to rework.',
                                      'The Stage work element "' + sweNew.Name + '" has been set to rework, Please check the detail information as below.',
                                      '<a href="{base}/'+releaseStage.Offering_Release_ID__c+'"> ' + releaseStage.Release_Name__c + '</a>',
                                      '<a href="{base}/'+sweNew.Release_Stage_ID__c+'"> ' + sweNew.Stage_Name__c + '</a>',
                                                                     null,
                                      '<a href="{base}/'+reviewer.Id+'"> ' + sweNew.Name__C + '</a>',
                                      'Business Engagement Partner : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + releaseStage.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                            informToSet.add(reviewer.Team_Member__r.User__c);
                        }
                    }    
                }
                update reviewers;//*/
                
                if(!informToSet.contains(sweNew.CreatedById))
                {
                    if(sweNew.CreatedById != null){
                    ODP_Class_EmailNotification.SendToPerson(String.valueOf(sweNew.CreatedById),
                                  'The Stage work element "' + sweNew.Name + '" has been set to rework.',
                                  'The Stage work element "' + sweNew.Name + '" has been set to rework, Please check the detail information as below.',
                                  '<a href="{base}/'+releaseStage.Offering_Release_ID__c+'"> ' + releaseStage.Release_Name__c + '</a>',
                                  '<a href="{base}/'+sweNew.Release_Stage_ID__c+'"> ' + sweNew.Stage_Name__c + '</a>',
                                                                 null,
                                  '<a href="{base}/'+sweNew.Id+'"> ' + sweNew.Name__C + '</a>',
                                  'Business Engagement Partner : <a href="mailto:' + releaseStage.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + releaseStage.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                	}
                }
            }
         }
    }
}