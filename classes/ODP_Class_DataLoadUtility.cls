/*
Change History
-------------Hunter 3/25/2014
for function AutoLoadStageWorkElementByDeliverable 
AutoLoadStageWorkElementByRelStage delete the try catch logic, for the trigger can catch the exception.

*/

public class ODP_Class_DataLoadUtility{
    //copy stage from flight plan templete as release stage for specify offering release
    public static void AutoLoadReleaseStage(String flightPlanId, String offeringReleaseId)
    {
        List<Flight_Plan_Stage__c> fpStages = [Select Stage_ID__c,Stage_Name__c,Default_Include__c,
                                                           Stage_ID__r.CurrencyIsoCode,Stage_ID__r.Is_Active__c
                                                           From Flight_Plan_Stage__c
                                                           Where FlightPlan_ID__c = :flightPlanId 
                                                           ORDER BY Name ASC];
        List<Release_Stage__c> rscs = new List<Release_Stage__c>();
        Set<ID> StageIDSet = new Set<ID>();//SQL improvement Hunter 2
        for(Flight_Plan_Stage__c fpsc:fpStages)
        {
            Release_Stage__c c = new Release_Stage__c(
                Stage_ID__c = fpsc.Stage_ID__c,
                Offering_Release_ID__c = offeringReleaseId,
                Include__c = fpsc.Default_Include__c,
                CurrencyIsoCode = fpsc.Stage_ID__r.CurrencyIsoCode
                //Is_Active__c = fpsc.Stage_ID__r.Is_Active__c
            );
            if(!StageIDSet.contains(fpsc.Stage_ID__c)) //SQL improvement Hunter 2
            {
                StageIDSet.add(fpsc.Stage_ID__c);
            }
            rscs.Add(c);
        }
        if(rscs.Size() > 0)
        {
            insert rscs;
            //SQL improvement Hunter 2 
            List<Stage__c> stages = [
                    select Id,Default_Predecessor_Stage_ID__C 
                    from Stage__c
                    where Id in :StageIDSet
                ];
            Map<Id,ID> DefaultPredecessorStageIDMap = new Map<Id,ID>();
            Set<Id> DefaultPredecessorIdSet = new Set<Id>();
            for(Stage__c stage:stages)
            {
                if(stage.Default_Predecessor_Stage_ID__C != null)
                {
                    DefaultPredecessorStageIDMap.put(stage.Id, stage.Default_Predecessor_Stage_ID__C);
                    if(!DefaultPredecessorIdSet.contains(stage.Default_Predecessor_Stage_ID__C))
                    {
                        DefaultPredecessorIdSet.add(stage.Default_Predecessor_Stage_ID__C);
                    }
                }
            }
            List<Release_Stage__c> rsPredecessors = [
                    select Id,Stage_ID__C
                    from Release_Stage__c
                    where Stage_ID__C in :DefaultPredecessorIdSet and Offering_Release_ID__c = :offeringReleaseId
                ];
            Map<Id,ID> StagePredecessorMap = new Map<Id,ID>();
            for(Release_Stage__c releaseStage:rsPredecessors)
            {
                for(Id stageId:DefaultPredecessorStageIDMap.keySet())
                {
                    if(DefaultPredecessorStageIDMap.get(stageId) == releaseStage.Stage_ID__C)
                    {
                        StagePredecessorMap.put(stageId, releaseStage.Id);
                    }
                }
            }
            for(Release_Stage__c rs:rscs)
            {
                //SQL improvement Hunter 2 
                /*Stage__c stage = [
                    select Default_Predecessor_Stage_ID__C 
                    from Stage__c
                    where Id = :rs.Stage_ID__C
                ];
                
                List<Release_Stage__c> rsPredecessor = [
                    select Id 
                    from Release_Stage__c
                    where Stage_ID__C = :stage.Default_Predecessor_Stage_ID__C and Offering_Release_ID__c = :rs.Offering_Release_ID__c
                ];*/
                if(StagePredecessorMap.containsKey(rs.Stage_ID__c))
                {
                    rs.Predecessor_Release_Stage_ID__c = StagePredecessorMap.get(rs.Stage_ID__c);
                    update rs;
                }
            }
        }
    }
    
