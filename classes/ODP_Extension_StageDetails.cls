public class ODP_Extension_StageDetails {

    public boolean IsBizEngaPartners{get;set;}
    
    public Release_Stage__c rsc{get;set;}
    public List<Stage_Work_Element__c> swecs{get;set;}
    public Integer workElementTotal{get;set;}
    public List<Stage_Review__c> srcs{get;set;}
    public Integer stageReviewTotal{get;set;}
    public List<Action_Item__c> aics{get;set;}
    public Integer actionItemTotal{get;set;}
    
    public List<Attachment> noteattcs{get;set;}
    public Integer noteattcsTotal{get;set;}
    
    public string test{get;set;}
    public string host{get;set;}
    public string CONFIRMATIONTOKEN{get;set;}
    public string stgID{get;set;}
   
    public class StgWEWar{
        public string id{get;set;}
        public string Name{get;set;}
        public string NameC{get;set;}
        public string StatusC{get;set;}
        public Boolean OptionalC{get;set;}
        public Boolean IncludeC{get;set;}
        public Boolean ReviewRequiredC{get;set;}
        public string Warnings{get;set;}
        public String AccountableOwner{get;set;}
        public String AccountableOwnerName{get;set;}
        public String AccSmallPhotoURL{get;set;}
    }
    public List<StgWEWar> StgWEWarList{get;set;}
    
    public string UserID{get;set;}
    public Boolean IsReadyForStgBegin{get;set;}
    public string ErrorCategoryBeginStage{get;set;}
    
    public Boolean IsReadyForStgRew{get;set;}
    public string ErrorCategorySubmitReview{get;set;}
    
    //////////////////////Stage extension propertise ///////////////////////////
    public static string ValidateStageName='Validate Requests';
    public boolean IsValidateStage{get;set;}
    public Stage_extend_Validate__c StageValidate{get;set;}
    
    public static string QuantifyStageName='Qualify Requests';
    public boolean IsQuantifyStage{get;set;}
    public Stage_extend_Quantify__c StageQuantify{get;set;}
    /////.........Resource List.....//////////
    public class Resource{
        public string id{get;set;}
        public string uid{get;set;}
        public String Name{get;set;}
        public string Role{get;set;}
        public string Photo{get;set;}
        public Boolean Contributor{get;set;}
        public Boolean Review{get;set;}
        public Boolean Accountable{get;set;}
    }
    
    public Map<Id,Resource> ResourceMap{get;set;}
    
    public List<Resource> ResourceList{
        get{
            return ResourceMap.values();
        }
    }
    /////////////////////////////////////////////////////////////////////////////
    
    public ODP_Extension_StageDetails(ApexPages.StandardController controller) {
        IsBizEngaPartners = ODP_Class_CommonTools.IsBizEngaPartner();
        host = ApexPages.currentPage().getHeaders().get('Host');
        CONFIRMATIONTOKEN = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
        rsc = (Release_Stage__c)controller.getRecord();
        StgWEWarList = new List<StgWEWar>();
        ResourceMap = new Map<Id,Resource>();
        rsc = [select id,
                      Name,
                      Offering_Release_ID__c,
                      Offering_Release_ID__r.Name,
                      Offering_Release_ID__r.Status__c,
                      Offering_Release_ID__r.Facilitator__c,
                      Offering_Release_ID__r.Facilitator__r.Id,
                      Offering_Release_ID__r.OwnerId,
                      Release_Name__c,
                      Stage_ID__c,
                      Stage_ID__r.Name,
                      Stage_Name__c,
                      Predecessor_Release_Stage_ID__c,
                      Predecessor_Release_Stage_ID__r.Name,
                      Predecessor_Release_Stage_Name__c,
                      Include__c,
                      Status__c,
                      Meeting_Notes__c,
                      Tailoring_Justification__c,
                      Stage_Contract_Approved__c,
                      Iteration_Count__c,
                      Actual_Start_Date__c,
                      Actual_End_Date__c,
                      Current_Baseline_End_Date__c,
                      Initial_Baseline_End_Date__c,
                      LastModifiedBy.Name,
                      PAC_Name__r.Name,
                      PAC_Name__c,
                      PAC_Name__r.CreatedBy.Name,
                      PAC_Name__r.LastModifiedBy.Name,
                      PAC_Decision__c
               from Release_Stage__c
               where id=:rsc.id];
        stgID = rsc.id;
        swecs = [select id,
                       Name,
                       Name__c,
                       Accountable_Team_Member__r.User__r.email,
                       Accountable_Team_Member__r.User__r.SmallPhotourl,
                       Accountable_User__c,
                       Optional__c,
                       Status__c,
                       Include__c,
                       Review_Required__c
                from Stage_Work_Element__c
                where Release_Stage_ID__c=:rsc.id];
        workelEmentTotal = swecs.size();
        
        ///////////////////////Stage Extension Propertise /////////////////////
        IsValidateStage = rsc.Stage_Name__c == ValidateStageName;
            IsQuantifyStage = rsc.Stage_Name__c == QuantifyStageName;
            if(IsValidateStage){
                List<Stage_extend_Validate__c> validateStages = [select Key_Driver__c,Direct_Benefits__c,Indirect_Benefits__c from Stage_extend_Validate__c where Release_Stage_ID__c=:rsc.Id];
                if(validateStages .size() < 1){
                    StageValidate = new Stage_extend_Validate__c();
                    StageValidate.Release_Stage_ID__c=rsc.Id;
                }
                else{
                    StageValidate = validateStages[0];
                }
            }
            if(IsQuantifyStage ){
                List<Stage_extend_Quantify__c> qualifyStages = [
                        select Date_of_Initial_Cost_Estimate__c,Date_of_Revised_Estimate__c,first_year_recurring_cost__c,Initial_Cost_Estimate__c,IT_Risk__c,New_license_required__c,
                               New_Technology_Required__c,Primary_Asset__c,Product_Strategic_Alignment__c,Revised_Cost_Estimate__c,Risk_Mitigation_Proposal__c,Secondary_Asset__c,
                               skills_needed__c,Special_Skills_Mitigation__c,Special_Skills_Required__c,Release_Stage_ID__c,technology_needed__c
                        from Stage_extend_Quantify__c where Release_Stage_ID__c=:rsc.Id];
                if(qualifyStages.size() < 1){
                    StageQuantify = new Stage_extend_Quantify__c();
                    StageQuantify.Release_Stage_ID__c=rsc.Id;
                }
                else{
                    StageQuantify = qualifyStages[0];
                }
            }
        ////////////////////////////////////////////////////////////////////////
        
        for(Stage_Work_Element__c s : swecs ){
            StgWEWar sww =  new StgWEWar();
            sww.id = s.Id;
            sww.Name = s.Name;
            sww.NameC = s.Name__c;
            sww.StatusC = s.Status__c;
            sww.IncludeC = s.Include__c;
            sww.ReviewRequiredC = s.Review_Required__c;
            sww.OptionalC = s.Optional__c;
            sww.AccountableOwner = s.Accountable_Team_Member__r.User__r.email;
            sww.AccSmallPhotoURL = s.Accountable_Team_Member__r.User__r.SmallPhotourl;
            sww.AccountableOwnerName = s.Accountable_User__c;
            sww.Warnings = retSWEWarning(s.Id);
            StgWEWarList.add(sww);
        }
        
        srcs = [select id,
                       Name,
                       PAC_Member_Name__c,
                       Decision__c,
                       Complete__c
                from Stage_Review__c
                where Release_Stage_ID__c =: rsc.id];
        stageReviewTotal = srcs.size();
        aics = [select id,
                       Name,
                       Name__c,
                       Action_Owner__c,
                       PAC_Requestor__c,
                       Status__c
                from Action_Item__c
                where Stage_ID__c=:rsc.id];
        actionItemTotal = aics.size();
        noteattcs = [select id, Name, Description
                    from Attachment
                    where ParentId =: rsc.id]; 
        noteattcsTotal = noteattcs.size();
        
        ///////////////////IF the stage can begin////////////////////////////////////
        UserID = UserInfo.getUserId();
        IsReadyForStgBegin  = true;
        ErrorCategoryBeginStage = '<b>Notification</b> - In order to begin stage, the following conditions should be validated.</br>';
        //Hunter: The user is a PM or Facilitator
        if(UserID != rsc.Offering_Release_ID__r.OwnerId && UserID != rsc.Offering_Release_ID__r.Facilitator__c)
        {
            IsReadyForStgBegin = false;
            ErrorCategoryBeginStage = '- Only BEP are allowed to begin stage.</br>';
        }
        if(rsc.Status__C != 'Not Started'){
            IsReadyForStgBegin = false;
            ErrorCategoryBeginStage = '- The stage has been already begun.</br>';
        }
        
        if(rsc.Offering_Release_ID__r.Status__c != 'In Development')
        {
            IsReadyForStgBegin = false;
            ErrorCategoryBeginStage += '- You are Not allowed to begin the stage because opportunity is not approved (In Development) or on hold.</br>';
        }
        
        if(true){
            //If work element accountable/cont/review role is not assigned team members
            List <Stage_Work_Element__c> sweObjList = [select id, Release_Stage_ID__c, Accountable_Team_Member__c,Optional__c,
                                                       Accountable_Team_Member__r.User__c,
                                                       Accountable_Team_Member__r.User__r.Name,
                                                       Accountable_Team_Member__r.Role_Name__c,
                                                       Accountable_Team_Member__r.User__r.SmallPhotourl
                                                       from stage_work_element__c where Release_Stage_ID__c=: rsc.Id];
            if(sweObjList.size() > 0){
                boolean AccountableValid = true;
                for(Stage_Work_Element__c sweobj : sweObjList ){
                    if(sweobj.Accountable_Team_Member__c == null && sweobj.Optional__c == false){
                        AccountableValid = false;
                    }
                    
                    if(sweobj.Accountable_Team_Member__c != null)
                    {
                        if(ResourceMap.containsKey(sweobj.Accountable_Team_Member__c))
                        {
                            ResourceMap.get(sweobj.Accountable_Team_Member__c).Accountable = true;
                        }
                        else
                        {
                            Resource r = new Resource();
                            r.Id = sweobj.Accountable_Team_Member__c;
                            r.uid= sweobj.Accountable_Team_Member__r.User__c;
                            r.Name = sweobj.Accountable_Team_Member__r.User__r.Name;
                            r.Role = sweobj.Accountable_Team_Member__r.Role_Name__c;
                            r.Photo = sweobj.Accountable_Team_Member__r.User__r.SmallPhotourl;
                                
                            r.Contributor = false;
                            r.Review = false;
                            r.Accountable = true;
                            ResourceMap.put(sweobj.Accountable_Team_Member__c, r);
                        }
                    }
                }
                if(AccountableValid == false){
                    IsReadyForStgBegin = false;
                        ErrorCategoryBeginStage += '- You are NOT allowed to start current stage due to unassigned accountable roles for work elements</br>'; 
                }
            }
            List <Contributor__c> contList = [select id, Team_Members__c, Stage_Work_Element__r.Release_Stage_ID__c,Stage_Work_Element__r.Optional__c,
                                              Team_Members__r.User__c, 
                                                                          Team_Members__r.User__r.Name,
                                              Team_Members__r.Role_Name__c,
                                              Team_Members__r.User__r.SmallPhotourl
                                              from Contributor__c where Stage_Work_Element__r.Release_Stage_ID__c =: rsc.Id];
            if(contList.size() > 0){
                boolean ContributorValid = true;
                for(Contributor__c ccobj : contList ){
                    if(ccobj.Team_Members__c == null && ccobj.Stage_Work_Element__r.Optional__c == true){
                        ContributorValid = false;
                    }
                    
                    if(ccobj.Team_Members__c != null)
                    {
                        if(ResourceMap.containsKey(ccobj.Team_Members__c))
                        {
                            ResourceMap.get(ccobj.Team_Members__c).Contributor = true;
                        }
                        else
                        {
                            Resource r = new Resource();
                            r.Id = ccobj.Team_Members__c;
                            r.uid = ccobj.Team_Members__r.User__c;
                            r.Name = ccobj.Team_Members__r.User__r.Name;
                            r.Role = ccobj.Team_Members__r.Role_Name__c;
                            r.Photo = ccobj.Team_Members__r.User__r.SmallPhotourl;
                                
                            r.Contributor = true;
                            r.Review = false;
                            r.Accountable = false;
                            ResourceMap.put(ccobj.Team_Members__c, r);
                        }
                    }
                }
                if(ContributorValid == false){
                    IsReadyForStgBegin = false;
                        ErrorCategoryBeginStage += '- You are NOT allowed to start current stage due to unassigned Contribution roles for work elements</br>'; 
                }
            }
            List <Review__c> rewList = [select id, Team_Member__c,  Stage_Work_Element__r.Release_Stage_ID__c,Stage_Work_Element__r.Optional__c,
                                        Team_Member__r.User__c,
                                        Team_Member__r.User__r.Name,
                                        Team_Member__r.Role_Name__c,
                                        Team_Member__r.User__r.SmallPhotourl
                                        from Review__c where Stage_Work_Element__r.Release_Stage_ID__c =: rsc.Id];
            if(rewList.size() > 0){
                boolean ReviewValid = true;
                for(Review__c rewobj : rewList ){
                    if(rewobj.Team_Member__c == null && rewobj.Stage_Work_Element__r.Optional__c == true){
                        ReviewValid = false;
                    }
                    if(rewobj.Team_Member__c != null)
                    {
                        if(ResourceMap.containsKey(rewobj.Team_Member__c))
                        {
                            ResourceMap.get(rewobj.Team_Member__c).Review = true;
                        }
                        else
                        {
                            Resource r = new Resource();
                            r.Id = rewobj.Team_Member__c;
                            r.uid = rewobj.Team_Member__r.User__c;
                            r.Name = rewobj.Team_Member__r.User__r.Name;
                            r.Photo = rewobj.Team_Member__r.User__r.SmallPhotourl;
                            r.Role = rewobj.Team_Member__r.Role_Name__c;
                            
                                
                            r.Contributor = false;
                            r.Review = true;
                            r.Accountable = false;
                            ResourceMap.put(rewobj.Team_Member__c, r);
                        }
                    }
                }
                if(ReviewValid == false){
                    IsReadyForStgBegin = false;
                        ErrorCategoryBeginStage += '- You are NOT allowed to start current stage due to unassigned Review roles for work elements</br>'; 
                }
            }
        }
        
        ////////////////IF the stage can submit for review/////////////////////////////////
        ErrorCategorySubmitReview = '<b>Notification</b> - In order to submit stage review , the following conditions should be validated.</br>';
        IsReadyForStgRew = true;
        if(UserID != rsc.Offering_Release_ID__r.Facilitator__r.Id && UserID != rsc.Offering_Release_ID__r.OwnerId){
            IsReadyForStgRew = false;
            ErrorCategorySubmitReview += '- Only BEP are allowed to submit stage to review.</br>';
        }
        
        if(rsc.Predecessor_Release_Stage_ID__c != null)
        {
            Release_Stage__c predecessorStage = [select Status__c,Stage_Name__c from Release_Stage__c where Id=:rsc.Predecessor_Release_Stage_ID__c limit 1];
            if(predecessorStage.Status__c != 'Complete')
            {
                 IsReadyForStgRew = false;
                 ErrorCategorySubmitReview = ErrorCategorySubmitReview + '- The predecessor stage[' + predecessorStage.Stage_Name__c + '] is not completed, It must be completed before submit current stage review.</br>';
            }
        }
        
        if(rsc.Offering_Release_ID__r.Status__c != 'In Development')
        {
            IsReadyForStgRew = false;
            ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because opportunity is not approved (In Development) or on hold.</br>';
        }
        
        if(rsc.Status__c != 'In Progress'){
            IsReadyForStgRew = false;
            ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because stage is not In Progress.</br>';
        }
        else{
            if(rsc.PAC_Name__c == null){
                IsReadyForStgRew = false;
                ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because None PAC Name Defined.</br>';
            }
            
            List<Stage_Review__c> reviewerList = [Select Id from Stage_Review__c where Release_Stage_ID__c=:rsc.Id];
            if(reviewerList.size() < 1)
            {
                IsReadyForStgRew = false;
                ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because none stage review</br>';
            }
            
            List<Stage_Work_Element__c>  sweList = [select Name__c,id,Status__c,Text__c,Release_Deliverable_ID__r.Stage_Material__c,lastmodifiedDate from Stage_Work_Element__c where Release_Stage_ID__c =: rsc.Id and Optional__c=false];  
            if(sweList.size() > 0){
                for(Stage_Work_Element__c sweobj : sweList){
                    if(sweobj.status__c != 'Complete'){
                        IsReadyForStgRew = false;
                        ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because the work element[' + sweobj.Name__c + '] has not been completed yet.</br>';
                    }    
                }
            }
            
            List <Action_Item__c> AIList = [select id, Stage_ID__c, Name__c, Status__c from Action_Item__c where Stage_ID__c =:rsc.Id];
            if(AIList.size() > 0){
                for(Action_Item__c AIObj : AIList ){
                    if(AIObj.Status__c == 'In Progress'){
                        IsReadyForStgRew = false;
                        ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because the action item[' + AIObj.Name__c + '] has not completed yet.</br>';
                    }
                }
            }
        }
    }
    
    public String retSWEWarning(String weid){
        String ret = '';
        Stage_Work_Element__c sc = [select id, Accountable_Team_Member__c, Accountable_User__c from Stage_Work_Element__c where id =: weid];
        if(sc.Accountable_Team_Member__c  == null){
            ret = ret + 'Accountable Not Provided \n';
        }
        List<Contributor__c> cc = [select id, Team_Member_Name__c from Contributor__c where Stage_Work_Element__c =: weid and Team_Members__c = null];  
        if(cc.size() > 0){
            ret = ret + 'Contributor Not Provided \n';
        }
        List<Review__c> rc = [select id, Team_Member_Name__c from Review__c where Stage_Work_Element__c =: weid and Team_Member__c = null and Stage_Work_Element__r.Review_Required__c = true];  
        if(Rc.size() > 0){
            ret = ret + 'Reviewer Not Provided \n';
        }
        System.debug('-------------------------------NK'+ret+'---');
        return ret;        
    }

    public PageReference BeginStage(){
        try{
            if(IsReadyForStgBegin){
                rsc.Status__c = 'In Progress';
                update rsc;
                PageReference STGPage = new PageReference('/'+rsc.Id);
                STGPage.setRedirect(true);
                return STGPage;
                
            }
            else
            {
                return null;
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'Operation Failed: begin stage exception, Please contact IT administrators if any assistance needed'));
            return null;
        } 
    }
    
    public PageReference StartStageReview(){
        //2, VF - when user submits Stage for Stage Review, --- the system requests confirmation from the user to proceed with the stage review submittal--- system performs the following:1. changes the Stage status from ‘In Progress’ to ‘Under Review’2. ‘locks’ stage data3. sends notifications to PAC members4. notifies PM that their project request for Stage Review was approved.
        try{
            if(IsReadyForStgRew){
                rsc.Status__c = 'In Review';
                update rsc;
                PageReference STGPage = new PageReference('/'+rsc.Id);
                STGPage.setRedirect(true);
                return STGPage;
            }
            else
            {
                return null;
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'Operation Failed: submit stage review exception. Please contact IT administrators if any assistance needed'));
            return null;
        } 
    }
}