/*
Functional Description:
1, Flight Plan is not allowed to be changed when offering release get approved. Error Information should display for
end users - TBD

Change History:
2014-04-23 Hunter
after delete check and add offering manager roles
Change History:
2014-05-23 Hunter
move delete deliverable after to delete stage

*/

trigger ODP_Trigger_ORFlightPlanReload  on Offering_Release__c (after update) {
    if(Trigger.isUpdate)
    {
         for(Offering_Release__c orNew:trigger.new)
         {
            Offering_Release__c orOld = null;       
            for(Offering_Release__c orc:trigger.old)
            {
                if(orc.Id == orNew.Id)
                {
                    orOld = orc;
                    break;
                }
            }
            if(orNew.Flight_Plan_ID__c != orOld.Flight_Plan_ID__c )
            {
                if(orNew.Status__c != 'Start Up' && orNew.Status__c != 'Not Started' )
                {
                    trigger.newMap.get(orNew.Id).addError('The Flight Plan is not allowed to be changed after the Opportunity has been approved');
                }
                else
                {
                    
                    List<ProcessInstance> PI = [Select Id,Status,CreatedDate 
                         From ProcessInstance 
                         WHERE TargetObjectId =:orNew.Id and status='Approved'];
                    
                    if(PI.size() > 0)
                    {
                        trigger.newMap.get(orNew.Id).addError('The Flight Plan is not allowed to be changed after the Opportunity has been approved');
                    }
                    else
                    {
                        Set<Id> startupDeliverables = new Set<Id>();
                        Set<Id> startupStages = new Set<Id>();
                        if(orOld.Flight_Plan_ID__c!=null)
                        {
                            List<Release_Deliverable__c> rds = [select Id,Deliverable_ID__c from Release_Deliverable__c where Offering_Release__c=:orOld.Id];
                            List<Release_Stage__c> rss = [select Id,Stage_ID__c from Release_Stage__c where Offering_Release_ID__c=:orOld.Id];
                            
                            List<Flight_Plan_Deliverable__c> fpDliverables = [select Deliverable__c
                                                                             from Flight_Plan_Deliverable__c
                                                                             where Flight_Plan__r.Name__c = 'ESIT OpportunityStartup'];
                            
                            for(Flight_Plan_Deliverable__c d:fpDliverables)
                            {
                                if(!startupDeliverables.contains(d.Deliverable__c))
                                {
                                    startupDeliverables.add(d.Deliverable__c);
                                }
                            }
                            
                            
                            List<Flight_Plan_Stage__c> fpStages = [select Stage_ID__c
                                                                             from Flight_Plan_Stage__c
                                                                             where FlightPlan_ID__r.Name__c = 'ESIT OpportunityStartup'];
                            
                            for(Flight_Plan_Stage__c s:fpStages)
                            {
                                if(!startupStages.contains(s.Stage_ID__c))
                                {
                                    startupStages.add(s.Stage_ID__c);
                                }
                            }
                            List<Release_Stage__c> deleteRss = new List<Release_Stage__c>();
                            Set<Id> delStageIdSet = new Set<Id>();
                            for(Release_Stage__c rs:rss)
                            {
                                if(!startupStages.contains(rs.Stage_ID__c))
                                {
                                    deleteRss.add(rs);
                                    delStageIdSet.add(rs.Id);
                                }
                            }
                            if(deleteRss.size() > 0)
                            {
                                //need del stage work element prodecessor first other wise will cause associated error.
                                List<Stage_Work_Element_Predecessor__c> delSWEPredecessorList = [
                                    select Id
                                    from Stage_Work_Element_Predecessor__c
                                    where Stage_Work_Element__r.Release_Stage_ID__c in :delStageIdSet
                                ];
                                delete delSWEPredecessorList;
                                
                                //find and delete no use release rule
                                List<Release_Role__c> releaseRoleList = [
                                  select Id,Role_ID__c,Role_Name__c
                                    from Release_Role__c
                                    where Offering_Release__c=:orOld.Id
                                ];
                                List<Work_Element__c> startUpWorkElementList = [
                                    select Id,Accountable_Role__c
                                    from Work_Element__c
                                    where Deliverable_ID__c in :startupDeliverables
                                ];
                                Set<Id> starUpWorkElementSet = new Set<Id>();
                                Set<Id> starUpRoleSet = new Set<Id>();
                                for(Work_Element__c we:startUpWorkElementList)
                                {
                                    starUpWorkElementSet.add(we.Id);
                                    if(!starUpRoleSet.contains(we.Accountable_Role__c))
                                    {
                                        starUpRoleSet.add(we.Accountable_Role__c);
                                    }
                                }
                                List<Work_Element_Contributor_Role__c> starUpContributorList = [
                                    select Role_ID__c
                                    from Work_Element_Contributor_Role__c
                                    where Work_Element_ID__c in :starUpWorkElementSet
                                ];
                                for(Work_Element_Contributor_Role__c wec:starUpContributorList)
                                {
                                    if(!starUpRoleSet.contains(wec.Role_ID__c))
                                    {
                                        starUpRoleSet.add(wec.Role_ID__c);
                                    }
                                }
                                List<Work_Element_Reviewer_Role__c> starUpReviewerList = [
                                    select Role_ID__c
                                    from Work_Element_Reviewer_Role__c
                                    where Work_Element_ID__c in :starUpWorkElementSet
                                ];
                                for(Work_Element_Reviewer_Role__c wer:starUpReviewerList)
                                {
                                    if(!starUpRoleSet.contains(wer.Role_ID__c))
                                    {
                                        starUpRoleSet.add(wer.Role_ID__c);
                                    }
                                }
                                List<Release_Role__c> delReleaseRule = new List<Release_Role__c>();
                                for(Release_Role__c rr:releaseRoleList)
                                {
                                    if(!starUpRoleSet.contains(rr.Role_ID__c) && rr.Role_Name__c != 'Offering Manager' && rr.Role_Name__c != 'Project Manager')
                                    {
                                        delReleaseRule.add(rr);
                                    }
                                }
                                if(delReleaseRule.size() > 0)
                                {
                                    delete delReleaseRule;
                                }
                                
                                
                                delete deleteRss;
                            }
                            
                            //delete deliverables should be done after delete stages
                            List<Release_Deliverable__c> deleteRds = new List<Release_Deliverable__c>();
                            for(Release_Deliverable__c rd:rds)
                            {
                                if(!startupDeliverables.contains(rd.Deliverable_ID__c))
                                {
                                    deleteRds.add(rd);
                                }
                            }
                            if(deleteRds.size() > 0)
                            {
                                delete deleteRds;
                            }
                        }
                        
                        if(orNew.Flight_Plan_ID__c!=null)
                        {
                            ODP_Class_DataLoadUtility.AutoLoadReleaseDeliverable(orNew.Flight_Plan_ID__c, orNew.Id, startupDeliverables);
                            ODP_Class_DataLoadUtility.AutoLoadReleaseStage(orNew.Flight_Plan_ID__c, orNew.Id);
                            
                            string bepName = 'Business Engagement Partner';
                            Core_Team_Member__c bepMember = [select Id,Release_Role__r.Role_ID__c from Core_Team_Member__c where Release_Role__r.Offering_Release__c=:orNew.Id and Role_Name__c=:bepName limit 1];
                            List<Stage_Work_Element__c> updateSWEList = [select Accountable_Team_Member__c from Stage_Work_Element__c where Accountable_Process_Role_Name__c=:bepName and Accountable_Team_Member__c=null and Release_Stage_ID__r.Offering_Release_ID__c=:orNew.Id];
                            if(updateSWEList.size()>0)
                            {
                                for(Stage_Work_Element__c swe:updateSWEList){
                                    swe.Accountable_Team_Member__c = bepMember.Id;
                                }
                                update updateSWEList;
                            }
                            
                            List<Contributor__c> updateConList = [select Team_Members__c from Contributor__c where Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c=:orNew.Id and Role_Name__c=:bepName and Team_Members__c=null];
                            if(updateConList.size()>0)
                            {
                                for(Contributor__c con:updateConList){
                                    con.Team_Members__c = bepMember.Id;
                                }
                                update updateConList;
                            }
                            
                            List<Review__c> updateReviewList = [select Team_Member__c from Review__c where Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c=:orNew.Id and Role_Name__c=:bepName and Team_Member__c=null];
                            if(updateReviewList.size()>0)
                            {
                                for(Review__c rev:updateReviewList){
                                    rev.Team_Member__c = bepMember.Id;
                                }
                                update updateReviewList;
                            }
                        }
                    }
                }
            }
          }
    }
}