    //copy deliverable from flight plan templete as release deliverable for specify offering release
    public static void AutoLoadReleaseDeliverable(String flightPlanId, String offeringReleaseId, Set<Id> startupDeliverables)
    {
         List<Flight_Plan_Deliverable__c> fpDeliverables = [Select Id,Deliverable__c,Deliverable_Name__c,Conditional__c,Conditional_Text__c,Default_Include__c,
                                                           Deliverable__r.CurrencyIsoCode,//Deliverable__r.RecordType.Name,
                                                           Deliverable__r.Is_Active__c,
                                                           Deliverable__r.Review_Criteria__c,
                                                           Deliverable__r.Stage_Material__c
                                                           From Flight_Plan_Deliverable__c
                                                           Where Flight_Plan__c = :flightPlanId];

        for(Flight_Plan_Deliverable__c fpdc:fpDeliverables)
        {
            if(startupDeliverables != null && startupDeliverables.contains(fpdc.Deliverable__c))
            {
                continue;
            }
            
            Release_Deliverable__c c = new Release_Deliverable__c(
                Offering_Release__c = offeringReleaseId,
                Deliverable_ID__c = fpdc.Deliverable__c,
                Conditional__c = fpdc.Conditional__c,
                Conditional_Text__c = fpdc.Conditional_Text__c,
                CurrencyIsoCode = fpdc.Deliverable__r.CurrencyIsoCode,
                Include__c = fpdc.Default_Include__c,
                Review_Criteria__c = fpdc.Deliverable__r.Review_Criteria__c,
                Stage_Material__c = fpdc.Deliverable__r.Stage_Material__c,
                //Is_Active__c = fpdc.Deliverable__r.Is_Active__c,
                Release_Deliverable_Name__c = fpdc.Deliverable_Name__c
            );
            //if(fpdc.Deliverable__r.RecordType.Name != null)
            //{
            //    c.RecordTypeId = PLMTransferTools.TransferRecordType(fpdc.Deliverable__r.RecordType.Name,'Release_Deliverable__c');
            //}
            insert c;
            //ODP_Class_CommonTools.CopyAttachmentToOtherObject(fpdc.Id, c.Id);
        }
    }
    
    public static void AutoLoadReleaseDeliverable(String flightPlanId, String offeringReleaseId)
    {
        AutoLoadReleaseDeliverable(flightPlanId,offeringReleaseId,null);
    }
    
    //copy work element from flight plan templete as stage work element for specify release deliverable
    public static ODP_Class_FunctionResult AutoLoadStageWorkElementByDeliverable(String releaseDeliveableId)
    {
        ODP_Class_FunctionResult result = new ODP_Class_FunctionResult();
        //try{
            List<Release_Deliverable__c> releaseDeliverables = [select Deliverable_ID__c,Offering_Release__c 
                                                 from Release_Deliverable__c where Id = :releaseDeliveableId];
            if(releaseDeliverables.size() < 1)
            {
                result.Success = false;
                result.Error = 'can not found release Deliveralbe '+ releaseDeliveableId +', please check the parameter.';
                return result;
            }
            Release_Deliverable__c releaseDeliverable = releaseDeliverables[0];
            Set<Id>  StageIdSet = new Set<ID>(); //SOQL improvement Hunter 3
            List<Work_Element__c> workElements = [
                select Id,CurrencyIsoCode,Days_to_review__c,Description__c,Deliverable_ID__c,Stage_ID__c,
                Is_Active__c,Name__c,Review_Required__c,Work_Instructions__c, Help_Description__c, Accountable_Role__c
                from Work_Element__c where Deliverable_ID__c = :releaseDeliverable.Deliverable_ID__c];
            if(workElements.size() < 1)
            {
                result.Success = false;
                result.Error = 'for this release Deliverable, can not find related work element for load.';
                return result;
            }
            //SOQL improvement Hunter 3
            for(Work_Element__c wec:workElements)
            {
                if(!StageIdSet.contains(wec.Stage_ID__c))
                {
                    StageIdSet.add(wec.Stage_ID__c);
                }
            }
            List<Release_Stage__c> releaseStages = [
                    select Id,Stage_ID__c
                    from Release_Stage__c 
                    where Stage_ID__c in :StageIdSet and Offering_Release_ID__c = :releaseDeliverable.Offering_Release__c];
            //SOQL improvement Hunter 3 end
        
            List<Stage_Work_Element__c> insertStageWorkElements = new List<Stage_Work_Element__c>();
            
            for(Work_Element__c workElement:workElements)
            {
                //SOQL improvement Hunter 3
                //List<Release_Stage__c> releaseStages = [
                //    select Id
                //   from Release_Stage__c 
                //   where Stage_ID__c = :workElement.Stage_ID__c and Offering_Release_ID__c = :releaseDeliverable.Offering_Release__c];
                Release_Stage__c releaseStage = null;
                for(Release_Stage__c rs:releaseStages)
                {
                    if(rs.Stage_ID__c == workElement.Stage_ID__c)
                    {
                        releaseStage = rs;
                        break;
                    }
                }
                //SOQL improvement Hunter 3 end
                
                if(releaseStage != null) //(releaseStages.Size() > 0) //SOQL improvement Hunter 3
                {
                    Stage_Work_Element__c stageWorkElement = new Stage_Work_Element__c(
                        Release_Deliverable_ID__c = releaseDeliveableId,
                        Release_Stage_ID__c = releaseStage.ID, //releaseStages[0].Id, //SOQL improvement Hunter 3
                        CurrencyIsoCode = workElement.CurrencyIsoCode,
                        Days_To_Review__c = workElement.Days_To_Review__c,
                        Description_Text_Area__c = workElement.Description__c,
                        Help_Description__c = workElement.Help_Description__c,
                        //Is_Active__c = workElement.Is_Active__c,
                        Name__c = workElement.Name__c,
                        //Review_Criteria__c = workElement.Review_Criteria__c,
                        Review_Required__c = workElement.Review_Required__c,
                        Work_Instructions__c = workElement.Work_Instructions__c,
                        Work_Element_ID__c = workElement.Id,
                        Accountable_Role__c = workElement.Accountable_Role__c,
                        Optional__c = workElement.Optional__c
                    );
                    insertStageWorkElements.add(stageWorkElement);
                }
            }
        
            if(insertStageWorkElements.size() < 1)
            {
                result.Success = false;
                result.Error = 'for this release Deliverable, All the related work element did not have proper related release Stage, no workelement for load.';
                return result;
            }
            
            insert insertStageWorkElements;
            List<Contributor__c> insertContributors = new List<Contributor__c>();
            List<Review__c> insertReviewers = new List<Review__c>();
            List<Stage_Work_Element_Predecessor__c> insertSWEPredecessors = new List<Stage_Work_Element_Predecessor__c>();
            List<Release_Role__c> insertReleaseRole = new List<Release_Role__c>();
            List<Release_Role__c> updateReleaseRole = new List<Release_Role__c>();
        
            //SOQL improvement Hunter 3
            Set<Id> WorkElementIDSet = new Set<Id>();

            Map<Id,Release_Role__c> releaseRuleMap = new Map<Id,Release_Role__c>(); // for accountable rule, contributor rule, review rule insert update
        
            for(Stage_Work_Element__c stageWorkElement:insertStageWorkElements)
            {
                if(!releaseRuleMap.containsKey(stageWorkElement.Accountable_Role__c))
                {
                    releaseRuleMap.put(stageWorkElement.Accountable_Role__c, new Release_Role__c(
                        Offering_Release__c = releaseDeliverable.Offering_Release__c,
                        Role_ID__c = stageWorkElement.Accountable_Role__c,
                        Accountable__c = true,
                        Contributor__c = false,
                        Reviewer__c = false
                    ));
                }
                if(!WorkElementIDSet.contains(stageWorkElement.Work_Element_ID__c))
                {
                    WorkElementIDSet.add(stageWorkElement.Work_Element_ID__c);
                }
            }
        
            //instead of the trigger for ODP_Trigger_FPLoadRelRoleFromCont begin
            List<Work_Element_Contributor_Role__c> workElementContributorRoles = [
                        select Role_ID__c,Work_Element_ID__c
                        from Work_Element_Contributor_Role__c
                        where Work_Element_ID__c in :WorkElementIDSet
                    ];
            for(Work_Element_Contributor_Role__c wecr:workElementContributorRoles)
            {
                if(!releaseRuleMap.containsKey(wecr.Role_ID__c))
                {
                    releaseRuleMap.put(wecr.Role_ID__c, new Release_Role__c(
                        Offering_Release__c = releaseDeliverable.Offering_Release__c,
                        Role_ID__c = wecr.Role_ID__c,
                        Accountable__c = false,
                        Contributor__c = true,
                        Reviewer__c = false
                    ));
                }
                else
                {
                    Release_Role__c rr = releaseRuleMap.get(wecr.Role_ID__c);
                    rr.Contributor__c = true;
                    releaseRuleMap.put(wecr.Role_ID__c, rr);
                }
            }
        
            List<Work_Element_Reviewer_Role__c> workElementReviewerRoles = [
                    select Role_ID__c,Work_Element_ID__c
                    from Work_Element_Reviewer_Role__c
                    where Work_Element_ID__c in :WorkElementIDSet
                ];
            for(Work_Element_Reviewer_Role__c werr:workElementReviewerRoles)
            {
                if(!releaseRuleMap.containsKey(werr.Role_ID__c))
                {
                    releaseRuleMap.put(werr.Role_ID__c, new Release_Role__c(
                        Offering_Release__c = releaseDeliverable.Offering_Release__c,
                        Role_ID__c = werr.Role_ID__c,
                        Accountable__c = false,
                        Contributor__c = false,
                        Reviewer__c = true
                    ));
                }
                else
                {
                    Release_Role__c rr = releaseRuleMap.get(werr.Role_ID__c);
                    rr.Reviewer__c = true;
                    releaseRuleMap.put(werr.Role_ID__c, rr);
                }
            }
        

            List<Release_Role__c> ExisRolesList = [select id,Role_ID__c
                             From Release_Role__c where Offering_Release__c =:releaseDeliverable.Offering_Release__c];
            for(ID ruleId:releaseRuleMap.keySet())
            {
                boolean ruleIsNotExists = true;
                Release_Role__c updaterole = null;
                for(Release_Role__c rr:ExisRolesList)
                {
                    if(rr.Role_ID__c == ruleId)
                    {
                        ruleIsNotExists = false;
                        updaterole = rr;
                        break;
                    }
                }
                if(ruleIsNotExists)
                {
                    insertReleaseRole.add(releaseRuleMap.get(ruleId));
                }
                else
                {
                    Release_Role__c mapRole = releaseRuleMap.get(ruleId);
                    if(mapRole.Accountable__c)
                    {
                        updaterole.Accountable__c = true;
                    }
                    if(mapRole.Contributor__c)
                    {
                        updaterole.Contributor__c = true;
                    }
                    if(mapRole.Reviewer__c)
                    {
                        updaterole.Reviewer__c = true;
                    }
                    updateReleaseRole.add(updaterole);
                }
            }
        
            //instead of the trigger for ODP_Trigger_FPLoadRelRoleFromCont end

            List<WorkElementPredecessor__c> WEPredecessors =[
                    select id, Work_Element_ID__c, Predecessor_Work_Element_ID__c 
                    from WorkElementPredecessor__c
                    where Work_Element_ID__c  in : WorkElementIDSet
                ];
            Set<Id> PredecessorWorkElementIDSet = new Set<Id>();
            for(WorkElementPredecessor__c wep:WEPredecessors)
            {
                if(!PredecessorWorkElementIDSet.contains(wep.Predecessor_Work_Element_ID__c))
                {
                    PredecessorWorkElementIDSet.add(wep.Predecessor_Work_Element_ID__c);
                }
            }
            List<stage_work_element__c> preSwe = [select id,Work_Element_ID__c from stage_work_element__c 
                               where Work_Element_ID__c in :PredecessorWorkElementIDSet and Release_Stage_ID__r.Offering_Release_ID__c = :releaseDeliverable.Offering_Release__c];
            //SOQL improvement Hunter 3 end
            
            for(Stage_Work_Element__c stageWorkElement:insertStageWorkElements)
            {
                //SOQL improvement Hunter 3
                /*List<Release_Role__c> findReleaseRoles = [select Id from Release_Role__c 
                     where Offering_Release__c=:releaseDeliverable.Offering_Release__c and Role_ID__c=:stageWorkElement.Accountable_Role__c];
                */
                //SOQL improvement Hunter 3 
                /*boolean ruleIsnotExists = true;
                for(Release_Role__c rrc:findReleaseRoles)
                {
                    if(rrc.Role_ID__c == stageWorkElement.Accountable_Role__c)
                    {
                        ruleIsnotExists = false;
                        break;
                    }
                }
                //SOQL improvement Hunter 3 end
                if(ruleIsnotExists) //condition change for SOQL improvement Hunter 3 
                {
                    Release_Role__c insertReleaseRole = new Release_Role__c(
                        Offering_Release__c = releaseDeliverable.Offering_Release__c,
                        Role_ID__c = stageWorkElement.Accountable_Role__c,
                        Accountable__c = true
                    );
                    insert insertReleaseRole;
                }*/
                
                //SOQL improvement Hunter 3
                /*List<Work_Element_Contributor_Role__c> workElementContributorRoles = [
                    select Role_ID__c
                    from Work_Element_Contributor_Role__c
                    where Work_Element_ID__c = :stageWorkElement.Work_Element_ID__c
                ];*/
                for(Work_Element_Contributor_Role__c wec:workElementContributorRoles)
                {
                    if(wec.Work_Element_ID__c == stageWorkElement.Work_Element_ID__c) //SOQL improvement Hunter 3 for add new condition to filter following work element
                    {
                        Contributor__c contributor = new Contributor__c(
                            Role__c = wec.Role_ID__c,
                            Stage_Work_Element__c = stageWorkElement.Id
                        );
                        insertContributors.add(contributor);
                    }
                }
                
                //SOQL improvement Hunter 3
                /*List<Work_Element_Reviewer_Role__c> workElementReviewerRoles = [
                    select Role_ID__c
                    from Work_Element_Reviewer_Role__c
                    where Work_Element_ID__c = :stageWorkElement.Work_Element_ID__c
                ];*/
                for(Work_Element_Reviewer_Role__c wer:workElementReviewerRoles)
                {
                    if(wer.Work_Element_ID__c == stageWorkElement.Work_Element_ID__c) //SOQL improvement Hunter 3 for add new condition to filter following work element
                    {
                        Review__c reviewer = new Review__c(
                            Role__c = wer.Role_ID__c,
                            Stage_Work_Element__c = stageWorkElement.Id
                        );
                        insertReviewers.add(reviewer);
                    }
                }
                
                //Copy work element predecessors to stage work element predecessors
                //SOQL improvement Hunter 3
                /*List<WorkElementPredecessor__c> WEPredecessors =[
                    select id, Work_Element_ID__c, Predecessor_Work_Element_ID__c 
                    from WorkElementPredecessor__c
                    where Work_Element_ID__c =: stageWorkElement.Work_Element_ID__c
                ];*/
                for(WorkElementPredecessor__c wep: WEPredecessors){
                    if(wep.Work_Element_ID__c == stageWorkElement.Work_Element_ID__c) //SOQL improvement Hunter 3 for add new condition to filter following work element
                    {
                        /*List<stage_work_element__c> preSwe = [select id from stage_work_element__c 
                               where Work_Element_ID__c =:wep.Predecessor_Work_Element_ID__c and Release_Stage_ID__r.Offering_Release_ID__c = :releaseDeliverable.Offering_Release__c];
                        if(preSwe.Size() > 0) */ //SOQL improvement Hunter 3 
                        for(stage_work_element__c swe:preSwe)
                        {
                            if(swe.Work_Element_ID__c == wep.Predecessor_Work_Element_ID__c)
                            {
                                Stage_Work_Element_Predecessor__c stgWEP = new Stage_Work_Element_Predecessor__c(
                                    Stage_Work_Element__c = stageWorkElement.Id,
                                    Work_Element__c = wep.Predecessor_Work_Element_ID__c, //predecessorr work element
                                    Predecessor_Stage_Work_Element_ID__c = swe.id                 
                                );
                                insertSWEPredecessors.add(stgWEP);
                            }
                        }
                    }
                }
            }
                
            if(insertContributors.size() > 0)
            {
                insert insertContributors;
            }
            if(insertReviewers.size() > 0)
            {
                insert insertReviewers;
            }
            if(insertSWEPredecessors.Size() > 0)
            {
                insert insertSWEPredecessors;
            }
            if(insertReleaseRole.size() > 0)
            {
                insert insertReleaseRole;
            }
            if(updateReleaseRole.size() > 0)
            {
                update updateReleaseRole;
            }
            result.Success = true;
        //}
        /*catch(Exception ex)
        {
            result.Success = false;
            result.Error  = ex.getMessage();
        }*/
        return result;
    }
    
    public static ODP_Class_FunctionResult AutoLoadStageWorkElementByRelStage(String releaseStageId)
    {
        ODP_Class_FunctionResult result = new ODP_Class_FunctionResult();
        
        List<Release_Stage__c> releaseStages = [select Stage_ID__c,Offering_Release_ID__c 
                                                            from Release_Stage__c where Id = :releaseStageId];
        if(releaseStages.size() < 1)
        {
            result.Success = false;
            result.Error = 'can not found release Stage '+ releaseStageId +', please check the parameter.';
            return result;
        }
        Release_Stage__c releaseStage = releaseStages[0];
        Set<Id>  DeliverableIdSet = new Set<ID>(); //SOQL improvement Hunter 3
        List<Work_Element__c> workElements = [
            select Id,CurrencyIsoCode,Days_to_review__c,Description__c,Deliverable_ID__c,Stage_ID__c,
            Is_Active__c,Name__c,Review_Required__c,Work_Instructions__c, Help_Description__c, Accountable_Role__c,Optional__c
            from Work_Element__c where Stage_ID__c = :releaseStage.Stage_ID__c];
        if(workElements.size() < 1)
        {
            result.Success = false;
            result.Error = 'for this release Deliverable, can not find related work element for load.';
            return result;
        }
        
        for(Work_Element__c wec:workElements)
        {
            if(!DeliverableIdSet.contains(wec.Deliverable_ID__c))
            {
                DeliverableIdSet.add(wec.Deliverable_ID__c);
            }
        }
        
        //get all deliverables for the same offering lease and all stage's work elements
        List<Release_Deliverable__c> releaseDeliverables = [
            select Id,Deliverable_ID__c
            from Release_Deliverable__c 
            where Deliverable_ID__c in :DeliverableIdSet and Offering_Release__c = :releaseStage.Offering_Release_ID__c];
        
        
        List<Stage_Work_Element__c> insertStageWorkElements = new List<Stage_Work_Element__c>();
        
        for(Work_Element__c workElement:workElements)
        {
            Release_Deliverable__c releaseDeliverable = null;
            for(Release_Deliverable__c rd:releaseDeliverables)
            {
                if(rd.Deliverable_ID__c == workElement.Deliverable_ID__c)
                {
                    releaseDeliverable = rd;
                    break;
                }
            }
            //each every work element for the release deliverable is exists, add stage work element, else do nothing.
            if(releaseDeliverable != null) 
            {
                Stage_Work_Element__c stageWorkElement = new Stage_Work_Element__c(
                    Release_Deliverable_ID__c = releaseDeliverable.Id,
                    Release_Stage_ID__c = releaseStageId,
                    CurrencyIsoCode = workElement.CurrencyIsoCode,
                    Days_To_Review__c = workElement.Days_To_Review__c,
                    Description_Text_Area__c = workElement.Description__c,
                    Help_Description__c = workElement.Help_Description__c,
                    Name__c = workElement.Name__c,
                    //Review_Criteria__c = workElement.Review_Criteria__c,
                    Review_Required__c = workElement.Review_Required__c,
                    Work_Instructions__c = workElement.Work_Instructions__c,
                    Work_Element_ID__c = workElement.Id,
                    Accountable_Role__c = workElement.Accountable_Role__c,
                    Optional__c = workElement.Optional__c
                );
                insertStageWorkElements.add(stageWorkElement);
            }
        }
        
        if(insertStageWorkElements.size() < 1)
        {
            result.Success = false;
            result.Error = 'for this release Stage, All the related work element did not have proper related release Deliverable, no workelement for load.';
            return result;
        }
        
        insert insertStageWorkElements;
        List<Contributor__c> insertContributors = new List<Contributor__c>();
        List<Review__c> insertReviewers = new List<Review__c>();
        List<Stage_Work_Element_Predecessor__c> insertSWEPredecessors = new List<Stage_Work_Element_Predecessor__c>();
        List<Release_Role__c> insertReleaseRole = new List<Release_Role__c>();
        List<Release_Role__c> updateReleaseRole = new List<Release_Role__c>();
        
        //this set for all the just loaded stage work element. just these work element have been loaded.
        Set<Id> WorkElementIDSet = new Set<Id>();
        //this map for all the loaded release rule, acountable, contributor, reviewer
        Map<Id,Release_Role__c> releaseRuleMap = new Map<Id,Release_Role__c>(); 
        
        for(Stage_Work_Element__c stageWorkElement:insertStageWorkElements)
        {
            if(!releaseRuleMap.containsKey(stageWorkElement.Accountable_Role__c))
            {
                releaseRuleMap.put(stageWorkElement.Accountable_Role__c, new Release_Role__c(
                    Offering_Release__c = releaseStage.Offering_Release_ID__c,
                    Role_ID__c = stageWorkElement.Accountable_Role__c,
                    Accountable__c = true,
                    Contributor__c = false,
                    Reviewer__c = false
                ));
            }
            if(!WorkElementIDSet.contains(stageWorkElement.Work_Element_ID__c))
            {
                WorkElementIDSet.add(stageWorkElement.Work_Element_ID__c);
            }
        }
        
        //instead of the trigger for ODP_Trigger_FPLoadRelRoleFromCont begin
        List<Work_Element_Contributor_Role__c> workElementContributorRoles = [
            select Role_ID__c,Work_Element_ID__c
            from Work_Element_Contributor_Role__c
            where Work_Element_ID__c in :WorkElementIDSet
        ];
        for(Work_Element_Contributor_Role__c wecr:workElementContributorRoles)
        {
            if(!releaseRuleMap.containsKey(wecr.Role_ID__c))
            {
                releaseRuleMap.put(wecr.Role_ID__c, new Release_Role__c(
                    Offering_Release__c = releaseStage.Offering_Release_ID__c,
                    Role_ID__c = wecr.Role_ID__c,
                    Accountable__c = false,
                    Contributor__c = true,
                    Reviewer__c = false
                ));
            }
            else
            {
                Release_Role__c rr = releaseRuleMap.get(wecr.Role_ID__c);
                rr.Contributor__c = true;
                releaseRuleMap.put(wecr.Role_ID__c, rr);
            }
        }
        
        List<Work_Element_Reviewer_Role__c> workElementReviewerRoles = [
            select Role_ID__c,Work_Element_ID__c
            from Work_Element_Reviewer_Role__c
            where Work_Element_ID__c in :WorkElementIDSet
        ];
        for(Work_Element_Reviewer_Role__c werr:workElementReviewerRoles)
        {
            if(!releaseRuleMap.containsKey(werr.Role_ID__c))
            {
                releaseRuleMap.put(werr.Role_ID__c, new Release_Role__c(
                    Offering_Release__c = releaseStage.Offering_Release_ID__c,
                    Role_ID__c = werr.Role_ID__c,
                    Accountable__c = false,
                    Contributor__c = false,
                    Reviewer__c = true
                ));
            }
            else
            {
                Release_Role__c rr = releaseRuleMap.get(werr.Role_ID__c);
                rr.Reviewer__c = true;
                releaseRuleMap.put(werr.Role_ID__c, rr);
            }
        }
        
        
        List<Release_Role__c> ExisRolesList = [select id,Role_ID__c
                                               From Release_Role__c where Offering_Release__c =:releaseStage.Offering_Release_ID__c];
        for(ID ruleId:releaseRuleMap.keySet())
        {
            boolean ruleIsNotExists = true;
            Release_Role__c updaterole = null;
            for(Release_Role__c rr:ExisRolesList)
            {
                if(rr.Role_ID__c == ruleId)
                {
                    ruleIsNotExists = false;
                    updaterole = rr;
                    break;
                }
            }
            if(ruleIsNotExists)
            {
                insertReleaseRole.add(releaseRuleMap.get(ruleId));
            }
            else
            {
                Release_Role__c mapRole = releaseRuleMap.get(ruleId);
                if(mapRole.Accountable__c)
                {
                    updaterole.Accountable__c = true;
                }
                if(mapRole.Contributor__c)
                {
                    updaterole.Contributor__c = true;
                }
                if(mapRole.Reviewer__c)
                {
                    updaterole.Reviewer__c = true;
                }
                updateReleaseRole.add(updaterole);
            }
        }
        //instead of the trigger for ODP_Trigger_FPLoadRelRoleFromCont end
        
        //all the loaded work elements prdecessors.
        List<WorkElementPredecessor__c> WEPredecessors =[
            select id, Work_Element_ID__c, Predecessor_Work_Element_ID__c 
            from WorkElementPredecessor__c
            where Work_Element_ID__c  in : WorkElementIDSet
        ];
        
        //need to load precessor work elements
        Set<Id> PredecessorWorkElementIDSet = new Set<Id>();
        for(WorkElementPredecessor__c wep:WEPredecessors)
        {
            if(!PredecessorWorkElementIDSet.contains(wep.Predecessor_Work_Element_ID__c))
            {
                PredecessorWorkElementIDSet.add(wep.Predecessor_Work_Element_ID__c);
            }
        }
        
        //for these needed need to load precessor work elements which ones have their stage work elements 
        List<stage_work_element__c> preSwe = [select id,Work_Element_ID__c from stage_work_element__c 
                                              where Work_Element_ID__c in :PredecessorWorkElementIDSet and Release_Stage_ID__r.Offering_Release_ID__c = :releaseStage.Offering_Release_ID__c];
        
        //each every loaded stage workelement
        for(Stage_Work_Element__c stageWorkElement:insertStageWorkElements)
        {
            //if its map work element has contributor so add new contributor
            for(Work_Element_Contributor_Role__c wec:workElementContributorRoles)
            {
                if(wec.Work_Element_ID__c == stageWorkElement.Work_Element_ID__c) 
                {
                    Contributor__c contributor = new Contributor__c(
                        Role__c = wec.Role_ID__c,
                        Stage_Work_Element__c = stageWorkElement.Id
                    );
                    insertContributors.add(contributor);
                }
            }
            
            //if its map work element has reviewer so add new reviewer
            for(Work_Element_Reviewer_Role__c wer:workElementReviewerRoles)
            {
                if(wer.Work_Element_ID__c == stageWorkElement.Work_Element_ID__c) 
                {
                    Review__c reviewer = new Review__c(
                        Role__c = wer.Role_ID__c,
                        Stage_Work_Element__c = stageWorkElement.Id
                    );
                    insertReviewers.add(reviewer);
                }
            }
            
            //Copy work element predecessors to stage work element predecessors
            for(WorkElementPredecessor__c wep: WEPredecessors){
                if(wep.Work_Element_ID__c == stageWorkElement.Work_Element_ID__c) 
                {
                    for(stage_work_element__c swe:preSwe)
                    {
                        if(swe.Work_Element_ID__c == wep.Predecessor_Work_Element_ID__c)
                        {
                            Stage_Work_Element_Predecessor__c stgWEP = new Stage_Work_Element_Predecessor__c(
                                Stage_Work_Element__c = stageWorkElement.Id,
                                Work_Element__c = wep.Predecessor_Work_Element_ID__c, 
                                Predecessor_Stage_Work_Element_ID__c = swe.id                 
                            );
                            insertSWEPredecessors.add(stgWEP);
                        }
                    }
                }
            }
        }
        
        if(insertContributors.size() > 0)
        {
            insert insertContributors;
        }
        if(insertReviewers.size() > 0)
        {
            insert insertReviewers;
        }
        if(insertSWEPredecessors.Size() > 0)
        {
            insert insertSWEPredecessors;
        }
        if(insertReleaseRole.size() > 0)
        {
            insert insertReleaseRole;
        }
        if(updateReleaseRole.size() > 0)
        {
            update updateReleaseRole;
        }
        result.Success = true;
        
        return result;
    }
    
    //------------------------for team members allocate------------------------//
    public static void AutoAllocatedMembersForWorkElement(String workElementId)
    {
        Stage_Work_Element__c swe = [select Release_Stage_ID__r.Offering_Release_ID__c,
                                            Accountable_Team_Member__c,Accountable_Role__c
                                        from Stage_Work_Element__c
                                        where Id=:workElementId];
        if(swe.Accountable_Team_Member__c == null)
        {
            Core_Team_Member__c ctm = [select Id
                                        from Core_Team_Member__c
                                        where Accountable__c=true and Release_Role__r.Role_ID__c=:swe.Accountable_Role__c and Release_Role__r.Offering_Release__c=:swe.Release_Stage_ID__r.Offering_Release_ID__c limit 1];
        }
        List<Contributor__c> contributors = [Select Team_Members__c,Role__c
                                                           From Contributor__c
                                                           Where Stage_Work_Element__c=:workElementId and Team_Members__c=null];
        
        
        
    }
    //------------------------for team members allocate end ------------------------//
}